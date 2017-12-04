<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.example.guestbook.GroupInfo" %>
<%@ page import="com.example.guestbook.Group" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>

<%
    String groupName = request.getParameter("groupName");
    if (groupName == null) {
        groupName = "default";
    }
    pageContext.setAttribute("groupName", groupName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
        pageContext.setAttribute("user", user);
%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
    <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
    <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
    to include your name with groupInfos you post.</p>
<%
    }
%>

<%-- //[START datastore]--%>
<%
    // Create the correct Ancestor key
      Key<Group> theGroup = Key.create(Group.class, groupName);

    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Group.
      List<GroupInfo> groupInfos = ObjectifyService.ofy()
          .load()
          .type(GroupInfo.class) // We want only GroupInfo
          .ancestor(theGroup)    // Anyone in this book
          .list();

    if (groupInfos.isEmpty()) {
%>
<p>Guestbook '${fn:escapeXml(groupName)}' has no messages.</p>
<%
    } else {
%>
<p>Messages in Guestbook '${fn:escapeXml(groupName)}'.</p>
<%
      // Look at all of our groupInfos
        for (GroupInfo groupInfo : groupInfos) {
            pageContext.setAttribute("greeting_content");
            String author;
            if (groupInfo.students_email == null) {
                author = "An anonymous person";
            } else {
                author = groupInfo.students_email.get(0);
                String author_id = groupInfo.students_email.get(0);
                if (user != null && user.getUserId().equals(author_id)) {
                    author += " (You)";
                }
            }
            pageContext.setAttribute("greeting_user", author);
%>
<p><b>${fn:escapeXml(greeting_user)}</b> wrote:</p>
<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
<%
        }
    }
%>

<form action="/sign" method="post">
    <div><textarea name="content" rows="3" cols="60"></textarea></div>
    <div><input type="submit" value="Post Greeting"/></div>
    <input type="hidden" name="groupName" value="${fn:escapeXml(groupName)}"/>
</form>
<%-- //[END datastore]--%>
<form action="/attendanceList.jsp" method="get">
    <div><input type="text" name="groupName" value="${fn:escapeXml(groupName)}"/></div>
    <div><input type="submit" value="Switch Group"/></div>
</form>

</body>
</html>
<%-- //[END all]--%>

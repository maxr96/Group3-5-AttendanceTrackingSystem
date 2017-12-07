<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.attendancesystem.Exercise" %>
<%@ page import="com.attendancesystem.Student" %>
<%@ page import="com.attendancesystem.Group" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ page import="com.googlecode.objectify.cmd.LoadType" %>
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
      List<Group> groups = ObjectifyService.ofy()
          .load()
          .type(Group.class)
              .list();
    if (groups.isEmpty() && user != null) {
%>
<p>Please choose a group.</p>
<%
    } else if(user == null){
    }
    else{
%>
<p>Messages in Guestbook '${fn:escapeXml(groupName)}'.</p>
<%
      // Look at all of our groupInfos
        for (Group group : groups) {
            String location = group.location;
            String time = group.time.toString();
            Long groupNumber = group.groupNumber;
            }
           // pageContext.setAttribute("greeting_user", author);
%>
<p><b>${fn:escapeXml(greeting_user)}</b> wrote:</p>
<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
<%
    }
%>

<%-- //[END datastore]--%>
<form action="/attendanceList.jsp" method="get">
    <div><input type="text" name="groupName" value="${fn:escapeXml(groupName)}"/></div>
    <div><input type="submit" value="Switch Group"/></div>
</form>

</body>
</html>
<%-- //[END all]--%>

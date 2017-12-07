package com.attendancesystem;

import com.google.appengine.repackaged.com.google.api.client.util.DateTime;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

import java.util.ArrayList;
import java.util.List;

@Entity
public class Exercise {
    @Id public String time;

    public List<Key<Student>> presentStudents =  new ArrayList<Key<Student>>();
    public List<Key<Student>> presentedStudents = new ArrayList<Key<Student>>();

    public Exercise(){

    }

    public Exercise(DateTime time, List<String> emails){
        this.time = time.toString();
        for (String email:emails) {
            this.presentStudents.add(Key.create(Student.class, email));
        }
    }

    public Exercise(List<String> emails){
        for (String email:emails){
            this.presentedStudents.add(Key.create(Student.class, email));
        }
    }
}

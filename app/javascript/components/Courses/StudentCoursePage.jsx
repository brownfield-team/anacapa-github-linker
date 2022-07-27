import React from "react";
import { Table,Row, Col, Grid } from "react-bootstrap";

const StudentCoursePage = ({ course, user, roster_student}) => {
    return (
<Table striped bordered condensed hover>
  <thead>
    <tr>
      <th>First Name</th>
      <th>Last Name</th>
      <th>Student Id</th>
      <th>Email</th>
      <th>Enrolled</th>
      <th>Section</th>
      <th>TA</th>
      <th>Slack Id</th>
      <th>Github Id</th>
      <th>Org Status</th>
      <th>Teams</th>      
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>{roster_student.first_name}</td>
      <td>{roster_student.last_name}</td>
      <td>{roster_student.perm}</td>
      <td>{roster_student.email}</td>
      <td>{roster_student.enrolled ? "True" : "False"}</td>
      <td>{roster_student.section}</td>
      <td>{roster_student.is_ta ? "True" : "False"}</td>
      <td>{course.slack_workspace? <a href={ 'https://' + course.slack_workspace + '.slack.com/ssb/redirect '}>{roster_student.slack_user}</a>     : "Unknown"}</td>
      <td><a href={'https://github.com/' + user.username}>{user.username}</a></td>
      <td>{roster_student.org_membership_type}</td>
      <td>{roster_student.org_teams}</td>

    </tr>
  </tbody>
</Table>


    );
    
};



export default StudentCoursePage;

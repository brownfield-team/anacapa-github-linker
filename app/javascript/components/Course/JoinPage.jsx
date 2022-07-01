import React from "react";
import { Panel } from "react-bootstrap";

const JoinPage = ({current_path, course }) => {
    const url = `https://github.com/orgs/${course.course_organization}/invitation`
    return (
        <Panel bsStyle="info" style={{marginTop: "3em"}}>
        <Panel.Heading>
          <Panel.Title componentClass="h3">Your Next Step</Panel.Title>
        </Panel.Heading>
        <Panel.Body>
            <p>You were successfully invited to {course.name}! </p>
            <p> <strong>Now please view and accept your invitation at the following link: </strong> </p>
            <p style={{marginLeft: "2em"}}> <a href={url}>{url}</a></p>
            <p> You are not successfully added to the course until you accept the invitation</p>
        </Panel.Body>
      </Panel>
    );
};



export default JoinPage;

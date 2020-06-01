import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Table, Panel, Button} from "react-bootstrap";
import {studentUiRoute} from "../../../services/teams-service-routes";

class TeamMembersTable extends Component {

    render() {
        return (
            <Panel>
                <Panel.Heading>
                    Members
                </Panel.Heading>
                <Panel.Body>
                    <Table striped bordered hover>
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>GitHub ID</th>
                            <th>Team Role</th>
                        </tr>
                        </thead>
                        <tbody>
                        {this.props.memberships.map(m => {
                            const student = m.roster_student;
                            const studentUrl = studentUiRoute(this.props.match.params.courseId, student.id)
                            const githubUrl = 'https://github.com/' + student.username;
                            return (
                                <Fragment>
                                    <tr>
                                        <td><a href={studentUrl}>{student.full_name}</a></td>
                                        <td><a href={githubUrl}>{student.username}</a></td>
                                        <td>{m.role}</td>
                                    </tr>
                                </Fragment>
                            )
                        })}
                        </tbody>
                    </Table>
                </Panel.Body>
            </Panel>
        );
    }
}

TeamMembersTable.propTypes = {
    memberships: PropTypes.array.isRequired
};

export default TeamMembersTable;
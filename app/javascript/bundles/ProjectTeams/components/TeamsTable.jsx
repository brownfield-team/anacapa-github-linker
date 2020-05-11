import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Table} from "react-bootstrap";
import TeamRow from "./TeamRow";

class TeamsTable extends Component {
    render() {
        return (
            <Fragment>
                <Table striped hover>
                    <thead>
                    <tr>
                        <th className="col-sm-3 px-0">Team Name</th>
                        <th>Meeting Time</th>
                        <th>Project</th>
                        <th>Members</th>
                        <th>GitHub Repo</th>
                        <th>Milestones</th>
                        <th>Project Board</th>
                        <th>QA</th>
                        <th>Production</th>
                        <th>Team Chat</th>
                    </tr>
                    </thead>
                    <tbody>
                    {this.props.teams.map(team =>
                        <TeamRow team={team} key={team.id} />
                    )}
                    {/*<tr>*/}
                    {/*    <td>1</td>*/}
                    {/*    <td>Mark</td>*/}
                    {/*    <td>Otto</td>*/}
                    {/*    <td>@mdo</td>*/}
                    {/*</tr>*/}
                    {/*<tr>*/}
                    {/*    <td>2</td>*/}
                    {/*    <td>Jacob</td>*/}
                    {/*    <td>Thornton</td>*/}
                    {/*    <td>@fat</td>*/}
                    {/*</tr>*/}
                    {/*<tr>*/}
                    {/*    <td>3</td>*/}
                    {/*    <td colSpan="2">Larry the Bird</td>*/}
                    {/*    <td>@twitter</td>*/}
                    {/*</tr>*/}
                    </tbody>
                </Table>
            </Fragment>
        );
    }
}

TeamsTable.propTypes = {
    teams: PropTypes.array.isRequired
};

export default TeamsTable;
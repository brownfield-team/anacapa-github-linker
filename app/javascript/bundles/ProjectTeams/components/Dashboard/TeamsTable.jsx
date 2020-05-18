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
                        <th>Team Name</th>
                        <th>Meeting Time</th>
                        <th>Project</th>
                        <th className="col-sm-3 px-0">Members</th>
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
                        <TeamRow team={team} key={team.id} {...this.props} />
                    )}
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
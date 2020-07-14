import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Table} from "react-bootstrap";
// import TeamRow from "./TeamRow";

class OrgTeamsTable extends Component {
    render() {
        return (
            <Fragment>
                <Table striped hover>
                    <thead>
                    <tr>
                        <th>GitHub Team Name</th>
                        <th className="col-sm-3 px-0">Members</th>
                        <th>Project Team</th>
                    </tr>
                    </thead>
                    <tbody>
                    {this.props.teams.map(team =>
                        <OrgTeamRow team={team} key={team.id} {...this.props} />
                    )}
                    </tbody>
                </Table>
            </Fragment>
        );
    }
}

OrgTeamsTable.propTypes = {
    teams: PropTypes.array.isRequired
};

export default OrgTeamsTable;
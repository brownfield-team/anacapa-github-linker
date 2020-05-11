import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamsTable from "./TeamsTable";
import {Button} from "react-bootstrap";
import AddTeamDialog from "./AddTeamDialog";

class TeamsDashboard extends Component {
    constructor(props) {
        super(props);
        this.state = {addTeamDialogOpen: false}
    }

    toggleAddTeamDialog = () => {
        this.setState({addTeamDialogOpen: !this.state.addTeamDialogOpen})
    }

    render() {
        return (
            <Fragment>
                <AddTeamDialog open={this.state.addTeamDialogOpen} toggleOpen={this.toggleAddTeamDialog} />
                <Button variant="primary" onClick={() => this.toggleAddTeamDialog}>Add Team</Button>
                <TeamsTable teams={this.props.teams} />
            </Fragment>
        );
    }
}

TeamsDashboard.propTypes = {
    teams: PropTypes.array.isRequired
};

export default TeamsDashboard;
import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamsTable from "./TeamsTable";
import {Button} from "react-bootstrap";
import AddTeamDialog from "./AddTeamDialog";
import TeamsService from "../services/teams-service";

class TeamsDashboard extends Component {
    constructor(props) {
        super(props);
        const teamsService = new TeamsService(this.props.course_id);
        this.state = {addTeamDialogOpen: false, teams: this.props.teams, teamsService: teamsService};
    }

    updateTeams = () => {
        this.state.teamsService.getProjectTeams().then(teamsResponse => {
            this.setState({teams: teamsResponse});
        });
    };

    createProjectTeam = () => {

    };

    toggleAddTeamDialog = () => {
        this.setState({addTeamDialogOpen: !this.state.addTeamDialogOpen})
    };

    render() {
        return (
            <Fragment>
                <AddTeamDialog open={this.state.addTeamDialogOpen} toggleOpen={this.toggleAddTeamDialog}/>
                <Button variant="primary" onClick={() => this.toggleAddTeamDialog}>Add Team</Button>
                <TeamsTable teams={this.state.teams} />
            </Fragment>
        );
    }
}

TeamsDashboard.propTypes = {
    course_id: PropTypes.number.isRequired,
    teams: PropTypes.array.isRequired
};

export default TeamsDashboard;
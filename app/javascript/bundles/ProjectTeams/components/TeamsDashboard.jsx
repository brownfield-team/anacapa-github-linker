import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamsTable from "./TeamsTable";
import {Button} from "react-bootstrap";
import AddTeamDialog from "./AddTeamDialog";
import TeamsService from "../services/teams-service";
import '../TeamsDashboard.css';

class TeamsDashboard extends Component {
    constructor(props) {
        super(props);
        const teamsService = new TeamsService(this.props.match.params.courseId);
        this.state = {addTeamDialogOpen: false, teams: [], teamsService: teamsService};
    }


    componentDidMount() {
        this.updateTeams();
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
                <AddTeamDialog open={this.state.addTeamDialogOpen} toggleOpen={this.toggleAddTeamDialog}
                               teamsService={this.state.teamsService}/>
                <Button variant="primary" onClick={() => this.toggleAddTeamDialog}>Add Team</Button>
                <br/>
                <TeamsTable teams={this.state.teams}/>
            </Fragment>
        );
    }
}

export default TeamsDashboard;
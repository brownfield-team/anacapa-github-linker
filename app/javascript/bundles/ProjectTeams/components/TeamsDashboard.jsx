import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamsTable from "./TeamsTable";
import {Button} from "react-bootstrap";
import TeamsService from "../services/teams-service";
import '../TeamsDashboard.css';

class TeamsDashboard extends Component {
    constructor(props) {
        super(props);
        this.state = {teams: []};
    }


    componentDidMount() {
        this.updateTeams();
    }

    updateTeams = () => {
        TeamsService.getProjectTeams(this.props.match.params.courseId).then(teamsResponse => {
            this.setState({teams: teamsResponse});
        });
    };

    createProjectTeam = () => {

    };

    onNewTeamClick = () => {
        this.props.history.push(`${this.props.match.url}/new`);
    };

    render() {
        return (
            <Fragment>
                <Button variant="primary" onClick={() => this.onNewTeamClick()}>Add Team</Button>
                <br/>
                <TeamsTable teams={this.state.teams} {...this.props}/>
            </Fragment>
        );
    }
}

export default TeamsDashboard;
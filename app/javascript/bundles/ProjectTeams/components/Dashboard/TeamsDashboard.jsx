import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamsTable from "./TeamsTable";
import {Button} from "react-bootstrap";
import TeamsService from "../../services/teams-service";

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

    onNewTeamClick = () => {
        const mUrl = this.props.match.url;
        this.props.history.push(mUrl + '/new');
    };

    render() {
        return (
            <Fragment>
                <Button style={{float: 'right'}} bsStyle="primary" onClick={() => this.onNewTeamClick()}>Add Team</Button>
                <Button style={{float: 'right', marginRight: 10}} bsStyle="default" href='org_teams'>All Teams</Button>
                <br/>
                <TeamsTable teams={this.state.teams} {...this.props}/>
            </Fragment>
        );
    }
}

export default TeamsDashboard;
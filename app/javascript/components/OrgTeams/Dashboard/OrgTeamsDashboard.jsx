import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import OrgTeamsTable from "./OrgTeamsTable";
import {Button} from "react-bootstrap";
import OrgTeamsService from "../../../services/orgteams-service";

class OrgTeamsDashboard extends Component {
    constructor(props) {
        super(props);
        this.state = {teams: []};
    }


    componentDidMount() {
        this.updateTeams();
    }

    updateTeams = () => {
        OrgTeamsService.getOrgTeams(this.props.match.params.courseId).then(teamsResponse => {
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
                {/* <Button style={{float: 'right'}} bsStyle="primary" onClick={() => this.onNewTeamClick()}>Add Org Team</Button>
                <br/> */}
                <OrgTeamsTable teams={this.state.teams} {...this.props}/>
            </Fragment>
        );
    }
}

export default OrgTeamsDashboard;
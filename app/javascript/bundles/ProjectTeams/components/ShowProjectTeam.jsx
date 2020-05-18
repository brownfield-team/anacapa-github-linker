import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./Forms/ProjectTeamForm";
import {Col, Row, Grid, ControlLabel, FormControl, FormGroup, Button} from "react-bootstrap";
import ShowProjectTeamField from "./ShowProjectTeamField";

class ShowProjectTeam extends Component {
    render() {
        const t = this.props.projectTeam;
        return (
            <Fragment>
                <Grid componentClass="px-0">
                    <ShowProjectTeamField fieldName={'Team Name'} fieldValue={t.name}/>
                    <ShowProjectTeamField fieldName={'GitHub Team'} fieldValue={t.org_team.name} url={t.org_team.url}/>
                    <ShowProjectTeamField fieldName={'Meeting Time'} fieldValue={t.meeting_time}/>
                    <ShowProjectTeamField fieldName={'Project'} fieldValue={t.project}/>
                    <ShowProjectTeamField fieldName={'Milestones URL'} fieldValue={t.milestones_url}
                                          url={t.milestones_url}/>
                    <ShowProjectTeamField fieldName={'Repo URL'} fieldValue={t.repo_url} url={t.repo_url}/>
                    <ShowProjectTeamField fieldName={'Project Board URL'} fieldValue={t.project_board_url}
                                          url={t.project_board_url}/>
                    <ShowProjectTeamField fieldName={'Team Chat URL'} fieldValue={t.team_chat_url}
                                          url={t.team_chat_url}/>
                    <ShowProjectTeamField fieldName={'QA URL'} fieldValue={t.qa_url} url={t.qa_url}/>
                    <ShowProjectTeamField fieldName={'Production URL'} fieldValue={t.production_url}
                                          url={t.production_url}/>
                </Grid>
                <br />
                <Button bsStyle="primary" onClick={() => this.props.history.push(this.props.match.url + '/edit')}>Edit Team</Button>
            </Fragment>
        );
    }
}

ShowProjectTeam.propTypes = {
    projectTeam: PropTypes.object.isRequired
};

export default ShowProjectTeam;
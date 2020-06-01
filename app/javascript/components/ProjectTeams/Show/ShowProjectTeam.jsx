import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "../Forms/ProjectTeamForm";
import {Grid, Button, Panel} from "react-bootstrap";
import ShowProjectTeamField from "./ShowProjectTeamField";
import TeamMembersTable from "./TeamMembersTable";

class ShowProjectTeam extends Component {
    confirmDeleteTeam = () => {
        if (window.confirm('Are you sure you want to delete this project team?')) {
            this.props.deleteProjectTeam();
        }
    };

    render() {
        const t = this.props.projectTeam;
        return (
            <Fragment>
                <Button bsStyle="link" onClick={() => this.props.history.push('.')}>{"< Dashboard"}</Button>
                <Panel>
                    <Panel.Heading>Info</Panel.Heading>
                    <Panel.Body>
                        <Grid componentClass="px-0">
                            <ShowProjectTeamField fieldName={'Team Name'} fieldValue={t.name}/>
                            <ShowProjectTeamField fieldName={'GitHub Team'} fieldValue={t.org_team.name}
                                                  url={t.org_team.url}/>
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
                    </Panel.Body>
                </Panel>
                <br/>
                <TeamMembersTable memberships={t.student_team_memberships} {...this.props}/>
                <Button bsSize="small" bsStyle="primary"
                        onClick={() => this.props.history.push(this.props.match.url + '/edit')}>Edit Team</Button>
                &nbsp;
                <Button bsSize="small" bsStyle="danger" onClick={() => this.confirmDeleteTeam()}>Delete Team</Button>
            </Fragment>
        );
    }
}

ShowProjectTeam.propTypes = {
    deleteProjectTeam: PropTypes.func.isRequired,
    projectTeam: PropTypes.object.isRequired
};

export default ShowProjectTeam;
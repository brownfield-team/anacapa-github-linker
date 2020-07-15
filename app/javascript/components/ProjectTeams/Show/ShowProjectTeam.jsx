import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "../Forms/ProjectTeamForm";
import { Grid, Button, Panel } from "react-bootstrap";
import DataPairField from "./DataPairField";
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
                            <DataPairField fieldName={'Team Name'} fieldValue={t.name} />
                            <DataPairField fieldName={'GitHub Team'} fieldValue={t.org_team.name}
                                url={t.org_team.url} />
                            <DataPairField fieldName={'Meeting Time Y'} fieldValue={t.meeting_time} />
                            <DataPairField fieldName={'Project'} fieldValue={t.project} />
                            <DataPairField fieldName={'Milestones URL'} fieldValue={t.milestones_url}
                                url={t.milestones_url} />
                            <DataPairField fieldName={'Repo URL'} fieldValue={t.repo_url} url={t.repo_url} />
                            <DataPairField fieldName={'Project Board URL'} fieldValue={t.project_board_url}
                                url={t.project_board_url} />
                            <DataPairField fieldName={'Team Chat URL'} fieldValue={t.team_chat_url}
                                url={t.team_chat_url} />
                            <DataPairField fieldName={'QA URL'} fieldValue={t.qa_url} url={t.qa_url} />
                            <DataPairField fieldName={'Production URL'} fieldValue={t.production_url}
                                url={t.production_url} />
                        </Grid>
                    </Panel.Body>
                </Panel>

                <Panel>
                    <Panel.Heading>Downloads</Panel.Heading>
                    <Panel.Body>
                        <Button bsStyle="btn btn-primary" onClick={() => { console.log("Download Project Repo Commits CSV pressed")}}>{"Download Project Repo Commits CSV"}</Button>
                    </Panel.Body>
                </Panel>

                <br />
                <TeamMembersTable memberships={t.student_team_memberships} {...this.props} />
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
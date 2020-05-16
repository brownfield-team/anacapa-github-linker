import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamsService from "../../services/teams-service";
import {Form, Col, Button, FormGroup, FormControl, ControlLabel} from "react-bootstrap";
import update from "immutability-helper";
import ProjectTeamFormField from "./ProjectTeamFormField";

class ProjectTeamForm extends Component {
    constructor(props) {
        super(props);
        this.state = {orgTeamOptions: [], projectTeam: this.props.projectTeam}
    }

    componentDidMount() {
        this.updateOrgTeamOptions();
    }

    updateOrgTeamOptions = () => {
        TeamsService.getOrgTeams(this.props.match.params.courseId).then(orgTeamsResponse => {
            this.setState({orgTeamOptions: orgTeamsResponse});
        });
    };

    onProjectTeamEdited = (property, value) => {
        const newProjectTeamState = update(this.state.projectTeam, {
            [property]: {$set: value}
        });
        this.setState({projectTeam: newProjectTeamState});
    };

    render() {
        const t = this.props.projectTeam;
        return (
            <Fragment>
                <Form horizontal>

                    <ProjectTeamFormField name={'Team Name'} property={'name'} value={this.state.projectTeam.name}
                                          placeholder={'Name'}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <FormGroup>
                        <Col componentClass={ControlLabel} sm={2}>
                            GitHub Team
                        </Col>
                        <Col sm={10}>
                            <FormControl
                                componentClass="select"
                                value={this.state.projectTeam.org_team_id}
                                onChange={(event) => {
                                    this.onProjectTeamEdited('org_team_id', parseInt(event.target.value))
                                }}>
                                <option value={0}>Select Team</option>
                                {this.state.orgTeamOptions.map(team =>
                                    <option key={team.id} value={team.id}>{team.name}</option>
                                )}
                            </FormControl>
                        </Col>
                    </FormGroup>

                    <ProjectTeamFormField name={'Meeting Time'} property={'meeting_time'}
                                          value={this.state.projectTeam.meeting_time}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <ProjectTeamFormField name={'Project'} property={'project'} value={this.state.projectTeam.project}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <ProjectTeamFormField name={'Milestones URL'} property={'milestones_url'}
                                          value={this.state.projectTeam.milestones_url}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <ProjectTeamFormField name={'Repo URL'} property={'repo_url'}
                                          value={this.state.projectTeam.repo_url}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <ProjectTeamFormField name={'Project Board URL'} property={'project_board_url'}
                                          value={this.state.projectTeam.project_board_url}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <ProjectTeamFormField name={'Team Chat URL'} property={'team_chat_url'}
                                          value={this.state.projectTeam.team_chat_url}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <ProjectTeamFormField name={'QA URL'} property={'qa_url'} value={this.state.projectTeam.qa_url}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>

                    <ProjectTeamFormField name={'Production URL'} property={'production_url'}
                                          value={this.state.projectTeam.production_url}
                                          onProjectTeamEdited={this.onProjectTeamEdited}/>
                    <FormGroup>
                        <Col smOffset={2} sm={10}>
                            <Button
                                bsStyle="primary"
                                onClick={() => this.props.saveProjectTeam(this.state.projectTeam)}>
                                {this.state.projectTeam.id === 0 ?
                                    'Create Team' :
                                    'Save Team'}
                            </Button>
                        </Col>
                    </FormGroup>
                </Form>
            </Fragment>
        );
    }
}

ProjectTeamForm.propTypes = {
    editable: PropTypes.bool.isRequired,
    projectTeam: PropTypes.object.isRequired,
    saveProjectTeam: PropTypes.func.isRequired
};

export default ProjectTeamForm;
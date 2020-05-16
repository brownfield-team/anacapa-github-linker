import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamsService from "../services/teams-service";
import {Form, Col, Button, FormGroup, FormControl, ControlLabel} from "react-bootstrap";
import update from "immutability-helper";

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
                    <FormGroup controlId="formHorizontalEmail">
                        <Col componentClass={ControlLabel} sm={2}>
                            Email
                        </Col>
                        <Col sm={10}>
                            <FormControl type="email" placeholder="Email"/>
                        </Col>
                    </FormGroup>

                    <FormGroup controlId="formHorizontalPassword">
                        <Col componentClass={ControlLabel} sm={2}>
                            Password
                        </Col>
                        <Col sm={10}>
                            <FormControl type="password" placeholder="Password"/>
                        </Col>
                    </FormGroup>

                    <FormGroup>
                        <Col smOffset={2} sm={10}>
                            <Button type="submit">Sign in</Button>
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
    saveProjectTeam: PropTypes.func
};

export default ProjectTeamForm;
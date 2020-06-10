import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Col, ControlLabel, Form, FormControl, FormGroup} from "react-bootstrap";

class ProjectTeamFormField extends Component {
    render() {
        return (
            <FormGroup>
                <Col componentClass={ControlLabel} sm={2}>
                    {this.props.name}
                </Col>
                <Col sm={10}>
                    <FormControl type="text" placeholder={this.props.placeholder ?? this.props.name} value={this.props.value}
                                 onChange={(event) => this.props.onProjectTeamEdited(this.props.property, event.target.value)}/>
                </Col>
            </FormGroup>
        );
    }
}

ProjectTeamFormField.propTypes = {
    name: PropTypes.string.isRequired,
    property: PropTypes.string.isRequired,
    value: PropTypes.string.isRequired,
    onProjectTeamEdited: PropTypes.func.isRequired,
    placeholder: PropTypes.string
};

export default ProjectTeamFormField;
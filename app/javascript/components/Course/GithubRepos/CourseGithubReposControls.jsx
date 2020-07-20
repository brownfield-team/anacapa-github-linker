import React, { Fragment, Component } from 'react';
import PropTypes from 'prop-types';
import { Col, Form, FormControl, FormGroup, ControlLabel, Radio } from "react-bootstrap";

class CourseGithubReposControls extends Component {
    render() {
        return (
            <Form horizontal>
                <FormGroup >
                    <Col xs={3}>
                    <ControlLabel >Visibility</ControlLabel>

                    <FormControl
                        
                        componentClass="select"
                        onChange={(event) => { this.props.onVisibilityChanged(event.target.value) }}>
                        <option value="">All</option>
                        <option value="public">Public</option>
                        <option value="private">Private</option>
                    </FormControl>
                    </Col>
               
                <Col xs={9}>
                    <ControlLabel >Search</ControlLabel>
                    <FormControl
                        
                        type="text"
                        placeholder="Search repo names"
                        onChange={(event) => { this.props.onSearchChanged(event.target.value) }}
                    />
                    </Col>
                </FormGroup>
            </Form>
        );
    }
}

CourseGithubReposControls.propTypes = {
    onSearchChanged: PropTypes.func.isRequired,
    onVisibilityChanged: PropTypes.func.isRequired
};

export default CourseGithubReposControls;

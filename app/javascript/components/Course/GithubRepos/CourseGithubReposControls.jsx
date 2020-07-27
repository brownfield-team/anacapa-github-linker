import React, { Fragment, Component } from 'react';
import PropTypes from 'prop-types';
import { Button, Col, Form, FormControl, FormGroup, ControlLabel, Radio } from "react-bootstrap";
import {debounce} from "debounce";

class CourseGithubReposControls extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "" };
        this.onSearchChanged = debounce(this.onSearchChanged, 500);
    }

    onSearchChanged = (searchValue) => {
        this.setState({search: searchValue});
        this.doTheSearch();
    }

    doTheSearch = () => {
        this.props.performSearch(this.state.search)
    }

    render() {
        return (
            <Form horizontal onSubmit={e => {e.preventDefault(); this.doTheSearch(); return false;}}>
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
                        onChange={(event)=>{this.onSearchChanged(event.target.value)}}
                        onKeyPress={event => {
                            console.log("KeyPress");
                            if (event.key === "Enter") {
                              console.log("Enter");
                              this.doTheSearch();
                            }
                          }}
                    />
                    
                </Col>
                </FormGroup>
            </Form>
        );
    }
}

CourseGithubReposControls.propTypes = {
    performSearch: PropTypes.func.isRequired,
    onVisibilityChanged: PropTypes.func.isRequired
};

export default CourseGithubReposControls;

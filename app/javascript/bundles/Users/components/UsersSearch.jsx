import React, {Fragment, Component} from 'react';
import PropTypes from 'prop-types';
import {Form, FormControl, FormGroup, ControlLabel} from "react-bootstrap";

class UsersSearch extends Component {
    render() {
        return (
            <Form horizontal>
                <FormGroup>
                    <ControlLabel>User Type</ControlLabel>
                    <FormControl
                        componentClass="select"
                        onChange={ (event) => { this.props.onTypeChanged(event.target.value) } }>
                        <option value="">All Users</option>
                        <option value="admin">Admins</option>
                        <option value="instructor">Instructors</option>
                    </FormControl>
                </FormGroup>
                <FormGroup>
                    <ControlLabel>Search</ControlLabel>
                    <FormControl
                        type="text"
                        placeholder="Search users"
                        onChange={ (event) => { this.props.onSearchChanged(event.target.value) } }
                    />
                </FormGroup>
            </Form>
        );
    }
}

UsersSearch.propTypes = {
    onSearchChanged: PropTypes.func.isRequired,
    onTypeChanged: PropTypes.func.isRequired
};

export default UsersSearch;

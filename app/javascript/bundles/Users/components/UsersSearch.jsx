import React, {Fragment, Component} from 'react';
import PropTypes from 'prop-types';
import {Form} from "react-bootstrap";

class UsersSearch extends Component {
    render() {
        return (
            <Fragment>
                <Form.Group>
                    <Form.Label>User Type</Form.Label>
                    <Form.Control
                        as="select"
                        onChange={ (event) => { this.props.onTypeChanged(event.target.value) } }>
                        <option value="">All Users</option>
                        <option value="admin">Admins</option>
                        <option value="instructor">Instructors</option>
                    </Form.Control>
                </Form.Group>
                <Form.Group>
                    <Form.Label>Search</Form.Label>
                    <Form.Control
                        type="text"
                        placeholder="Search users"
                        onChange={ (event) => { this.props.onSearchChanged(event.target.value) } }
                    />
                </Form.Group>
            </Fragment>
        );
    }
}

UsersSearch.propTypes = {
    onSearchChanged: PropTypes.func.isRequired,
    onTypeChanged: PropTypes.func.isRequired
};

export default UsersSearch;

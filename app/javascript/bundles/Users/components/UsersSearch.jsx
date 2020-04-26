import React, {Fragment, Component} from 'react';
import PropTypes from 'prop-types';
import {Form} from "react-bootstrap";

class UsersSearch extends Component {
    render() {
        return (
            <Fragment>
                <Form.Group>
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

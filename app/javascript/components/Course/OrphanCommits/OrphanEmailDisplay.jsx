
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Table } from 'react-bootstrap'

export default class OrphanEmailDisplay extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <>
                <Table striped bordered hover>
                    <thead>
                        <tr><th>Email</th></tr>
                    </thead>
                    <tbody>
                        <tr><td>{this.props.email}</td></tr>

                    </tbody>
                </Table>
            </>
        );
    }
}

OrphanEmailDisplay.propTypes = {

};







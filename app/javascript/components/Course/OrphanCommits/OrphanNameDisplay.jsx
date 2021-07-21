
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Table } from 'react-bootstrap'

export default class OrphanNameDisplay extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <>
                <Table striped bordered hover>
                    <thead>
                        <tr><th>Name</th></tr>
                    </thead>
                    <tbody>
                        <tr><td>{this.props.name}</td></tr>

                    </tbody>
                </Table>
            </>
        );
    }
}

OrphanNameDisplay.propTypes = {

};







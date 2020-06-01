import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Table} from "react-bootstrap";

class ActivityTable extends Component {
    render() {
        return (
            <Fragment>
                <Table striped bordered hover>
                    <thead>
                    <tr>
                        <th>Repository</th>
                        <th>Branch</th>
                        <th>Files Changed</th>
                        <th>Commit Hash</th>
                        <th>Date Committed</th>
                    </tr>
                    </thead>
                    <tbody>
                    {this.props.commits.map(c =>
                        <Fragment>

                        </Fragment>
                    )}
                    </tbody>
                </Table>
            </Fragment>
        );
    }
}

ActivityTable.propTypes = {
    commits: PropTypes.array.isRequired
};

export default ActivityTable;
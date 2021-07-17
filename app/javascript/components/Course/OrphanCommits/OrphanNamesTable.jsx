import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';

import PropTypes from 'prop-types';

class OrphanNamesTable extends Component {

    constructor(props) {
        super(props);
    }

    columns =
        [
            {
                dataField: 'id',
                text: 'id',
                editable: false,
                sort: true
            },
            {
                dataField: 'name',
                text: 'Name',
                editable: false,
                sort: true
            },
            {
                dataField: 'roster_student_id',
                text: 'Roster Student',
                editable: false,
                sort: true
            },
            {
                dataField: 'course_id',
                text: 'Course Id',
                editable: false,
                sort: true
            },
        ];

  
    render() {
        return (
            <Fragment>
                <BootstrapTable
                    columns={this.columns}
                    data={this.props.names}
                    keyField="id"
                />
            </Fragment>
        );
    }
}

OrphanNamesTable.propTypes = {
    names: PropTypes.array.isRequired
};

export default OrphanNamesTable;

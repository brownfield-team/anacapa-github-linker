import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';

import PropTypes from 'prop-types';

class OrphanCommitsByNameTable extends Component {

    constructor(props) {
        super(props);
    }

    columns =
        [
            {
                dataField: 'name',
                text: 'Name',
                editable: false,
                sort: true
            },
            {
                dataField: 'count',
                text: 'Count',
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
                    keyField="name"
                />
            </Fragment>
        );
    }
}

OrphanCommitsByNameTable.propTypes = {
    names: PropTypes.array.isRequired
};

export default OrphanCommitsByNameTable;

import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';
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
                sort: true,
                formatter: (cell, row) => this.renderNameUrl(cell, row)

            },
            {
                dataField: 'count',
                text: 'Count',
                editable: false,
                sort: true
            },
        ];

    renderNameUrl = (cell, row) => {
        const url = `/courses/${this.props.course_id}/orphan_commits_by_name/${encodeURI(cell)}`;       
        return (
            <a href={url}>{cell}</a>
        );
    }
  
    render() {
        return (
            <Fragment>
                 <JSONPrettyPanel
                    expression={"this.props"}
                    value={this.props}
                />
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
    names: PropTypes.array.isRequired,
    course_id: PropTypes.number.isRequired
};

export default OrphanCommitsByNameTable;

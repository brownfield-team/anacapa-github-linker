import React, { Component } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';
import PropTypes from 'prop-types';

import { orphanCommitsByNameRoute } from "../../../services/service-routes"

class OrphanCommitsByNameTable extends Component {

    orphanCommitsByNamePage = (courseId, name) => `/courses/${courseId}/orphan_commits_by_name?name=${encodeURI(name)}`


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
                sort: true,
                formatter: (cell, row) => this.renderCountUrl(cell, row)
            },
        ];

    renderNameUrl = (cell, row) => {
        const url = this.orphanCommitsByNamePage(this.props.course_id, cell);
        return (
            <a href={url}>{cell}</a>
        );
    }

    renderCountUrl = (cell, row) => {
        const url = this.orphanCommitsByNamePage(this.props.course_id, row.name);
        return (
            <a href={url}>{cell}</a>
        );
    }


    render() {
        return (
            <>
                <BootstrapTable
                    columns={this.columns}
                    data={this.props.names}
                    keyField="name"
                    defaultSorted={[{ dataField: "count", order: "desc" }]}
                />
            </>
        );
    }
}

OrphanCommitsByNameTable.propTypes = {
    names: PropTypes.array.isRequired,
    course_id: PropTypes.number.isRequired
};

export default OrphanCommitsByNameTable;

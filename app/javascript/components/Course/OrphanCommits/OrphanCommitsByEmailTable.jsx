import React, { Component } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';
import PropTypes from 'prop-types';

class OrphanCommitsByEmailTable extends Component {

    orphanCommitsByEmailPage = (courseId, email) => `/courses/${courseId}/orphan_commits_by_email?email=${encodeURI(email)}`;

    constructor(props) {
        super(props);
    }

    columns =
        [
            {
                dataField: 'email',
                text: 'Email',
                editable: false,
                sort: true,
                formatter: (cell, row) => this.renderEmailUrl(cell, row)

            },
            {
                dataField: 'count',
                text: 'Count',
                editable: false,
                sort: true,
                formatter: (cell, row) => this.renderCountUrl(cell, row)
            },
        ];

    renderEmailUrl = (cell, row) => {
        const url = this.orphanCommitsByEmailPage(this.props.course_id, cell);
        return (
            <a href={url}>{cell}</a>
        );
    }

    renderCountUrl = (cell, row) => {
        const url = this.orphanCommitsByEmailPage(this.props.course_id, row.email);
        return (
            <a href={url}>{cell}</a>
        );
    }


    render() {
        return (
            <>
                <BootstrapTable
                    columns={this.columns}
                    data={this.props.emails}
                    keyField="email"
                    defaultSorted={[{ dataField: "count", order: "desc" }]}
                />
            </>
        );
    }
}

OrphanCommitsByEmailTable.propTypes = {
    emails: PropTypes.array.isRequired,
    course_id: PropTypes.number.isRequired
};

export default OrphanCommitsByEmailTable;

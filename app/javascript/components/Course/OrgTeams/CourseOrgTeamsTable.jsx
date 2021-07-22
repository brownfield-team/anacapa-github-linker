import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';

import PropTypes from 'prop-types';
import paginationFactory from 'react-bootstrap-table2-paginator';


class CourseOrgTeamsTable extends Component {

    constructor(props) {
        super(props);
    }

    columns =
        [
            {
                dataField: 'name',
                text: 'Team',
                editable: false,
                formatter: (cell, row, rowIndex, extraData) => this.renderTeamShowPageUrl(cell, row, rowIndex, { "course_id": this.props.course_id, "table_size": this.props.teams.length })
            },
            {
                dataField: 'url',
                text: 'Manage',
                editable: false,
                formatter: (cell) => this.renderRepoGithubUrl(cell)
            },
        ];

    renderTeamShowPageUrl = (cell, row, rowIndex, extraData) => {
        const url = `/courses/${extraData.course_id}/org_teams/${row.id}`;

        console.log("props = ", this.props)
        if (extraData.table_size > 1)
            return (
                <a href={url}>{cell}</a>
            );
        else
            return (
                cell
            );
    }

    renderRepoGithubUrl = (cell) => {
        const url = `${cell}/members`
        return (
            <a href={url}>Manage on Github...</a>
        );
    }

    onTableChange = (type, newState) => {
        if (type !== "pagination") {
            // For now, sort and filter are disabled.
            return;
        }
        this.props.paginationHandler(newState.page, newState.sizePerPage);
    }

    paginationOptions = () => {
        return paginationFactory({
            totalSize: this.props.totalSize,
            page: this.props.page,
            sizePerPage: this.props.pageSize
        });
    }

    render() {
        return (
            <Fragment>
                <BootstrapTable
                    bootstrap4={true}
                    columns={this.columns}
                    data={this.props.teams}
                    keyField="id"
                    remote={{ pagination: true, filter: false, sort: false }}
                    pagination={
                        this.props.paginationHandler ?
                            this.paginationOptions() :
                            undefined
                    }
                    onTableChange={this.onTableChange}
                    hidePageListOnlyOnePage={true}
                />
            </Fragment>
        );
    }
}

CourseOrgTeamsTable.propTypes = {
    teams: PropTypes.array.isRequired,
    paginationHandler: PropTypes.func,
    page: PropTypes.number.isRequired,
    pageSize: PropTypes.number.isRequired,
    totalSize: PropTypes.number.isRequired
};

export default CourseOrgTeamsTable;

import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';

import PropTypes from 'prop-types';
import paginationFactory from 'react-bootstrap-table2-paginator';
import { githubRepoRoute } from "../../../services/service-routes";
import cellEditFactory, { Type } from 'react-bootstrap-table2-editor';


class CourseGithubReposTable extends Component {

    constructor(props) {
        super(props);
    }

    columns =
        [{
            dataField: 'name',
            text: 'Name',
            editable: false,
            formatter: (cell, row, rowIndex, extraData) => this.renderRepoShowPageUrl(cell, row, rowIndex, {"course_id": this.props.course_id})
        }, {
            dataField: 'url',
            text: 'on Github',
            editable: false,
            formatter: (cell) => this.renderRepoGithubUrl(cell)
        }, {
            dataField: 'visibility',
            text: 'Visibility',
            editable: false
        }, {
            dataField: 'commit_count',
            text: 'Commit Count',
            editable: false
        },{
            dataField: 'dummy1',
            text: 'Commit CSV',
            editable: false,
            formatter: (cell, row, rowIndex, extraData) => this.renderCommitCSVLink(cell, row, rowIndex, {"course_id": this.props.course_id})
        },{
            dataField: 'issue_count',
            text: 'Issue Count',
            editable: false
        },{
            dataField: 'dummy2',
            text: 'Issue CSV',
            editable: false,
            formatter: (cell, row, rowIndex, extraData) => this.renderIssueCSVLink(cell, row, rowIndex, {"course_id": this.props.course_id})
        },{
            dataField:"pr_count",
            text:'PR Count',
            editable: false,
        },{
            dataField: 'dummy3',
            text: 'PR CSV',
            editable: false,
            // formatter: (cell, row, rowIndex, extraData) => this.renderIssueCSVLink(cell, row, rowIndex, {"course_id": this.props.course_id})
        },{
            dataField: 'is_project_repo',
            text: 'Project Repo',
            editable: false,
            formatter: (cell) => (cell===true) ? "true" : ""
        }];

    renderRepoShowPageUrl = (cell, row, rowIndex, extraData) => {
        const url = `/courses/${extraData.course_id}/github_repos/${row.id}`;

        return (
            <a href={url}>{cell}</a>
        );
    }

    renderRepoGithubUrl = (cell) => {
        return (
            <a href={cell}>on Github</a>
        );
    }

    renderCommitCSVLink = (cell, row, rowIndex, extraData) => {
        const url = `/courses/${extraData.course_id}/github_repos/${row.id}/repo_commit_events.csv`;
        return (
                <a href={url}>CSV</a>
        );
    }

    renderIssueCSVLink = (cell, row, rowIndex, extraData) => {
        const url = `/courses/${extraData.course_id}/github_repos/${row.id}/repo_issue_events.csv`;
        return (
                <a href={url}>CSV</a>
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
                    columns={this.columns}
                    data={this.props.repos}
                    keyField="id"
                    remote={ { pagination: true, filter: false, sort: false } }
                    pagination={
                        this.props.paginationHandler ?
                        this.paginationOptions()  :
                        undefined
                    }
                    onTableChange={ this.onTableChange }
                    hidePageListOnlyOnePage={true}
                />
            </Fragment>
        );
    }
}

CourseGithubReposTable.propTypes = {
    repos: PropTypes.array.isRequired,
    paginationHandler: PropTypes.func,
    page: PropTypes.number.isRequired,
    pageSize: PropTypes.number.isRequired,
    totalSize: PropTypes.number.isRequired,
    course: PropTypes.object.isRequired
};

export default CourseGithubReposTable;

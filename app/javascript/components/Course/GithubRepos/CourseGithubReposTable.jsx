import React, { Component, Fragment } from 'react';
import { Table } from "react-bootstrap";
import BootstrapTable from 'react-bootstrap-table-next';
import CourseGithubReposRow from "./CourseGithubReposRow";
import PropTypes from 'prop-types';
import paginationFactory from 'react-bootstrap-table2-paginator';

import { githubRepoRoute } from "../../../services/service-routes";

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
        }];

    renderRepoShowPageUrl = (cell, row, rowIndex, extraData) => {
        console.log("renderRepoShowPageUrl");
        console.log("row="+JSON.stringify(row));
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
        console.log("CourseGithubReposTable render");
        console.log("this.props.repos="+JSON.stringify(this.props.repos));
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
    totalSize: PropTypes.number.isRequired
};

export default CourseGithubReposTable;
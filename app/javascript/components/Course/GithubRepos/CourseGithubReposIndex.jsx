import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import CourseGithubReposTable from "./CourseGithubReposTable";
import CourseGithubReposControls from "./CourseGithubReposControls";

import axios from "../../../helpers/axios-rails";
import { Alert, Form } from 'react-bootstrap';
import {debounce} from "debounce";

import { githubReposRoute } from "../../../services/service-routes";

class CourseGithubReposIndex extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "", type: this.props.visibility ?? "", error: "", repos: [], page: 1, pageSize: 25, totalSize: 0 };
        this.onSearchChanged = debounce(this.onSearchChanged, 1000);
    }

    componentDidMount() {
        this.updateRepos();
    }

    onSearchChanged = (searchValue) => {
        if (searchValue === this.props.search) {
            return;
        }
        this.setState({page: 1, search: searchValue}, () => {
            this.updateRepos();
        });
    }

    onVisibilityChanged = (visibilityValue) => {
        if (visibilityValue === this.props.visibility) {
            return;
        }

        this.setState({page: 1, visibility: visibilityValue}, () => {
           this.updateRepos();
        });
    }

    paginationHandler = (page, pageSize) => {
        this.setState({page: page, pageSize: pageSize}, () => {
            this.updateRepos();
        });
    }

    updateRepos = () => {
        const url = githubReposRoute(this.props.course_id);
        const params = {search: this.state.search, visibility: this.state.visibility, page: this.state.page, per_page: this.state.pageSize};
        // Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: url,
            type: "get",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data, status, xhr) {
                const totalRecords = parseInt(xhr.getResponseHeader("X-Total"));
                const page = parseInt(xhr.getResponseHeader("X-Page"));
                self.setState({ repos: data, totalSize: totalRecords, page: page, error: "" });
            },
            error: function (data) {
                self.setState({ error: data });
            }
        });
    }

    renderError() { // Or don't
        const error = this.state.error;
        return (
            <div>
            { error !== "" &&
                <Alert id="error-alert" variant="danger"> {error} </Alert>
            }
            </div>
        );
    }

    render() {
        return (
            <div>
                { this.renderError() }
                <CourseGithubReposControls 
                    onSearchChanged={this.onSearchChanged}
                    onVisibilityChanged={this.onVisibilityChanged}
                />
                <CourseGithubReposTable
                    repos={this.state.repos}
                    page={this.state.page}
                    pageSize={this.state.pageSize}
                    totalSize={this.state.totalSize}
                    paginationHandler={this.paginationHandler}
                    {...this.props}
                />
            </div>
        );
    }
}

CourseGithubReposIndex.propTypes = {
    search: PropTypes.string,
    type: PropTypes.string,
    course_id : PropTypes.number.isRequired
};

export default CourseGithubReposIndex;
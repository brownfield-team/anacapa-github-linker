import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import CourseGithubReposTable from "./CourseGithubReposTable";
import CourseGithubRepoProjectReposStatistics from "./CourseGithubRepoProjectReposStatistics";
import IssueTimelineEventsTable from "../GithubRepos/ProjectRepos/IssueTimelineEventsTable";
import axios from "../../../helpers/axios-rails";
import { Alert, Form } from 'react-bootstrap';

import { githubReposRoute } from "../../../services/service-routes";

class CourseGithubReposProjectRepos extends Component {
    constructor(props) {
        super(props);
        this.state = {  error: "", repos: [], page: 1, pageSize: 25, totalSize: 0 };
    }

    componentDidMount() {
        this.updateRepos();
    }

    paginationHandler = (page, pageSize) => {
        this.setState({page: page, pageSize: pageSize}, () => {
            this.updateRepos();
        });
    }

    updateRepos = () => {
        const url = githubReposRoute(this.props.course_id);
        const params = { page: this.state.page, per_page: this.state.pageSize, is_project_repo:true};
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
            <Fragment>
                <div>
                    <h1>Project Repos</h1>
                    { this.renderError() }
                    <CourseGithubReposTable
                        repos={this.state.repos}
                        page={this.state.page}
                        pageSize={this.state.pageSize}
                        totalSize={this.state.totalSize}
                        paginationHandler={this.paginationHandler}
                        course={this.props.course}
                        {...this.props}
                    />
                </div>
                <IssueTimelineEventsTable events={[]} course= {this.props.course} />
                <CourseGithubRepoProjectReposStatistics 
                    repos={this.state.repos}
                    course={this.props.course}
                    databaseId_to_student={this.props.databaseId_to_student}
                    databaseId_to_team={this.props.databaseId_to_team}
                    {...this.props}
                >
                </CourseGithubRepoProjectReposStatistics>
            </Fragment>

        );
    }
}

CourseGithubReposProjectRepos.propTypes = {
    course_id : PropTypes.number.isRequired,
    course: PropTypes.object.isRequired,
    databaseId_to_student: PropTypes.object.isRequired,
    databaseId_to_team: PropTypes.object.isRequired
};

export default CourseGithubReposProjectRepos;
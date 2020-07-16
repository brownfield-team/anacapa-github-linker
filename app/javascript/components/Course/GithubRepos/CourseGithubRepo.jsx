import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import { Table } from "react-bootstrap";
import CourseGithubRepoTable from "./CourseGithubRepoTable";
import CourseGithubRepoJobs from "./CourseGithubRepoJobs";

import axios from "../../../helpers/axios-rails";
import ReposService from "../../../services/repos-service";

class CourseGithubRepo extends Component {

    constructor(props) {
        super(props);
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;

    }

    componentDidMount() {
        console.log("CourseGithubReposIndex componentDidMount called");
    }


    render() {
        return (
            <Fragment>
                <CourseGithubRepoTable repos={[this.props.repo]} {...this.props} />
                <CourseGithubRepoJobs repo={this.props.repo} {...this.props} />
            </Fragment>
        );
    }
}

CourseGithubRepo.propTypes = {

};

export default CourseGithubRepo;
import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import { Table } from "react-bootstrap";
import CourseGithubReposTable from "./CourseGithubReposTable";
import CourseGithubReposControls from "./CourseGithubReposControls";

import axios from "../../../helpers/axios-rails";
import ReposService from "../../../services/repos-service";

class CourseGithubReposIndex extends Component {

    constructor(props) {
        super(props);
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
        this.state = { repos: [] };
    }

    componentDidMount() {
        console.log("CourseGithubReposIndex componentDidMount called");
        this.updateRepos();
    }

    updateRepos = () => {
        console.log("CourseGithubReposIndex updateRepos called");
        console.log("this.props=" + JSON.stringify(this.props));

        ReposService.getGithubRepos(this.props.course_id).then(reposResponse => {
            console.log("updateRepos setting state");
            this.setState({ repos: reposResponse });
        });
    };

    render() {
        return (
            <Fragment>
                <CourseGithubReposControls 
                onSearchChanged={ ()=>{} }
                onVisibilityChanged={ ()=>{}}
                />
                <CourseGithubReposTable repos={this.state.repos} {...this.props} />
            </Fragment>
        );
    }
}

CourseGithubReposIndex.propTypes = {

};

export default CourseGithubReposIndex;
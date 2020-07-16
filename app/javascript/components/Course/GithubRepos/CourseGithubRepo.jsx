import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Table} from "react-bootstrap";
import CourseGithubReposRow from "./CourseGithubReposRow";
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
                <Table striped hover>
                    <thead>
                    <tr>
                        <th>name</th>
                        <th>on GitHub</th>
                        <th>visibility</th>
                    </tr>
                    </thead>
                    <tbody>
                        <CourseGithubReposRow repo={this.props.repo} key={this.props.repo.id} {...this.props} /> 
                    </tbody>
                </Table>
            </Fragment>
        );
    }
}

CourseGithubRepo.propTypes = {
    
};

export default CourseGithubRepo;
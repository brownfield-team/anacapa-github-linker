import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Table} from "react-bootstrap";
import CourseGithubReposRow from "./CourseGithubReposRow";
import axios from "../../../helpers/axios-rails";
import ReposService from "../../../services/repos-service";

class CourseGithubReposIndex extends Component {

    constructor(props) {
        super(props);
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
        this.state = {repos: []};
    }

    componentDidMount() {
        console.log("CourseGithubReposIndex componentDidMount called");
        this.updateRepos();
    }

    updateRepos = () => {
        console.log("CourseGithubReposIndex updateRepos called");
        console.log("this.props="+JSON.stringify(this.props));

        ReposService.getGithubRepos(this.props.course_id).then(reposResponse => {
            console.log("updateRepos setting state");
            this.setState({repos: reposResponse});
        });
    };

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
                    {this.state.repos.map(repo =>
                        <CourseGithubReposRow repo={repo} key={repo.id} {...this.props} />
                    )}
                    </tbody>
                </Table>
            </Fragment>
        );
    }
}

CourseGithubReposIndex.propTypes = {
    
};

export default CourseGithubReposIndex;
import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import { Form, Checkbox, FormGroup } from "react-bootstrap";
import CourseGithubReposTable from "./CourseGithubReposTable";
import CourseGithubRepoStatistics from "./CourseGithubRepoStatistics";

import ReposService from "../../../services/repos-service";


class CourseGithubRepo extends Component {

    constructor(props) {
        super(props);
        this.state = {github_repo: undefined};
    }

    componentDidMount() {
        this.fetchRepo();
    }

    fetchRepo = () => {
        ReposService.getGithubRepo(this.props.course_id, this.props.repo_id).then(repo => this.setState({github_repo: repo}));
    }

    courseId = () => {
        return this.state.github_repo.course_id;
    }

    handleCheckboxChange = changeEvent => {
        if (this.state.github_repo.is_project_repo) {
            this.state.github_repo.is_project_repo = false
        } else {
            this.state.github_repo.is_project_repo = true
        }
        this.saveGithubRepo(this.state.github_repo);
    };

    saveGithubRepo = (githubRepo) => {
        const update_hash = {"github_repo":{"is_project_repo": this.state.github_repo.is_project_repo}};
        ReposService.updateGithubRepo(this.courseId(), this.state.github_repo.id, update_hash).then(repoResponse => {
            this.setState({github_repo: repoResponse});
        });
    };

    render() {
        const githubRepo = this.state.github_repo;
        if (githubRepo == null) return "Loading...";
        const course = githubRepo.course;
        return (
            <Fragment>
                <CourseGithubReposTable
                    repos={[githubRepo]}
                    page={1}
                    pageSize={1}
                    totalSize={1}
                    course={course}
                    {...this.props}
                />
                <div className="panel panel-default">
                    <div className="panel-heading">
                        <div className="panel-title">Settings</div>
                    </div>
                    <div className="panel-body">
                        <Form onSubmit={e => {e.preventDefault();  return false;}}>
                            <FormGroup >
                                <Checkbox
                                 checked={githubRepo.is_project_repo}
                                 onChange={this.handleCheckboxChange}
                                >
                                    Is Project Repo
                                </Checkbox>
                            </FormGroup>
                        </Form>
                    </div>

                </div>
                <CourseGithubRepoStatistics
                   repo={githubRepo}
                   course={course}
                   {...this.props}
                >
                </CourseGithubRepoStatistics>
            </Fragment>
        );
    }
}

CourseGithubRepo.propTypes = {
    repo_id: PropTypes.string.isRequired,
    course_id: PropTypes.string.isRequired
};

export default CourseGithubRepo;

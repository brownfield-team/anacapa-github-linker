import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import { Form, Checkbox, FormGroup } from "react-bootstrap";
import CourseGithubReposTable from "./CourseGithubReposTable";
import ReposService from "../../../services/repos-service";

class CourseGithubRepo extends Component {

    constructor(props) {
        super(props);
        this.state = {github_repo: this.props.repo.repo}
    }

    componentDidMount() {
        console.log("CourseGithubReposIndex componentDidMount called");
        console.log("this.props.repo="+JSON.stringify(this.props.repo))
    }

    courseId = () => {
        return this.props.repo.repo.course_id;
    }

    handleCheckboxChange = changeEvent => {
        if (this.state.github_repo.is_project_repo) {
            this.state.github_repo.is_project_repo = false
        } else {
            this.state.github_repo.is_project_repo = true
        }
        console.log("before saveGithubRepo this.state.github_repo="+JSON.stringify(this.state.github_repo));
        this.saveGithubRepo(this.state.github_repo);
        console.log("after saveGithubRepo this.state.github_repo="+JSON.stringify(this.state.github_repo));
    };

    saveGithubRepo = (githubRepo) => {
        console.log("saveGithubRepo this.state.github_repo="+JSON.stringify(this.state.github_repo));
        const update_hash = {"github_repo":{"is_project_repo": this.state.github_repo.is_project_repo}};
        ReposService.updateGithubRepo(this.courseId(), this.state.github_repo.id, update_hash).then(repoResponse => {
            this.setState({github_repo: repoResponse});
        });
    };
   


    render() {
        return (
            <Fragment>
                <CourseGithubReposTable
                    repos={[this.props.repo]}
                    page={1}
                    pageSize={1}
                    totalSize={1}
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
                                 checked={this.state.github_repo.is_project_repo}
                                 onChange={this.handleCheckboxChange}
                                >
                                    Is Project Repo
                                </Checkbox>
                            </FormGroup>
                        </Form>
                    </div>
               
                </div>
            </Fragment>
        );
    }
}

CourseGithubRepo.propTypes = {
    repo : PropTypes.object.isRequired
};

export default CourseGithubRepo;
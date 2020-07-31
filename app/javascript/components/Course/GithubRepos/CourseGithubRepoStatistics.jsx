import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap';
import CourseGithubRepoIssueTimeline from "./CourseGithubRepoIssueTimeline"
import CourseGithubRepoIssueUserEdits from "./CourseGithubRepoIssueUserEdits"


class CourseGithubRepoStatistics extends Component {

    constructor(props) {
        super(props);
    }

 
    render() {
       
        return (
            <Fragment>
              <CourseGithubRepoIssueUserEdits { ...this.props }/>
              <CourseGithubRepoIssueTimeline { ...this.props }/>
            </Fragment>
        );
    }
}

CourseGithubRepoStatistics.propTypes = {
    repo : PropTypes.object.isRequired,
    course: PropTypes.object.isRequired,
    databaseId_to_student: PropTypes.object.isRequired,
    databaseId_to_team: PropTypes.object.isRequired
};

export default CourseGithubRepoStatistics;
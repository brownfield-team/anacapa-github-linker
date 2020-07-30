import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap';
import CourseGithubRepoIssueTimeline from "./CourseGithubRepoIssueTimeline"

class CourseGithubRepoStatistics extends Component {

    constructor(props) {
        super(props);
    }

 
    render() {
       
        return (
            <Fragment>
              <CourseGithubRepoIssueTimeline { ...this.props }/>
            </Fragment>
        );
    }
}

CourseGithubRepoStatistics.propTypes = {
    repo : PropTypes.object.isRequired,
    course: PropTypes.object.isRequired,
};

export default CourseGithubRepoStatistics;
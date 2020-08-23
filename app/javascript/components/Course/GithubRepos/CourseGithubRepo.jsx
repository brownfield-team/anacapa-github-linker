import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import { Table } from "react-bootstrap";
import CourseGithubReposTable from "./CourseGithubReposTable";


class CourseGithubRepo extends Component {

    constructor(props) {
        super(props);
    }

    componentDidMount() {

    }

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
            </Fragment>
        );
    }
}

CourseGithubRepo.propTypes = {
    repo : PropTypes.object.isRequired
};

export default CourseGithubRepo;
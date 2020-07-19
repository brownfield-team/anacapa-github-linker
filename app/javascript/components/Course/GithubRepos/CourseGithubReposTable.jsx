import React, { Component, Fragment } from 'react';
import { Table } from "react-bootstrap";
import CourseGithubReposRow from "./CourseGithubReposRow";

class CourseGithubReposTable extends Component {

    render() {
        return (
            <Fragment>
                <div class="panel panel-default">
                    <Table striped hover>
                        <thead>
                            <tr>
                                <th>name</th>
                                <th>on GitHub</th>
                                <th>visibility</th>
                            </tr>
                        </thead>
                        <tbody>
                            {this.props.repos.map(repo =>
                                <CourseGithubReposRow repo={repo} key={repo.id} {...this.props} />
                            )}
                        </tbody>
                    </Table>
                </div>
            </Fragment>
        );
    }
}

CourseGithubReposTable.propTypes = {

};

export default CourseGithubReposTable;
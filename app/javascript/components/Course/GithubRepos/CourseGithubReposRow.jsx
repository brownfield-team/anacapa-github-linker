import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';

class CourseGithubReposRow extends Component {
    render() {
        const r = this.props.repo; // Save some characters
        return (
            <tr key={r.id}>
                <td><a href={`github_repos/${r.id}`}>{r.name}</a></td>
                <td><a href={r.url}>on Github</a></td>
                <td>{r.visibility}</td>
            </tr>
        );
    }
}

CourseGithubReposRow.propTypes = {
    repo: PropTypes.object.isRequired
};

export default CourseGithubReposRow;
import React, {Component} from 'react';
import PropTypes from 'prop-types';

class ExternalRepoRow extends Component {
    render() {
        const {repo} = this.props;
        return (
            <tr>
                <td>{repo.organization}</td>
                <td>{repo.name}</td>
                <td><a href={repo.path}>Show</a></td>
                <td>
                    <button onClick={() => this.props.onDelete(repo)}>Delete</button>
                </td>
            </tr>
        );
    }
}

ExternalRepoRow.propTypes = {
    repo: PropTypes.object.isRequired,
    onDelete: PropTypes.func.isRequired,
};

export default ExternalRepoRow;

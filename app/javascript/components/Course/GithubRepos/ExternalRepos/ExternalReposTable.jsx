import React, {Component} from 'react';
import PropTypes from 'prop-types';
import ExternalRepoRow from "./ExternalRepoRow";

class ExternalReposTable extends Component {
    render() {
        return (
            <div>
                <div className="panel panel-default">
                    <div className="panel-heading">
                        <div className="panel-title">External Repositories</div>
                    </div>
                    <div className="panel panel-body">
                        <table className="table">
                            <thead>
                            <tr>
                                <th>Organization</th>
                                <th>Name</th>
                                <th colSpan="2"/>
                            </tr>
                            </thead>
                            <tbody>
                            {this.props.repos.map(repo =>
                                <ExternalRepoRow key={repo.id} repo={repo} onDelete={this.props.onRepoDelete}/>
                            )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        );
    }
}

ExternalReposTable.propTypes = {
    repos: PropTypes.array.isRequired,
    onRepoDelete: PropTypes.func.isRequired,
};

export default ExternalReposTable;


import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import axios from "../../helpers/axios-rails";
import ReactOnRails from "react-on-rails";
import JobLauncherItem from "./JobLauncherItem";

class JobLauncher extends Component {
    constructor(props) {
        super(props);
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
    }

    render() {
        return (
            <Fragment>
                <div className="panel panel-default">
                    <div className="panel-heading">
                        <div className="panel-title">Jobs</div>
                    </div>
                    <div className="panel-body">

                        <table className="table">
                            <thead>
                                <tr>
                                    <th>Job Name</th>
                                    <th>Last Run</th>
                                    <th colSpan="1"></th>
                                </tr>
                            </thead>
                            <tbody>
                                {this.props.jobs_list.map(job =>
                                    <JobLauncherItem key={`job-${job.job_short_name}`} job={job} {...this.props} />
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </Fragment>
        );
    }
}

JobLauncher.propTypes = {
    jobs_list: PropTypes.array.isRequired
};

export default JobLauncher;



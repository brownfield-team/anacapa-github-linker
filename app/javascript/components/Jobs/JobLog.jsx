
import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import axios from "../../helpers/axios-rails";
import ReactOnRails from "react-on-rails";
import JobLogItem from "./JobLogItem";

class JobLog extends Component {
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
                        <div className="panel-title">Job Log</div>
                    </div>
                    <div className="panel-body">

                        <table data-toggle="table" className="table">
                            <thead>
                                <tr>
                                    <th data-sortable="true">Job Name</th>
                                    <th data-sortable="true">Date Run</th>
                                    <th>Time Elapsed</th>
                                    <th>Summary</th>
                                </tr>
                            </thead>
                            <tbody>
                                {this.props.completed_jobs_list.map(completed_job =>
                                    <JobLogItem key={`completed-job-${completed_job.id}`} completed_job={completed_job} {...this.props} />
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>
            </Fragment>
        );
    }
}

JobLog.propTypes = {
    completed_jobs_list: PropTypes.array.isRequired
};

export default JobLog;



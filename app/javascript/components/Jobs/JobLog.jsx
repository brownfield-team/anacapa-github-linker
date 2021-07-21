
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
        this.state = { jobList: undefined }
    }

    componentDidMount() {
        this.fetchJobLog();
        this.interval = setInterval(() => this.fetchJobLog(), 10000);
    }
    
    componentWillUnmount() {
        clearInterval(this.interval);
    }

    fetchJobLog = () => {
        if (this.props.course_id != undefined && this.props.github_id == undefined) {
            const response = fetch(`/api/courses/${this.props.course_id}/job_log/`).then(json => json.json()).then(parsedJson => {
                this.setState({ jobList: parsedJson })
            })
        } else if (this.props.course_id != undefined && this.props.github_id != undefined) {
            const response = fetch(`/api/courses/${this.props.course_id}/github_repos/${this.props.github_id}/job_log/`).then(json => json.json()).then(parsedJson => {
                this.setState({ jobList: parsedJson })
            })
        } else if (this.props.course_id == undefined && this.props.github_id == undefined) {
            const response = fetch(`/api/job_log/`).then(json => json.json()).then(parsedJson => {
                this.setState({ jobList: parsedJson })
            })
        }
    }

    render() {
        const jobList = this.state.jobList;

        if (jobList == null) return "Loading...";

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
                                {this.state.jobList.map(completed_job =>
                                    <JobLogItem key={`completed-job-${completed_job.id}`} completed_job={completed_job} {...this.state.jobList} />
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
  
};

export default JobLog;



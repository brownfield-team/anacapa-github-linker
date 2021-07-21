import React, { Component } from 'react';
import * as PropTypes from 'prop-types';
import axios from "../../../helpers/axios-rails"
import ReactOnRails from "react-on-rails";

import OrphanCommitsByNamePanel from './OrphanCommitsByNamePanel';
import OrphanCommitsByEmailPanel from './OrphanCommitsByEmailPanel';
import OrphanNamesPanel from '../OrphanCommits/OrphanNamesPanel';
import OrphanEmailsPanel from '../OrphanCommits/OrphanEmailsPanel';

import { Alert, Form } from 'react-bootstrap';
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';
import JobLauncher from "../../Jobs/JobLauncher";
import JobLog from "../../Jobs/JobLog";

import { orphanCommitsRoute, orphanNamesRoute, orphanEmailsRoute } from "../../../services/service-routes";


const empty_orphan_commits = {
    orphan_author_names: [],
    orphan_author_emails: []
};

class OrphanCommits extends Component {

    constructor(props) {
        super(props);

        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;

        this.state = {
            orphanError: "",
            orphanNamesError: "",
            orphanEmailsError: "",
            orphanCommits: empty_orphan_commits,
            orphanNames: [],
            orphanEmails: [],
        };
    }

    componentDidMount() {
        this.updateOrphanCommits();
        this.updateOrphanNames();
        this.updateOrphanEmails();
    }

    updateOrphanCommits = () => {
        const url = orphanCommitsRoute(this.props.course_id);
        const params = {};
        // self=this; Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: url,
            type: "get",
            data: $.param(params),
            beforeSend: function () {
                return true;
            },
            success: function (data, status, xhr) {
                console.log("success");
                self.setState(prevState => ({ ...prevState, orphanCommits: data, orphanError: "" }));
                console.log("success this.state=", this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, orphanCommits: self.empty_orphan_commits, orphanError: data }));
            }
        });
    }

    updateOrphanNames = () => {
        const url = orphanNamesRoute(this.props.course_id);
        const params = {};
        // self=this; Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: url,
            type: "get",
            data: $.param(params),
            beforeSend: function () {
                return true;
            },
            success: function (data, status, xhr) {
                console.log("success");
                self.setState(prevState => ({ ...prevState, orphanNames: data, orphanNamesError: "" }));
                console.log("success this.state=", this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, orphanNames: [], orphanNamesError: data }));
            }
        });
    }

    updateOrphanEmails = () => {
        const url = orphanEmailsRoute(this.props.course_id);
        const params = {};
        // self=this, Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: url,
            type: "get",
            data: $.param(params),
            beforeSend: function () {
                return true;
            },
            success: function (data, status, xhr) {
                console.log("success");
                self.setState(prevState => ({ ...prevState, orphanEmails: data, orphanEmailsError: "" }));
                console.log("success this.state=", this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, orphanEmails: [], orphanEmailsError: data }));
            }
        });
    }

    renderError() {
        const orphanError = this.state.orphanError;
        const orphanNamesError = this.state.orphanNamesError;

        return (
            <div>
                {orphanError !== "" &&
                    <Alert id="error-alert-orphan-commits" variant="danger"> {orphanError} </Alert>
                }
                {orphanNamesError !== "" &&
                    <Alert id="error-alert-orphan-names" variant="danger"> {orphanNamesError} </Alert>
                }
            </div>
        );
    }

    render() {
        const redirect_url = `/courses/${this.props.course_id}/orphan_commits`;
        return (
            <>
                <h1>Orphan Commits</h1>
                {this.renderError()}

                <p>Each of the names below is associated with a set of commits that could not be matched with a roster student.
                    Click on each one to see the commits associated with that name.  You will be given
                    the option to associate them with a roster student.
                </p>
                <OrphanCommitsByNamePanel
                    orphanCommits={this.state.orphanCommits}
                    course_id={this.props.course_id}
                />

                <OrphanCommitsByEmailPanel
                    orphanCommits={this.state.orphanCommits}
                    course_id={this.props.course_id}
                />

                <p>Each of the names below shows a mapping from a name to a roster student.  Once this mapping is
                    present, you can associate the commits by running the "Fix Orphan Commits" job.
                </p>
                <OrphanNamesPanel
                    names={this.state.orphanNames}
                />

                <p>Each of the emails below shows a mapping from an email to a roster student.  Once this mapping is
                    present, you can associate the commits by running the "Fix Orphan Commits" job.
                </p>
                <OrphanEmailsPanel
                    emails={this.state.orphanEmails}
                />

                <JobLauncher
                    jobs_list={this.props.job_list}
                    run_url_prefix={"/courses/" + this.props.course_id + "/run_course_job"}
                    redirect_url={redirect_url}
                />
                <JobLog 
                    github_id={null}
                    {...this.props} 
                />
            </>
        );
    }
}

OrphanCommits.propTypes = {

};

export default OrphanCommits;
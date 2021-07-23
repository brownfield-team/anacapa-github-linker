import React, { Component } from 'react';
import * as PropTypes from 'prop-types';
import axios from "../../../helpers/axios-rails"
import ReactOnRails from "react-on-rails";
import { Alert } from 'react-bootstrap';

import { Table } from 'react-bootstrap';
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';

import RepoCommitEventsTable from '../../RepoCommitEvents/RepoCommitEventsTable';

import { orphanCommitsByNameRoute } from "../../../services/service-routes";

import AssignOrphanNameToRosterStudent from "./AssignOrphanNameToRosterStudent";
import OrphanNameDisplay from './OrphanNameDisplay';
import OrphanNamesPanel from './OrphanNamesPanel';

class OrphanCommitsByName extends Component {


    constructor(props) {

        super(props);

        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;

        this.state = {
            orphanCommits: [],
            error: "",
            page: 1,
            pageSize: 25,
            totalSize: 0
        };
    }

    componentDidMount() {
        this.updateOrphanCommitsByName()
    }

    updateOrphanCommitsByName = () => {


        const url = orphanCommitsByNameRoute(this.props.params.course_id, this.props.params.name);
        const params = { page: this.state.page, per_page: this.state.pageSize };


        // self=this; Otherwise , calling setState fails because the scope for "this" is the success/error function.
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
                const totalRecords = parseInt(xhr.getResponseHeader("X-Total"));
                const page = parseInt(xhr.getResponseHeader("X-Page"));
                self.setState(prevState => ({ ...prevState, orphanCommits: data, totalSize: totalRecords, page: page, orphanError: "" }));
                console.log("success this.state=", this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, orphanCommits: [], orphanError: data }));
            }
        });
    }


    paginationHandler = (page, pageSize) => {
        this.setState({ page: page, pageSize: pageSize }, () => {
            this.updateOrphanCommitsByName();
        });
    }

    renderError() {
        const orphanError = this.state.orphanError;
       
        return (
            <div>
                {orphanError !== "" &&
                    <Alert id="error-alert-orphan-commits" variant="danger"> {orphanError} </Alert>
                }
            </div>
        );
    }

    render() {
        return (
            <>
                <h1>Orphan Commits By Name</h1>

                {this.renderError()}

                <OrphanNameDisplay name={this.props.params.name} />

                <RepoCommitEventsTable
                    commits={this.state.orphanCommits}
                    page={this.state.page}
                    pageSize={this.state.pageSize}
                    totalSize={this.state.totalSize}
                    paginationHandler={this.paginationHandler}
                    course={this.props.course}
                    {...this.props}
                />

                <p>To assign the orphan commits above to a roster student,
                    select the roster student from the drop down menu,
                    then click "assign".
                </p>
                <AssignOrphanNameToRosterStudent
                    course={this.props.course}
                    {...this.props}
                />
            </>
        );
    }
}

OrphanCommitsByName.propTypes = {

};

export default OrphanCommitsByName;
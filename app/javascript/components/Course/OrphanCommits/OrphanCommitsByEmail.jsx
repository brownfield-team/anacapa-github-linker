import React, { Component } from 'react';
import { Alert } from 'react-bootstrap';

import RepoCommitEventsTable from '../../RepoCommitEvents/RepoCommitEventsTable';

import { orphanCommitsByEmailRoute } from "../../../services/service-routes";

import AssignOrphanEmailToRosterStudent from "./AssignOrphanEmailToRosterStudent";
import OrphanEmailDisplay from './OrphanEmailDisplay';

class OrphanCommitsByEmail extends Component {


    constructor(props) {

        super(props);

        this.state = {
            orphanCommits: [],
            error: "",
            page: 1,
            pageSize: 25,
            totalSize: 0
        };
    }

    componentDidMount() {
        this.updateOrphanCommitsByEmail()
    }

    updateOrphanCommitsByEmail = () => {
       
        const url = orphanCommitsByEmailRoute(this.props.params.course_id, this.props.params.email) ;
        const params = { page: this.state.page, per_page: this.state.pageSize };

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
            this.updateOrphanCommitsByEmail();
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
                <h1>Orphan Commits By Email</h1>

                {this.renderError()}

                <OrphanEmailDisplay email={this.props.params.email} />

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
                <AssignOrphanEmailToRosterStudent
                    course={this.props.course}
                    {...this.props}
                />
            </>
        );
    }
}

OrphanCommitsByEmail.propTypes = {

};

export default OrphanCommitsByEmail;
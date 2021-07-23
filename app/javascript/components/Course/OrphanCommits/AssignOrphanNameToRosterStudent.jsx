import React, { Component } from 'react';
import axios from "../../../helpers/axios-rails"
import ReactOnRails from "react-on-rails";
import RosterStudentAssign from '../../RosterStudents/RosterStudentAssign';
import { orphanNamesRoute } from "../../../services/service-routes";

class AssignOrphanNameToRosterStudent extends Component {

    constructor(props) {

        super(props);

        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;

        this.state = {};
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
                self.setState(prevState => ({ ...prevState, orphanNames: data, orphanNamesError: "" }));
            },
            error: function (data) {
                self.setState(prevState => ({ ...prevState, orphanNames: [], orphanNamesError: data }));
            }
        });
    }

    assign_url = (course_id, name, roster_student_id) => `/courses/${course_id}/orphan_commits_by_name/assign/${encodeURIComponent(name)}/to/${roster_student_id}`;

    render() {
        return (
            <RosterStudentAssign
                assign_url={this.assign_url}
                field={'name'}
                {...this.props}
            />
        );
    }
}

AssignOrphanNameToRosterStudent.propTypes = {

};

export default AssignOrphanNameToRosterStudent;
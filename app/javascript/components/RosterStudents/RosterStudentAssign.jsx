import React, { Component } from 'react';
import * as PropTypes from 'prop-types';
import axios from "../../helpers/axios-rails"
import ReactOnRails from "react-on-rails";


import { Alert } from 'react-bootstrap';

import RosterStudentTable from './RosterStudentTable';

import { courseStudentsRoute } from "../../services/service-routes";

class RosterStudentAssign extends Component {


    constructor(props) {

        super(props);

        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;

        this.state = {
            rosterStudents: [],
            rosterStudentsError: ""
        };
    }

    componentDidMount() {
        this.updateRosterStudents();
    }

    updateRosterStudents = () => {
       

        const url = courseStudentsRoute(this.props.params.course_id);
        console.log("url=", url);
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
                self.setState(prevState => ({ ...prevState, rosterStudents: data, rosterStudentsError: "" }));
                console.log("success this.state=", this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, rosterStudents: [], rosterStudentsError: data }));
            }
        });
    }



    renderError() {
        const rosterStudentsError = this.state.rosterStudentsError;

        return (
            <div>
                {rosterStudentsError !== "" &&
                    <Alert id="error-alert-roster-students" variant="danger"> {rosterStudentsError} </Alert>
                }
            </div>
        );
    }



    render() {
        return (
            <>
                <RosterStudentTable
                    rosterStudents={this.state.rosterStudents}
                    {...this.props}
                />
            </>
        );
    }
}

RosterStudentAssign.propTypes = {
	assign_url: PropTypes.func.isRequired,
    field: PropTypes.string.isRequired
};

export default RosterStudentAssign;
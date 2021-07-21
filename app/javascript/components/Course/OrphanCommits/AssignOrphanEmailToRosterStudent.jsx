import React, {Component} from 'react';
import * as PropTypes from 'prop-types';
import axios from "../../../helpers/axios-rails"
import ReactOnRails from "react-on-rails";


import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';

import OrphanEmailDisplay from './OrphanEmailDisplay';
import RosterStudentAssign from '../../RosterStudents/RosterStudentAssign';
import { orphanCommitsRoute, orphanEmailsRoute } from "../../../services/service-routes";


class AssignOrphanEmailToRosterStudent extends Component {

   
    constructor(props) {
       
        super(props);
        
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;

        this.state = {  
           
        };
    }

    componentDidMount() {
       
    }

    updateOrphanEmails = () => {
        console.log("updateOrphanEmails");
        console.log("this.props=",this.props);
        console.log("this.state=",this.state);
        console.log("empty_orphan_commits=",empty_orphan_commits);


        const url = orphanEmailsRoute(this.props.course_id);
        const params = {};
        // Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: url,
            type: "get",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data, status, xhr) {
                console.log("success");
                self.setState(prevState => ({ ...prevState, orphanEmails: data, orphanEmailsError: ""  }));
                console.log("success this.state=",this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, orphanEmails: [], orphanEmailsError: data }));
            }
        });
    }

    renderError() { 
        
        return (
            <div>
            {/* { orphanError !== "" &&
                <Alert id="error-alert-orphan-commits" variant="danger"> {orphanError} </Alert>
            }
             { orphanEmailsError !== "" &&
                <Alert id="error-alert-orphan-emails" variant="danger"> {orphanEmailsError} </Alert>
            } */}
            </div>
        );
    }

    assign_url = (course_id, email, roster_student_id) => `/courses/${course_id}/orphan_commits_by_email/assign?email=${email}&roster_student_id=${roster_student_id}`;
    
    render() {
        return (
           <>
            { this.renderError() }

            <RosterStudentAssign 
                assign_url={this.assign_url}
                field={'email'}
                {...this.props}
            />

           </>
        );
    }
}

AssignOrphanEmailToRosterStudent.propTypes = {
    
};

export default AssignOrphanEmailToRosterStudent;
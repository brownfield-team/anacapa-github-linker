import React, {Component} from 'react';
import * as PropTypes from 'prop-types';
import axios from "../../../helpers/axios-rails"
import ReactOnRails from "react-on-rails";

import OrphanCommitsByNamePanel from '../OrphanCommits/OrphanCommitsByNamePanel';
import OrphanNamesPanel from '../OrphanCommits/OrphanNamesPanel';
import { Alert, Form } from 'react-bootstrap';
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';

import { orphanCommitsRoute, orphanNamesRoute } from "../../../services/service-routes";


const empty_orphan_commits =  {
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
            repos: [], 
            orphanCommits: empty_orphan_commits,
            orphanNames: [],
        };
    }

    componentDidMount() {
        this.updateOrphanCommits();
        this.updateOrphanNames();
    }

    updateOrphanCommits = () => {
        console.log("updateOrphanCommits");
        console.log("this.props=",this.props);
        console.log("this.state=",this.state);
        console.log("empty_orphan_commits=",empty_orphan_commits);

        const url = orphanCommitsRoute(this.props.course_id);
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
                self.setState(prevState => ({ ...prevState, orphanCommits: data, orphanError: "" }));
                console.log("success this.state=",this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, orphanCommits: self.empty_orphan_commits, orphanError: data}));
            }
        });
    }

    updateOrphanNames = () => {
        console.log("updateOrphanNames");
        console.log("this.props=",this.props);
        console.log("this.state=",this.state);
        console.log("empty_orphan_commits=",empty_orphan_commits);


        const url = orphanNamesRoute(this.props.course_id);
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
                self.setState(prevState => ({ ...prevState, orphanNames: data, orphanNamesError: ""  }));
                console.log("success this.state=",this.state);
            },
            error: function (data) {
                console.log("failure");
                self.setState(prevState => ({ ...prevState, orphanNames: [], orphanNamesError: data }));
            }
        });
    }

    renderError() { 
        const orphanError = this.state.orphanError;
        const orphanNamesError = this.state.orphanNamesError;

        return (
            <div>
            { orphanError !== "" &&
                <Alert id="error-alert-orphan-commits" variant="danger"> {orphanError} </Alert>
            }
             { orphanNamesError !== "" &&
                <Alert id="error-alert-orphan-names" variant="danger"> {orphanNamesError} </Alert>
            }
            </div>
        );
    }

    render() {
        return (
           <>
            <h1>Orphan Commits</h1>
            { this.renderError() }

            <JSONPrettyPanel
                    expression={"this.props"}
                    value={this.props}
                />

            <OrphanCommitsByNamePanel
                orphanCommits={this.state.orphanCommits}
                course_id={this.props.course_id}
            />
            <OrphanNamesPanel
                names={this.state.orphanNames}
            />  
           </>
        );
    }
}

OrphanCommits.propTypes = {

};

export default OrphanCommits;
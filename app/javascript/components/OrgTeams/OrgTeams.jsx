import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch} from 'react-router-dom';
import OrgTeamsRouter from "./OrgTeamsRouter";
import axios from "../../helpers/axios-rails";
import ReactOnRails from "react-on-rails";

class OrgTeams extends Component {
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
                <BrowserRouter>
                    <OrgTeamsRouter/>
                </BrowserRouter>
            </Fragment>
        );
    }
}

OrgTeams.propTypes = {};

export default OrgTeams;
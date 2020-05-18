import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch} from 'react-router-dom';
import ProjectTeamsRouter from "./ProjectTeamsRouter";
import axios from "../../../helpers/axios-rails";
import ReactOnRails from "react-on-rails";

class ProjectTeams extends Component {
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
                    <ProjectTeamsRouter/>
                </BrowserRouter>
            </Fragment>
        );
    }
}

ProjectTeams.propTypes = {};

export default ProjectTeams;
import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch} from 'react-router-dom';
import ProjectTeamsRouter from "./ProjectTeamsRouter";
import TeamsDashboard from "./TeamsDashboard";
import NewProjectTeam from "./Forms/NewProjectTeam";
import ProjectTeam from "./ProjectTeam";
import EditProjectTeam from "./Forms/EditProjectTeam";
import TeamsService from "../services/teams-service";

class ProjectTeams extends Component {

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
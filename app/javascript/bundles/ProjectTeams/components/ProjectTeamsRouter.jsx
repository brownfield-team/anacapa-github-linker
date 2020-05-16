import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch} from "react-router-dom";
import TeamsDashboard from "./TeamsDashboard";
import NewProjectTeam from "./NewProjectTeam";
import ProjectTeam from "./ProjectTeam";

class ProjectTeamsRouter extends Component {
    render() {

        return (
            <Fragment>
                <Switch>
                    <Route exact path={rootPath} component={TeamsDashboard}/>
                    <Route exact path={newProjectTeamPath} component={NewProjectTeam}/>
                    <Route exact path={projectTeamPath} component={ProjectTeam}/>
                </Switch>
            </Fragment>
        );
    }
}

export const rootPath = `/courses/:courseId(\\d+)/project_teams`
export const projectTeamPath = `${rootPath}/:projectTeamId(\\d+)`;
export const newProjectTeamPath = `${rootPath}/new`;

export default ProjectTeamsRouter;
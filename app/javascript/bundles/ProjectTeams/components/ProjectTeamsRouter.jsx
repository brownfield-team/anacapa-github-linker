import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch, Redirect} from "react-router-dom";
import TeamsDashboard from "./Dashboard/TeamsDashboard";
import NewProjectTeam from "./Forms/NewProjectTeam";
import ProjectTeam from "./ProjectTeam";

class ProjectTeamsRouter extends Component {
    render() {

        return (
            <Fragment>
                <Switch>
                    {/* TODO: Find the proper way to handle trailing slashes so React Router doesn't throw a fit.
                     This is a hack. */}
                    <Redirect exact strict from={rootPath + '/'} to={rootPath}/>
                    <Route exact path={rootPath} component={TeamsDashboard}/>
                    <Route exact path={newProjectTeamPath} component={NewProjectTeam}/>
                    <Route path={projectTeamPath} component={ProjectTeam}/>
                </Switch>
            </Fragment>
        );
    }
}

export const rootPath = `/courses/:courseId(\\d+)/project_teams`
export const projectTeamPath = `${rootPath}/:projectTeamId(\\d+)`;
export const newProjectTeamPath = `${rootPath}/new`;

export default ProjectTeamsRouter;
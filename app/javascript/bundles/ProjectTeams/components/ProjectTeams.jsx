import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch} from 'react-router-dom';
import ProjectTeamsRouter from "./ProjectTeamsRouter";
import TeamsDashboard from "./TeamsDashboard";
import NewProjectTeam from "./NewProjectTeam";
import ProjectTeam from "./ShowProjectTeam";
import EditProjectTeam from "./EditProjectTeam";

class ProjectTeams extends Component {

    renderRouter() {
        const rootPath = `/courses/:courseId(\\d+)/project_teams`
        const projectTeamPath = `${rootPath}/:projectTeamId(\\d+)`;
        const editProjectTeamPath = `${projectTeamPath}/edit`;
        const newProjectTeamPath = `${rootPath}/new`;
        return (
            <Fragment>
                <Switch>
                    <Route exact path={rootPath} component={TeamsDashboard}/>
                    <Route exact path={newProjectTeamPath} component={NewProjectTeam}/>
                    <Route exact path={projectTeamPath} component={ProjectTeam}/>
                    <Route path={editProjectTeamPath} component={EditProjectTeam}/>
                </Switch>
            </Fragment>
        );
    }

    render() {
        return (
            <Fragment>
                <BrowserRouter>
                    {this.renderRouter()}
                </BrowserRouter>
            </Fragment>
        );
    }
}

ProjectTeams.propTypes = {};

export default ProjectTeams;
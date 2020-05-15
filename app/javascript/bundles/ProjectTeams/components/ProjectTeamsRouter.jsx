import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch} from "react-router-dom";
import TeamsDashboard from "./TeamsDashboard";
import NewProjectTeam from "./NewProjectTeam";
import ProjectTeam from "./ShowProjectTeam";
import EditProjectTeam from "./EditProjectTeam";

class ProjectTeamsRouter extends Component {
    render() {
        const rootProjectTeamPath = this.props.match.path;
        const projectTeamPath = `${rootProjectTeamPath}/:projectTeamId(\\d+)`;
        const newProjectTeamPath = `${rootProjectTeamPath}/new`;
        return (
            <Fragment>
                <Switch>
                    <Route exact path={rootProjectTeamPath} component={TeamsDashboard}/>
                    <Route path={newProjectTeamPath} component={NewProjectTeam}/>
                    <Route path={projectTeamPath} component={ProjectTeam}/>
                </Switch>
            </Fragment>
        );
    }
}

export default ProjectTeamsRouter;
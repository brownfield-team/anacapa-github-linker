import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch} from "react-router-dom";
import TeamsDashboard from "./TeamsDashboard";
import NewProjectTeam from "./Forms/NewProjectTeam";
import ShowProjectTeam from "./ShowProjectTeam";
import EditProjectTeam from "./Forms/EditProjectTeam";

class ProjectTeamsRouter extends Component {
    render() {
        const rootProjectTeamPath = this.props.match.path;
        const projectTeamPath = `${rootProjectTeamPath}/:projectTeamId(\\d+)`;
        const editProjectTeamPath = `${projectTeamPath}/edit`;
        const newProjectTeamPath = `${rootProjectTeamPath}/new`;
        return (
            <Fragment>
                <Switch>
                    <Route exact path={rootProjectTeamPath} component={TeamsDashboard}/>
                    <Route path={newProjectTeamPath} component={NewProjectTeam}/>
                    <Route exact path={projectTeamPath} component={ShowProjectTeam}/>
                    <Route exact path={editProjectTeamPath} component={EditProjectTeam}/>
                </Switch>
            </Fragment>
        );
    }
}

export default ProjectTeamsRouter;
import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {BrowserRouter, Route, Switch, Redirect} from "react-router-dom";
import OrgTeamsDashboard from "./Dashboard/OrgTeamsDashboard";
// import NewOrgTeam from "./Forms/NewOrgTeam";
// import OrgTeam from "./OrgTeam";

class OrgTeamsRouter extends Component {
    render() {

        return (
            <Fragment>
                <Switch>
                    {/* TODO: Find the proper way to handle trailing slashes so React Router doesn't throw a fit.
                     This is a hack. */}
                    <Redirect exact strict from={rootPath + '/'} to={rootPath}/>
                    <Route exact path={rootPath} component={OrgTeamsDashboard}/>
                    {/* <Route exact path={newProjectTeamPath} component={NewProjectTeam}/>
                    <Route path={projectTeamPath} component={ProjectTeam}/> */}
                </Switch>
            </Fragment>
        );
    }
}

export const rootPath = `/courses/:courseId(\\d+)/org_teams`
export const orgTeamPath = `${rootPath}/:orgTeamId(\\d+)`;
export const newOrgTeamPath = `${rootPath}/new`;

export default OrgTeamsRouter;
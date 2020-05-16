import React, {Component, Fragment} from 'react';
import {Route, Switch} from 'react-router-dom';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";
import TeamsService from "../services/teams-service";
import ShowProjectTeam from "./ShowProjectTeam";

class ProjectTeam extends Component {

    constructor(props) {
        super(props);
        this.state = {};
    }


    componentDidMount() {
        this.updateProjectTeam();
    }

    updateProjectTeam = () => {
        const params = this.props.match.params;
        TeamsService.getProjectTeam(params.courseId, params.projectTeamId).then(teamResponse => {
            this.setState({projectTeam: teamResponse});
        });
    }

    saveProjectTeam = (projectTeam) => {
        TeamsService.updateProjectTeam(projectTeam.id, projectTeam).then(teamResponse => {
            this.setState({projectTeam: teamResponse}, () => {
                this.props.history.push(this.props.match.path);
            });
        });
    };


    render() {
        const matchPath = this.props.match.path;
        return (
            <Fragment>
                {this.state.projectTeam && <Switch>
                    <Route exact path={matchPath}
                           render={(props) => <ShowProjectTeam {...props} projectTeam={this.state.projectTeam}/>}/>
                    <Route path={`${matchPath}/edit`}
                           render={() => <ProjectTeamForm projectTeam={this.state.projectTeam}
                                                          editable={true} {...props}/>}/>
                </Switch>}
            </Fragment>
        );
    }
}

export default ProjectTeam;
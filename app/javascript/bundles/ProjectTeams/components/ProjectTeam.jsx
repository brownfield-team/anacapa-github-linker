import React, {Component, Fragment} from 'react';
import {Redirect, Route, Switch} from 'react-router-dom';
import * as PropTypes from 'prop-types';
import TeamsService from "../services/teams-service";
import ShowProjectTeam from "./ShowProjectTeam";
import ProjectTeamForm from "./Forms/ProjectTeamForm";
import {rootPath} from "./ProjectTeamsRouter";

class ProjectTeam extends Component {

    constructor(props) {
        super(props);
        this.state = {};
    }


    componentDidMount() {
        this.updateProjectTeam();
    }

    courseId = () => {
        return this.props.match.params.courseId;
    }

    updateProjectTeam = () => {
        TeamsService.getProjectTeam(this.courseId(), this.props.match.params.projectTeamId).then(teamResponse => {
            this.setState({projectTeam: teamResponse});
        });
    }

    saveProjectTeam = (projectTeam) => {
        TeamsService.updateProjectTeam(this.courseId(), projectTeam.id, projectTeam).then(teamResponse => {
            this.setState({projectTeam: teamResponse}, () => {
                this.props.history.push(this.props.match.url);
            });
        });
    };

    deleteProjectTeam = () => {
        TeamsService.deleteProjectTeam(this.courseId(), this.state.projectTeam.id).then(response => {
            this.props.history.push('./')
        });
    };

    render() {
        const matchPath = this.props.match.path;
        return (
            <Fragment>
                {this.state.projectTeam &&
                <Switch>
                    <Route exact path={matchPath}
                           render={(props) => <ShowProjectTeam {...props} projectTeam={this.state.projectTeam}
                                                               deleteProjectTeam={this.deleteProjectTeam}/>}/>
                    <Route path={`${matchPath}/edit`}
                           render={(props) => <ProjectTeamForm projectTeam={this.state.projectTeam}
                                                               saveProjectTeam={this.saveProjectTeam}
                                                               editable={true} {...props}/>}/>
                </Switch>}
            </Fragment>
        );
    }
}

export default ProjectTeam;
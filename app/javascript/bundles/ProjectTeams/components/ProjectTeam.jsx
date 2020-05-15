import React, {Component, Fragment} from 'react';
import {Route, Switch} from 'react-router-dom';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";

class ProjectTeam extends Component {
    constructor(props) {
        super(props);

    }


    componentDidMount() {
        this.updateProjectTeam()
    }


    updateProjectTeam = (projectTeam) => {

    };


    render() {
        const matchPath = this.props.match.path;
        return (
            <Fragment>
                <Switch>
                    <Route exact path={matchPath}>
                        <ProjectTeamForm projectTeam={this.state.projectTeam} editable={false} />
                    </Route>
                    <Route path={`${matchPath}/edit`}>
                        <ProjectTeamForm projectTeam={this.state.projectTeam} saveProjectTeam={this.updateProjectTeam} editable={false} />
                    </Route>
                </Switch>
            </Fragment>
        );
    }
}

ProjectTeam.propTypes = {};

export default ProjectTeam;
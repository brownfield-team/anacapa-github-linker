import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";
import ProjectTeamModel from "../../models/ProjectTeamModel"
import TeamsService from "../../services/teams-service";

class NewProjectTeam extends Component {

    createProjectTeam = (projectTeam) => {
        TeamsService.createProjectTeam(this.props.match.params.courseId, projectTeam).then(teamResponse => {
            this.props.history.push(teamResponse.id.toString(
            ));
        });
    };

    render() {
        const projectTeam = new ProjectTeamModel(parseInt(this.props.match.params.courseId));
        return (
            <Fragment>
                <ProjectTeamForm projectTeam={projectTeam} saveProjectTeam={this.createProjectTeam}
                                 editable={true} {...this.props} />
            </Fragment>
        );
    }
}

NewProjectTeam.propTypes = {};

export default NewProjectTeam;
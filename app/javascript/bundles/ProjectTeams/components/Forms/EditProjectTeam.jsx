import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";
import TeamsService from "../../services/teams-service";

class EditProjectTeam extends Component {
    saveProjectTeam = (projectTeam) => {
        TeamsService.updateProjectTeam(this.props.match.params.courseId, projectTeam.id, projectTeam).then(teamResponse => {
            this.props.history.push(teamResponse.id.toString());
        });
    }

    render() {
        const projectTeam = new ProjectTeamModel(this.props.course_id); // TODO: Replace
        return (
            <Fragment>
                <ProjectTeamForm projectTeam={projectTeam} editable saveProjectTeam={this.saveProjectTeam}/>
            </Fragment>
        );
    }
}

EditProjectTeam.propTypes = {};

export default EditProjectTeam;
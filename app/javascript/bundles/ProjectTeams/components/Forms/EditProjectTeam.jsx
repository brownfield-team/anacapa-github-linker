import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";

class EditProjectTeam extends Component {
    render() {
        const projectTeam = new ProjectTeamModel(this.props.course_id); // TODO: Replace
        return (
            <Fragment>
                <ProjectTeamForm projectTeam={projectTeam} />
            </Fragment>
        );
    }
}

EditProjectTeam.propTypes = {};

export default EditProjectTeam;
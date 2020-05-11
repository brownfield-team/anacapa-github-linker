import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";

class NewProjectTeam extends Component {
    render() {
        const projectTeam = new ProjectTeam(this.props.course_id)
        return (
            <Fragment>
                <ProjectTeamForm projectTeam={projectTeam} />
            </Fragment>
        );
    }
}

NewProjectTeam.propTypes = {};

export default NewProjectTeam;
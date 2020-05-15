import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";
import ProjectTeam from "../models/ProjectTeam"

class NewProjectTeam extends Component {


    render() {
        const projectTeam = new ProjectTeam(this.props.match.params.courseId)
        return (
            <Fragment>
                <ProjectTeamForm projectTeam={projectTeam}  editable={true} />
            </Fragment>
        );
    }
}

NewProjectTeam.propTypes = {};

export default NewProjectTeam;
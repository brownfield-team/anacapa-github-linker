import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./ProjectTeamForm";
import ProjectTeamModel from "../models/ProjectTeamModel"

class NewProjectTeam extends Component {


    render() {
        const projectTeam = new ProjectTeamModel(this.props.match.params.courseId)
        return (
            <Fragment>
                <ProjectTeamForm projectTeam={projectTeam}  editable={true} {...this.props} />
            </Fragment>
        );
    }
}

NewProjectTeam.propTypes = {};

export default NewProjectTeam;
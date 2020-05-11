import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';

class ProjectTeamForm extends Component {
    constructor(props) {
        super(props);
        const projectTeam = this.props.projectTeam ?? new ProjectTeam(this.props.course_id)
        this.state = {orgTeamOptions: [], projectTeam: this.props.projectTeam}
    }


    updateOrgTeamOptions = () => {

    };

    render() {
        return (
            <Fragment>

            </Fragment>
        );
    }
}

ProjectTeamForm.propTypes = {
    projectTeam: PropTypes.object.isRequired
};

export default ProjectTeamForm;
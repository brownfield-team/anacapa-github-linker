import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';

class ProjectTeamForm extends Component {
    constructor(props) {
        super(props);
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
    editable: PropTypes.bool.isRequired,
    projectTeam: PropTypes.object.isRequired,
    saveProjectTeam: PropTypes.func
};

export default ProjectTeamForm;
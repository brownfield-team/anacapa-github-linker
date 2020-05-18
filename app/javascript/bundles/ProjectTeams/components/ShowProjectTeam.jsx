import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import ProjectTeamForm from "./Forms/ProjectTeamForm";

class ShowProjectTeam extends Component {
    render() {
        return (
            <Fragment>
                {/*<ProjectTeamForm editable={false} {...this.props} />*/}
            </Fragment>
        );
    }
}

ShowProjectTeam.propTypes = {
    projectTeam: PropTypes.object.isRequired
};

export default ShowProjectTeam;
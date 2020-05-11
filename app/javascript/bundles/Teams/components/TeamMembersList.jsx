import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';

class TeamMembersList extends Component {
    renderMember(member) {
        return (
          <Fragment key={member.id}>

          </Fragment>
        );
    };

    render() {
        return (
            <Fragment>
                {this.props.members.map(m => this.renderMember(m))}
            </Fragment>
        );
    }
}

TeamMembersList.propTypes = {
    members: PropTypes.array.isRequired
};

export default TeamMembersList;
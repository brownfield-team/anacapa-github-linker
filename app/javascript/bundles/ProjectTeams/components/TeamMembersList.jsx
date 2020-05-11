import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Badge} from "react-bootstrap";

class TeamMembersList extends Component {
    renderMember(member) {
        const student = member.roster_student;
        const studentLink = `/courses/${student.course_id}/roster_students/${student.id}`
        return (
          <Fragment key={member.id}>
              <a href={studentLink}><Badge pill variant="primary">{student.full_name}</Badge></a>
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
import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Label, OverlayTrigger, Tooltip} from "react-bootstrap";
import {studentUiRoute} from "../../../services/service-routes";

class TeamMembersList extends Component {
    renderMemberTooltip(member) {
        return (
            <Tooltip id={`tooltip-member-${member.id}`} bsPrefix="member">
                {member.roster_student.full_name}
                <br/>
                GitHub ID: {member.roster_student.username ?? "N/A"}
            </Tooltip>
        );
    }

    renderMember(member) {
        const student = member.roster_student;
        const studentLink = studentUiRoute(student.course_id, student.id);
        return (
            <Fragment key={member.id}>
                <OverlayTrigger placement="top" overlay={this.renderMemberTooltip(member)}
                                delay={{show: 250, hide: 400}}>
                    <a href={studentLink}><Label bsStyle="primary">{student.first_name}</Label></a>
                </OverlayTrigger>
                <span>&nbsp;</span>
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
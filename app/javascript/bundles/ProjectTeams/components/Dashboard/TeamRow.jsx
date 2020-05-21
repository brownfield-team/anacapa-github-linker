import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamMembersList from "./TeamMembersList";
import {Label} from "react-bootstrap";

class TeamRow extends Component {
    render() {
        const t = this.props.team; // Save some characters
        return (
            <tr key={t.id}>
                <td><a href={`project_teams/${t.id}`}>{t.name}</a></td>
                <td>{t.meeting_time}</td>
                <td>{t.project}</td>
                <td><TeamMembersList members={t.student_team_memberships}/></td>
                <td><a href={t.repo_url}><Label pill bsStyle="warning">Repo</Label></a></td>
                <td><a href={t.milestones_url}><Label pill bsStyle="success">Milestones</Label></a></td>
                <td><a href={t.project_board_url}><Label pill bsStyle="info">Project Board</Label></a></td>
                <td><a href={t.qa_url}><Label pill bsStyle="warning">QA</Label></a></td>
                <td><a href={t.production_url}><Label pill bsStyle="danger">Production </Label> </a></td>
                <td><a href={t.team_chat_url}><Label pill bsStyle="primary">Team Chat</Label></a></td>
            </tr>
        );
    }
}

TeamRow.propTypes = {
    team: PropTypes.object.isRequired
};

export default TeamRow;
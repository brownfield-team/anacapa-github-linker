import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamMembersList from "./TeamMembersList";
import {Badge} from "react-bootstrap";

class TeamRow extends Component {
    render() {
        const t = this.props.team; // Save some characters
        return (
            <tr key={t.id}>
                <td>{t.name}</td>
                <td>{t.meeting_time}</td>
                <td>{t.project}</td>
                <td><TeamMembersList members={t.student_team_memberships} /></td>
                <td><a href={t.repo_url}><Badge pill variant="warning">Repo</Badge></a></td>
                <td><a href={t.milestones_url}><Badge pill variant="success">Milestones</Badge></a></td>
                <td><a href={t.project_board_url}><Badge pill variant="inverse">Project Board</Badge></a></td>
                <td><a href={t.qa_url}><Badge pill={true} variant="info">QA</Badge></a></td>
                <td><a href={t.production_url}><Badge pill variant="error">Production</Badge></a></td>
                <td><a href={t.team_chat_url}><Badge pill variant="primary">Team Chat</Badge></a></td>
            </tr>
        );
    }
}

TeamRow.propTypes = {
    team: PropTypes.object.isRequired
};

export default TeamRow;
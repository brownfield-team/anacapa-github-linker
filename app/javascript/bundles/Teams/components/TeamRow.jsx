import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import TeamMembersList from "./TeamMembersList";

class TeamRow extends Component {
    render() {
        const t = this.props.team; // Save some characters
        return (
            <tr>
                <th>{t.name}</th>
                <th>{t.meeting_time}</th>
                <th>{t.project}</th>
                <th><TeamMembersList members={t.members} /></th>
                <th>{t.repo_url}</th>
            </tr>
        );
    }
}

TeamRow.propTypes = {
    team: PropTypes.object.isRequired
};

export default TeamRow;
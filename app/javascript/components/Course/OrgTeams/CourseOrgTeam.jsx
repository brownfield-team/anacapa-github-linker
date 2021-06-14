import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import CourseOrgTeamsTable from "./CourseOrgTeamsTable";
import CourseOrgTeamMemberList from "./CourseOrgTeamMemberList";


import OrgTeamsService from "../../../services/org-teams-service";


class CourseOrgTeam extends Component {

    constructor(props) {
        super(props);
        console.log("In constructor of CourseOrgTeam, props=",props);
        this.state = {team: undefined};
    }

    componentDidMount() {
        this.fetchTeam();
    }

    fetchTeam = () => {
        console.log("fetchTeam was called");
        OrgTeamsService.getOrgTeam(this.props.course_id, this.props.org_team_id).then(
            (team) => {
                console.log("callback for getOrgTeam: ", team);
                this.setState({team: team})
            }
        );
    }

    render() {
        const team = this.state.team;
        console.log("render, team=",team);

        if (team == null) return "Loading...";
        return (
            <Fragment>
                <CourseOrgTeamsTable
                    teams={[team.org_team]}
                    page={1}
                    pageSize={1}
                    totalSize={1}
                    {...this.props}
                />
                <CourseOrgTeamMemberList 
                    team={team}
                    {...this.props}
                />
            </Fragment>
        );
    }
}

CourseOrgTeam.propTypes = {
    org_team_id: PropTypes.string.isRequired,
    course_id: PropTypes.string.isRequired
};

export default CourseOrgTeam;

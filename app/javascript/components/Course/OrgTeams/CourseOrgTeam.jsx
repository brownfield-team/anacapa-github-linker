import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import CourseOrgTeamsTable from "./CourseOrgTeamsTable";

import OrgTeamsService from "../../../services/org-teams-service";


class CourseOrgTeam extends Component {

    constructor(props) {
        super(props);
        console.log("In constructor of CourseOrgTeam, props=",props);
        this.state = {org_team: undefined};
    }

    componentDidMount() {
        this.fetchTeam();
    }

    fetchTeam = () => {
        console.log("fetchTeam was called");
        OrgTeamsService.getOrgTeam(this.props.course_id, this.props.org_team_id).then(
            (team) => {
                console.log("callback for getOrgTeam: ", team);
                this.setState({org_team: team})
            }
        );
    }

    render() {
        const orgTeam = this.state.org_team;
        if (orgTeam == null) return "Loading...";
        return (
            <Fragment>
                <CourseOrgTeamsTable
                    teams={[orgTeam]}
                    page={1}
                    pageSize={1}
                    totalSize={1}
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

import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';

import PropTypes from 'prop-types';

class CourseOrgTeamMembersList extends Component {

    constructor(props) {
        console.log("CourseOrgTeamMembersList, props=",props)
        super(props);
    }

    columns =
        [
            {
                dataField: 'full_name',
                text: 'Student',
                editable: false,
                formatter: (cell, row, rowIndex, extraData) => this.renderRosterStudentShowPageUrl(cell, row, rowIndex, { "course_id": this.props.course_id })
            },
            {
                dataField: 'github_id',
                text: 'GitHub id',
                editable: false,
                formatter: (cell) => this.renderRosterStudentGithubUrl(cell)
            },
            {
                dataField: 'membership.role',
                text: 'Role',
                editable: false,
                formatter: (cell) => this.renderTeamMemberRole(cell)
            },
        ];

    renderRosterStudentShowPageUrl = (cell, row, rowIndex, extraData) => {
        const url = `/courses/${extraData.course_id}/roster_students/${row.membership.roster_student_id}`;

        return (
            <a href={url}>{cell}</a>
        );
    }

    renderRosterStudentGithubUrl = (cell) => {
        const url = `https://github.com/${cell}`;

        return (
            <a href={url}>{cell}</a>
        );
    }

    renderTeamMemberRole = (cell) => {
        // const url = `https://github.com/orgs/${put_org_name_here}/teams/${put_team_name_here}/members?query=${put_students_github_id_here}`;
        const url = "FIX_ME";
        return (
            <a href={url}>{cell}</a>
        );
    }

    render() {
        console.log("render in CourseOrgTeamMemberList, props=",this.props);
        return (
            <Fragment>
                <BootstrapTable
                    bootstrap4={true}
                    columns={this.columns}
                    data={this.props.team.members}
                    keyField="membership.id"                    
                />
            </Fragment>
        );
    }
}

CourseOrgTeamMembersList.propTypes = {
    team: PropTypes.object.isRequired,
};

export default CourseOrgTeamMembersList;

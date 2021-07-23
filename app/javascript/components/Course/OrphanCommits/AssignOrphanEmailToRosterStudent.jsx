import React, { Component } from 'react';
import RosterStudentAssign from '../../RosterStudents/RosterStudentAssign';


class AssignOrphanEmailToRosterStudent extends Component {

    constructor(props) {
        super(props);
    }

    assign_url = (course_id, email, roster_student_id) => `/courses/${course_id}/orphan_commits_by_email/assign?email=${encodeURIComponent(email)}&roster_student_id=${roster_student_id}`;

    render() {
        return (
            <RosterStudentAssign
                assign_url={this.assign_url}
                field={'email'}
                {...this.props}
            />
        );
    }
}

AssignOrphanEmailToRosterStudent.propTypes = {

};

export default AssignOrphanEmailToRosterStudent;
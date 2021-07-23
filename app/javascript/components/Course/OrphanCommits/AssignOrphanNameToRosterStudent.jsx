import React, { Component } from 'react';
import RosterStudentAssign from '../../RosterStudents/RosterStudentAssign';

class AssignOrphanNameToRosterStudent extends Component {

    constructor(props) {
        super(props);
    }

   
    assign_url = (course_id, name, roster_student_id) => `/courses/${course_id}/orphan_commits_by_name/assign/${encodeURIComponent(name)}/to/${roster_student_id}`;

    render() {
        return (
            <RosterStudentAssign
                assign_url={this.assign_url}
                field={'name'}
                {...this.props}
            />
        );
    }
}

AssignOrphanNameToRosterStudent.propTypes = {

};

export default AssignOrphanNameToRosterStudent;
import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import StudentsService from "../../../services/students-service";
import {studentUiRoute} from "../../../services/service-routes";
import {Table} from "react-bootstrap";
import SummaryView from "../SummaryView";
import ActivityTable from "../ActivityTable";

class StudentActivity extends Component {
    constructor(props) {
        super(props);
        this.state = {commits: []}
    }

    componentDidMount() {
        this.updateStudentCommits();
    }

    updateStudentCommits = () => {
        StudentsService.getCommits(this.props.course_id, this.props.roster_student_id).then(commitsResponse => {
            this.setState({commits: commitsResponse});
        });
    }

    render() {
        return (
            <Fragment>
                <SummaryView commits={this.state.commits} />
                <ActivityTable commits={this.state.commits} />
            </Fragment>
        );
    }
}

StudentActivity.propTypes = {
    course_id: PropTypes.number.isRequired,
    roster_student_id: PropTypes.number.isRequired
};

export default StudentActivity;
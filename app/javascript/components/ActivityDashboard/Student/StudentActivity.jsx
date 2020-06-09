import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import StudentsService from "../../../services/students-service";
import {studentUiRoute} from "../../../services/service-routes";
import {Table} from "react-bootstrap";
import SummaryView from "../SummaryView";
import ActivityTable from "../ActivityTable";
import moment from "moment";
import {Button} from "rsuite";


class StudentActivity extends Component {
    constructor(props) {
        super(props);
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - 30);
        const endDate = new Date();
        this.state = {commits: [], activityStream: [], startDate: startDate, endDate: endDate};
    }

    componentDidMount() {
        this.updateStudentCommits();
    }

    updateStudentCommits = () => {
        StudentsService.getCommits(this.props.course_id, this.props.roster_student_id).then(commitsResponse => {
            this.setState({commits: commitsResponse}, () => {
                this.refreshActivityStream();
            });
        });
    }

    refreshActivityStream = () => {
        // In the future, this will concatenate multiple arrays of activity streams.
        const activityStream = this.state.commits;
        this.setState({activityStream: activityStream});
    }

    render() {
        return (
            <Fragment>
                {/*<DateRangePicker />*/}
                <SummaryView activityStream={this.state.activityStream} startDate={this.state.startDate} endDate={this.state.endDate}/>
                <ActivityTable activityStream={this.state.activityStream}/>
            </Fragment>
        );
    }
}

StudentActivity.propTypes = {
    course_id: PropTypes.number.isRequired,
    roster_student_id: PropTypes.number.isRequired
};

export default StudentActivity;
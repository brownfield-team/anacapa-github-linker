import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import StudentsService from "../../../services/students-service";
import SummaryView from "../SummaryView";
import ActivityTable from "../ActivityTable";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

class StudentActivity extends Component {
    constructor(props) {
        super(props);
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - 30);
        const endDate = new Date();
        this.state = {commits: [], activityStream: [], startDate: startDate, endDate: endDate};
    }

    componentDidMount() {
        this.updateStudentActivity();
    }

    updateStudentActivity = () => {
        StudentsService.getActivity(this.props.course_id, this.props.roster_student_id, this.state.startDate, this.state.endDate)
            .then(activityResponse => {
                this.setState({activityStream: activityResponse});
            });
    };

    onDateRangeChanged = (date, isStart) => {
        if (isStart) {
            this.setState({startDate: date}, () => {
                this.updateStudentActivity();
            });
        }
        else {
            this.setState({endDate: date}, () => {
                this.updateStudentActivity();
            });
        }

    }

    render() {
        return (
            <Fragment>
                <DatePicker
                    selected={this.state.startDate}
                    onChange={date => this.onDateRangeChanged(date, true)}
                    selectsStart
                    startDate={this.state.startDate}
                    endDate={this.state.endDate}
                />
                &nbsp;to&nbsp;
                <DatePicker
                    style={{marginLeft: 10}}
                    selected={this.state.endDate}
                    onChange={date => this.onDateRangeChanged(date, false)}
                    selectsEnd
                    startDate={this.state.startDate}
                    endDate={this.state.endDate}
                    minDate={this.state.startDate}
                />
                <br/> <br/>
                <SummaryView activityStream={this.state.activityStream} startDate={this.state.startDate}
                             endDate={this.state.endDate}/>
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
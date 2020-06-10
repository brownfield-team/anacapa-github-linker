import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import StudentsService from "../../../services/students-service";
import SummaryView from "../SummaryView";
import ActivityTable from "../ActivityTable";
import {DateRangePicker} from "rsuite";
import * as dateFns from "date-fns";


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

    dateRanges = [
        {
            label: 'Last 7 days',
            value: [dateFns.subDays(new Date(), 2), new Date()]
        },
        {
            label: 'Last 7 days',
            value: [dateFns.subDays(new Date(), 6), new Date()]
        }, {
            label: 'Last 30 days',
            value: [dateFns.subDays(new Date(), 29), new Date()]
        }];

    onDateRangeChanged = (value) => {
        this.setState({startDate: value[0], endDate: value[1]}, () => {
            this.updateStudentActivity();
        });
    }

    render() {
        return (
            <Fragment>
                <DateRangePicker value={[this.state.startDate, this.state.endDate]}
                                 onChange={(value => this.onDateRangeChanged(value))}
                                 ranges={this.dateRanges}/>
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
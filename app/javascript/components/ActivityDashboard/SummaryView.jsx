import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Panel} from "react-bootstrap";
import * as _ from 'underscore';
import * as moment from 'moment';
import {Bar, BarChart, CartesianGrid, Legend, Tooltip, XAxis, YAxis} from "recharts";

class SummaryView extends Component {
    constructor(props) {
        super(props);
        this.state = {numCommits: 0, activityByDay: []};
    }

    componentDidMount() {
        console.log("Hi");
    }

    getDaysArray = (start, end) => {
        for (var arr = [], dt = new Date(start); dt <= end; dt.setDate(dt.getDate() + 1)) {
            arr.push({day: new Date(dt)});
        }
        return arr;
    };

    render() {
        const numCommits = this.props.activityStream.filter(act => act.event_type === 'Commit').length;
        const activityByDay = _.groupBy(this.props.activityStream, function (act) {
            return moment(act.updated_at).startOf('day').format('M/DD');
        });
        const activitySummaryByDay = this.getDaysArray(this.props.startDate, this.props.endDate);

        Object.keys(activityByDay).map(function (day) {
            const daySummary = {
                // As with other things, this will include other types of events in the future.
                day: day,
                commits: activityByDay[day].filter(act => act.event_type === 'Commit').length,
                fakeEvents: 2
            };
            activitySummaryByDay.push(daySummary);
        });
        console.log(activitySummaryByDay);
        return (
            <Fragment>
                <Panel>
                    <Panel.Heading>
                        <Panel.Title>Activity Summary</Panel.Title>
                    </Panel.Heading>
                    <Panel.Body>
                        <BarChart width={600} height={300} data={activitySummaryByDay}
                                  margin={{top: 20, right: 30, left: 20, bottom: 5}}>
                            <CartesianGrid strokeDasharray="3 3"/>
                            <XAxis dataKey="day"/>
                            <YAxis/>
                            <Tooltip/>
                            <Legend/>
                            <Bar dataKey="commits" stackId="a" fill="#8884d8"/>
                            <Bar dataKey="fakeEvents" stackId="a" fill="#82ca9d"/>
                        </BarChart>
                    </Panel.Body>
                </Panel>
            </Fragment>
        );
    }
}

SummaryView.propTypes = {
    startDate: PropTypes.object.isRequired,
    endDate: PropTypes.object.isRequired,
    activityStream: PropTypes.array.isRequired
};

export default SummaryView;
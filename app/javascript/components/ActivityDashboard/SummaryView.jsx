import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Col, Grid, Panel, Row} from "react-bootstrap";
import * as _ from 'underscore';
import * as moment from 'moment';
import {Bar, BarChart, Brush, CartesianGrid, Legend, ResponsiveContainer, Tooltip, XAxis, YAxis} from "recharts";
import {forEach} from "underscore";

class SummaryView extends Component {
    constructor(props) {
        super(props);
        this.state = {numCommits: 0, activityByDay: []};
    }

    getDaysArray = (start, end) => {
        for (var arr = [], dt = new Date(start); dt <= end; dt.setDate(dt.getDate() + 1)) {
            arr.push({day: moment(new Date(dt)).format('M/DD')});
        }
        return arr;
    };

    render() {
        const numCommits = this.props.activityStream.filter(act => act.event_type === 'Commit').length;
        const activityByDay = _.groupBy(this.props.activityStream, function (act) {
            return moment(act.updated_at).startOf('day').format('M/DD');
        });
        const activitySummaryByDay = this.getDaysArray(this.props.startDate, this.props.endDate);
        activitySummaryByDay.forEach(daySummary => {
            const dayActivity = activityByDay[daySummary.day];
            if (dayActivity != null) {
                // As with other things, this will include other types of events in the future.
                daySummary.commits = dayActivity.filter(act => act.event_type === 'Commit').length;
            } else {
                daySummary.commits = 0;
            }
            daySummary.fakeEvents = Math.floor(Math.random() * (5 - 1) + 1); // Temporary, for display purposes
        });
        return (
            <Fragment>
                <Panel>
                    <Panel.Heading>
                        <Panel.Title>Activity Summary</Panel.Title>
                    </Panel.Heading>
                    <Panel.Body>
                        <ResponsiveContainer width="95%" height={350}>
                            <BarChart data={activitySummaryByDay}
                                      margin={{top: 20, right: 30, left: 20, bottom: 5}}>
                                <CartesianGrid strokeDasharray="3 3"/>
                                <XAxis dataKey="day"/>
                                <YAxis/>
                                <Tooltip/>
                                <Legend verticalAlign="top"/>
                                <Bar name="Commits" dataKey="commits" stackId="a" fill="#0e9aa7"/>
                                <Bar name="Fake Events" dataKey="fakeEvents" stackId="a" fill="#fe8a71"/>
                                <Brush dataKey="name" height={30} stroke="#3da4ab"/>
                            </BarChart>
                        </ResponsiveContainer>
                        <br/>
                        <Grid>
                            <Row style={{paddingLeft: 50}}>
                                <Col style={{paddingLeft: 10, paddingRight:10}} md={2}>
                                    <Panel>
                                        <Panel.Heading>
                                            <Panel.Title>Commits</Panel.Title>
                                        </Panel.Heading>
                                        <Panel.Body>
                                            <h3>{numCommits}</h3>
                                        </Panel.Body>
                                    </Panel>
                                </Col>
                                <Col style={{paddingLeft: 10, paddingRight:10}} md={2}>
                                    <Panel>
                                        <Panel.Heading>
                                            <Panel.Title>Commits</Panel.Title>
                                        </Panel.Heading>
                                        <Panel.Body>
                                            <h3>{numCommits}</h3>
                                        </Panel.Body>
                                    </Panel>
                                </Col>
                            </Row>
                        </Grid>
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
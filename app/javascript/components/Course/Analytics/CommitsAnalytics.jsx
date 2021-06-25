import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';

import { PieChart } from 'react-chartkick'
import 'chartkick/chart.js'
import Papa from 'papaparse';

import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

class CommitsAnalytics extends Component {

    constructor(props) {
        super(props);
        this.state = {commitData: undefined, startDate: startDate, endDate: endDate};
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - 30);
        const endDate = new Date();
    }

    checkProperties(obj) {
        for (var key in obj) {
            if (obj[key] !== null && obj[key] != 0)
                return false;
        }
        return true;
    }

    componentDidMount() {
        this.getCommitData(this.props.team, undefined, undefined)
    }

    getCommitData = (team, startDate, endDate) => {
        var commitDataDict = {}

        for (const [key, value] of Object.entries(team.members)) {
            commitDataDict[value.full_name] = null
        }

        for (const [key, repos] of Object.entries(team.repos)) {
            const response = fetch(`/api/courses/${team.org_team.course_id}/github_repos/${repos.repo.github_repo_id}/repo_commit_events`).then(response => response.json()).then(json => {
                for (let i = 1; i < json.length; i++) {
                    var student_name = json[i]["roster_student"]["first_name"] + " " + json[i]["roster_student"]["last_name"]
                    if (student_name in commitDataDict) {
                        if (startDate != undefined && endDate != undefined) {
                            if (json.data[i]["commit_timestamp"] > startDate.toISOString() && json[i]["commit_timestamp"] < endDate.toISOString()) {
                                commitDataDict[student_name] += json[i]["additions"]
                                commitDataDict[student_name] += json[i]["deletions"]
                            }
                        } else {
                            commitDataDict[student_name] += json[i]["additions"]
                            commitDataDict[student_name] += json[i]["deletions"]
                        }
                    }
                }

                if (this.checkProperties(commitDataDict)) {
                    commitDataDict = {}
                }

                this.setState({commitData: commitDataDict})
            });
        }
    }

    onDateRangeChanged = (date, isStart) => {
        if (isStart) {
            this.setState({startDate: date});
        }
        else {
            this.setState({endDate: date});
        }
    }

    onButtonClick() {
        const startDate = this.state.startDate;
        const endDate = this.state.endDate;

        this.getCommitData(this.props.team, startDate, endDate)
        this.forceUpdate()
    }

    render() {
        const commitData = this.state.commitData;

        if (commitData == null) return "Loading...";
        
        return (
            <Fragment>
                <PieChart data={commitData} legend="bottom" width="500px" height="500px" empty="No Commits" />
                <div style={{ display: "flex", alignItems: "center", justifyContent: "center" }} >
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
                    <a onClick={() => this.onButtonClick()}>
                        <button>Get Commits</button>
                    </a>
                </div>
            </Fragment>
        );
    }
}

CommitsAnalytics.propTypes = {
    team: PropTypes.object.isRequired,
};

export default CommitsAnalytics;
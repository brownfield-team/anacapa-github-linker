import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';

import { ColumnChart } from 'react-chartkick'
import 'chartkick/chart.js'

import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

import Loader from "react-loader-spinner";

class ChangeAnalytics extends Component {

    constructor(props) {
        super(props);
        this.state = {commitData: undefined, startDate: startDate, endDate: endDate, loading: false, repoTitle: undefined, projRepos: undefined};
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - 30);
        const endDate = new Date();
    }

    noCommitsFound(name_to_locchanged_count) {
        for (var name in name_to_locchanged_count) {
            if (name_to_locchanged_count[name] !== null && name_to_locchanged_count[name] != 0)
                return false;
        }
        return true;
    }

    componentDidMount() {
        this.getProjectRepos(this.props.team)
    }

    componentDidUpdate(prevProps, prevState) {
        if (prevProps.team != this.props.team) {
            this.getProjectRepos(this.props.team)
        }

        if (prevProps.project_repo_id != this.props.project_repo_id) {
            this.setState({loading: true})
            this.getProjectRepos(this.props.team)
        }
    }

    getProjectRepos = (team) => {
        if (this.props.project_repo_id != undefined) {
            const response = fetch(`/api/courses/${team.org_team.course_id}/github_repos/${this.props.project_repo_id}`).then(response => response.json()).then(json => {
                this.setState({ repoTitle: json["name"], projRepos: json})
            }).then(response => {
                this.getCommitData(this.props.team, undefined, undefined)
            })
        } else {
            this.getCommitData(this.props.team, undefined, undefined)
        }
    }

    commitInDateRange = (commit, start_date, end_date) => {
        if (start_date == undefined || end_date==undefined) 
            return true
        return commit["commit_timestamp"] > start_date.toISOString() &&  commit["commit_timestamp"] < end_date.toISOString();
    }

    getCommitData = (team, startDate, endDate) => {
        this.setState({loading: true})
        var name_to_locchanged_count = {}

        for (const [key, value] of Object.entries(team.members)) {
            name_to_locchanged_count[value.full_name] = null
        }

        if (this.props.project_repo_id != undefined) {
            const response = fetch(`/api/courses/${team.org_team.course_id}/github_repos/${this.props.project_repo_id}/repo_commit_events`).then(response => response.json()).then(
                commits => {
                    commits.forEach( (commit) => {
                        if (commit["roster_student_id"] != null) {
                            var student_name = commit["roster_student"]["first_name"] + " " + commit["roster_student"]["last_name"]
                            if (student_name in name_to_locchanged_count) {
                                if (this.commitInDateRange(commit, startDate, endDate)) {
                                    name_to_locchanged_count[student_name] += commit["additions"]
                                    name_to_locchanged_count[student_name] += commit["deletions"]
                                }
                            }
                        }
                    })

                    if (this.noCommitsFound(name_to_locchanged_count)) {
                        name_to_locchanged_count = {}
                    }

                    this.setState({commitData: name_to_locchanged_count, loading: false})
                });

        } else {
            if (this.noCommitsFound(name_to_locchanged_count)) {
                name_to_locchanged_count = {}
            }

            this.setState({commitData: name_to_locchanged_count, loading: false})
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
                {this.state.repoTitle}
                {this.state.loading && <Loader type="TailSpin" color="#00BFFF" height={80} width={80}/>}
                {!this.state.loading && <ColumnChart data={commitData} width="900px" height="500px" empty="No Changes" colors={["red", "blue", "green", "yellow", "purple", "pink", "orange"]} disabled={this.state.loading}/>}
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
                        <button>Get Change</button>
                    </a>
                </div>
            </Fragment>
        );
    }
}

ChangeAnalytics.propTypes = {
    team: PropTypes.object.isRequired,
    project_repo_id: PropTypes.string,
};

export default ChangeAnalytics;
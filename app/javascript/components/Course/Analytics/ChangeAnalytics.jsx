import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';

import { ColumnChart } from 'react-chartkick'
import 'chartkick/chart.js'

import {ButtonToolbar, DropdownButton, MenuItem} from "react-bootstrap";

import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

import Loader from "react-loader-spinner";

class ChangeAnalytics extends Component {

    constructor(props) {
        super(props);
        this.state = {commitData: undefined, startDate: startDate, endDate: endDate, loading: false, repoId: undefined, repoTitle: undefined, projRepos: undefined};
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
        this.getProjectRepos(this.props.team)
    }

    getProjectRepos = (team) => {
        const response = fetch(`/api/courses/${team.org_team.course_id}/github_repos?is_project_repo=true`).then(response => response.json()).then(json => {
            if (json.length > 0) {
                this.setState({repoId: json[0]["id"], repoTitle: json[0]["name"], projRepos: json})
            }
        }).then(response => {
            this.getCommitData(this.props.team, undefined, undefined)
        })
    }

    getCommitData = (team, startDate, endDate) => {
        this.setState({loading: true})
        var commitDataDict = {}

        for (const [key, value] of Object.entries(team.members)) {
            commitDataDict[value.full_name] = null
        }

        const response = fetch(`/api/courses/${team.org_team.course_id}/github_repos/${this.state.repoId}/repo_commit_events`).then(response => response.json()).then(json => {
            console.log("json", json)
            for (let i = 1; i < json.length; i++) {
                if (json[i]["roster_student_id"] != null) {
                    var student_name = json[i]["roster_student"]["first_name"] + " " + json[i]["roster_student"]["last_name"]
                    if (student_name in commitDataDict) {
                        if (startDate != undefined && endDate != undefined) {
                            if (json[i]["commit_timestamp"] > startDate.toISOString() && json[i]["commit_timestamp"] < endDate.toISOString()) {
                                commitDataDict[student_name] += json[i]["additions"]
                                commitDataDict[student_name] += json[i]["deletions"]
                            }
                        } else {
                            commitDataDict[student_name] += json[i]["additions"]
                            commitDataDict[student_name] += json[i]["deletions"]
                        }
                    }
                }
            }

            if (this.checkProperties(commitDataDict)) {
                commitDataDict = {}
            }

            this.setState({commitData: commitDataDict, loading: false})
        });
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

    onButtonClickGetRepo(repoName) {
        this.setState({loading: true})
        const response = fetch(`/api/courses/${this.props.course_id}/github_repos/`).then(response => response.json()).then(json => {
            for (const [key, repo] of Object.entries(json)) {
                if (repo["name"] == repoName) {
                    this.setState({repoId: repo["id"], repoTitle: repo["name"]})

                    this.getCommitData(this.props.team, this.state.startDate, this.state.endDate)
                    this.forceUpdate()
                }
            }

            this.setState({loading: false})
        });
    }

    render() {
        const commitData = this.state.commitData;

        if (commitData == null) return "Loading...";
        
        return (
            <Fragment>
                <div style={{ display: "flex", alignItems: "center", justifyContent: "flex-end", padding: "0px", margin: "0px" }}>
                    <ButtonToolbar>
                        <DropdownButton title="Change Repo" id="dropdown-size-medium">
                            {this.state.projRepos.map((object, index) => {
                                return(<MenuItem key={object["name"]} onClick={() => this.onButtonClickGetRepo(object["name"])}>{object["name"]}</MenuItem>);
                            })}
                        </DropdownButton>
                    </ButtonToolbar>
                </div>
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
};

export default ChangeAnalytics;
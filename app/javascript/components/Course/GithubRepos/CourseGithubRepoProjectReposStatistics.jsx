import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'
import BootstrapTable from 'react-bootstrap-table-next';

import vectorToCounts, {combineCounts, vectorToObject, errorToObject, objectToVector} from '../../../utilities/vectorToCounts';
import { graphqlRoute } from "../../../services/service-routes";
import GraphqlQuery from "../../../services/graphql-query"
import IssueUserEdits from "../../../graphql/IssueUserEdits"
import IssueTimelineItems from "../../../graphql/IssueTimelineItems"
import JSONPretty from 'react-json-pretty';

import isEqual from 'lodash.isequal';
import cloneDeep from "lodash.clonedeep"
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';

import OrphanCommitsPanel from '../OrphanCommits/OrphanCommitsPanel';

export default class CourseGithubReposProjectReposStatistics extends Component {
    constructor(props) {
        super(props);
        GraphqlQuery.csrf_token_fix();
        this.state = {
            repos:null,
            issueEdits:null,
            team_stats: {},
            team_stats_vector: [],
            student_stats: {},
            student_stats_vector: [],
            edit_combined_count: {},
            edit_combined_count_by_student: {},
            timeline_combined_count: {},
            timeline_combined_count_by_student: {}

        }
    }


    courseId = () => this.props.course.id;
    orgName = () => this.props.course.course_organization;
    repoName = (repo) => repo.name;



    componentDidUpdate(prevProps,prevState) {
        if (!isEqual(this.props.repos,this.state.repos)) {
            this.setState({repos: this.props.repos});
            this.updateIssues();
        }
    }

    updateIssues = () => {
        const repos = this.props.repos;

        const repo_names = repos.map(
            (r) => r.name
        )

        let repo_keys_to_null = vectorToObject(repo_names,()=>null);
        let repo_keys_to_empty_array = vectorToObject(repo_names,()=>[]);

        this.setState({
            edit_query_results: { ...repo_keys_to_null },
            edit_stats: { ...repo_keys_to_null },
            edit_combined_count: {},
            edit_combined_count_by_student: {},
            timeline_query_results: { ...repo_keys_to_null },
            timeline_stats: { ...repo_keys_to_null },
            timeline_combined_count: {},
            timeline_combined_count_by_student: {},
            overall_combined_count_by_team: {},
            errors: { ... repo_keys_to_empty_array}
        });

        const url = graphqlRoute(this.courseId());

        repos.forEach( (repo) => {
            let ieQuery = IssueUserEdits.query(this.orgName(), this.repoName(repo), "");
            let ieAccept =  IssueUserEdits.accept();
            let tlQuery = IssueTimelineItems.query(this.orgName(), this.repoName(repo), "");
            let tlAccept =  IssueTimelineItems.accept();
            let setIssueEdits = (o) => {
                let new_edit_query_results = this.state.edit_query_results;
                let new_edit_stats = this.state.edit_stats;
                let new_edit_combined_count = this.state.edit_combined_count;
                let new_edit_combined_count_by_student = this.state.edit_combined_count_by_student;

                let new_overall_combined_count_by_team =
                    this.state.overall_combined_count_by_team;
                let new_errors = this.state.errors;

                if(o.success) {
                    try {
                        new_edit_query_results[this.repoName(repo)] = cloneDeep(o);
                        let this_repos_stats = IssueUserEdits.computeStats(o.data, this.props.databaseId_to_team);
                        new_edit_stats[this.repoName(repo)] = this_repos_stats;
                        new_edit_combined_count = combineCounts(
                            new_edit_combined_count,
                            this_repos_stats.statistics.activityTeamsCounts
                        );
                        new_edit_combined_count_by_student = combineCounts(
                            new_edit_combined_count_by_student,
                            this_repos_stats.statistics.activityCounts
                        );
                        new_overall_combined_count_by_team = combineCounts(
                            new_overall_combined_count_by_team,
                            this_repos_stats.statistics.timelineItemsTeamsCount
                        );
                    } catch (e) {
                        new_errors[this.repoName(repo)].push(errorToObject(e))
                    }
                } else {
                    new_errors[this.repoName(repo)].push(o.error)
                }

                this.setState({
                    edit_query_results: new_edit_query_results,
                    edit_stats: new_edit_stats,
                    edit_combined_count: new_edit_combined_count,
                    edit_combined_count_by_student: new_edit_combined_count_by_student,
                    overall_combined_count_by_team: new_overall_combined_count_by_team,
                    errors: new_errors,
                });
                this.computeOverallTeamStats();
                this.computeOverallStudentStats();
            }

            let setIssueTimelineItems = (o) => {
                let new_timeline_query_results = this.state.timeline_query_results;
                let new_timeline_stats = this.state.timeline_stats;
                let new_timeline_combined_count = this.state.timeline_combined_count;
                let new_timeline_combined_count_by_student = this.state.timeline_combined_count_by_student;

                let new_overall_combined_count_by_team =
                        this.state.overall_combined_count_by_team;
                let new_errors = this.state.errors;

                if(o.success) {
                    try {
                        new_timeline_query_results[this.repoName(repo)] = cloneDeep(o);
                        let this_repos_stats = IssueTimelineItems.computeStats(o.data, this.props.databaseId_to_team);
                        new_timeline_stats[this.repoName(repo)] = this_repos_stats;
                        new_timeline_combined_count = combineCounts(
                            new_timeline_combined_count,
                            this_repos_stats.statistics.timelineItemsTeamsCount
                        );
                        new_timeline_combined_count_by_student = combineCounts(
                            new_timeline_combined_count_by_student,
                            this_repos_stats.statistics.timelineItemsCounts
                        );
                        new_overall_combined_count_by_team = combineCounts(
                            new_overall_combined_count_by_team,
                            this_repos_stats.statistics.timelineItemsTeamsCount
                        );
                    } catch (e) {
                        new_errors[this.repoName(repo)].push(errorToObject(e))
                    }
                } else {
                    new_errors[this.repoName(repo)].push(o.error)
                }

                this.setState({
                    timeline_query_results: new_timeline_query_results,
                    timeline_stats: new_timeline_stats,
                    timeline_combined_count: new_timeline_combined_count,
                    timeline_combined_count_by_student: new_timeline_combined_count_by_student,
                    overall_combined_count_by_team: new_overall_combined_count_by_team,
                    errors: new_errors,
                });
                this.computeOverallTeamStats();
                this.computeOverallStudentStats();
            }

            let issueEditsQueryObject = new GraphqlQuery(url,ieQuery,ieAccept,setIssueEdits,{repo: repo.name});
            issueEditsQueryObject.post();
            let timelineItemsQueryObject = new GraphqlQuery(url,tlQuery,tlAccept,setIssueTimelineItems,{repo: repo.name});
            timelineItemsQueryObject.post();
        });
    }

    computeOverallTeamStats = () => {
        const teamNamesVector = this.props.org_teams.map( (t)=> t.name);
        let team_stats = {}
        Object.keys(this.state.edit_combined_count).forEach(
            (team) => {
                if (! (team in team_stats)) {
                    team_stats[team] = {issueEdits: 0, timelineItems: 0, total: 0}
                }
                team_stats[team]["issueEdits"] += this.state.edit_combined_count[team]
                team_stats[team]["total"] += this.state.edit_combined_count[team]
            }
        );
        Object.keys(this.state.timeline_combined_count).forEach(
            (team) => {
                if (! (team in team_stats)) {
                    team_stats[team] = {issueEdits: 0, timelineItems: 0, total: 0}
                }
                team_stats[team]["timelineItems"] += this.state.timeline_combined_count[team]
                team_stats[team]["total"] += this.state.timeline_combined_count[team]
            }
        );

        const team_stats_vector = objectToVector(team_stats,"name");

        this.setState({
            team_stats: team_stats,
            team_stats_vector: team_stats_vector
        });
    }


    computeOverallStudentStats = () => {
        const databaseIds = Object.keys(this.props.databaseId_to_student)
        let student_stats = {}
        Object.keys(this.state.edit_combined_count_by_student).forEach(
            (databaseId) => {
                if (! (databaseId in student_stats)) {
                    student_stats[databaseId] = {issueEdits: 0, timelineItems: 0, total: 0}
                }
                student_stats[databaseId]["issueEdits"] += this.state.edit_combined_count_by_student[databaseId]
                student_stats[databaseId]["total"] += this.state.edit_combined_count_by_student[databaseId]
            }
        );
        Object.keys(this.state.timeline_combined_count_by_student).forEach(
            (databaseId) => {
                if (! (databaseId in student_stats)) {
                    student_stats[databaseId] = {issueEdits: 0, timelineItems: 0, total: 0}
                }
                student_stats[databaseId]["timelineItems"] += this.state.timeline_combined_count_by_student[databaseId]
                student_stats[databaseId]["total"] += this.state.timeline_combined_count_by_student[databaseId]
            }
        );

        Object.keys(student_stats).forEach(
            (databaseId) => {
                student_stats[databaseId]["team"]= (databaseId in this.props.databaseId_to_team) ?
                    this.props.databaseId_to_team[databaseId] :
                    "N/A";
                if (databaseId in this.props.databaseId_to_student) {
                    let student = this.props.databaseId_to_student[databaseId];
                    student_stats[databaseId]["login"] = student.login;
                    student_stats[databaseId]["name"] = student.name;

                } else {
                    student_stats[databaseId]["login"] = "N/A";
                    student_stats[databaseId]["name"] = "N/A";
                }
            }
        );

        const student_stats_vector = objectToVector(student_stats,"databaseId");

        this.setState({
            student_stats: student_stats,
            student_stats_vector: student_stats_vector
        });
    }


    team_stats_columns =
    [{
        dataField: 'name',
        text: 'Team Name',
        editable: false,
        sort: true
    }, {
        dataField: 'issueEdits',
        text: 'Issue Edits',
        editable: false,
        sort: true
    }, {
        dataField: 'timelineItems',
        text: 'Issue Timeline Items',
        editable: false,
        sort: true
    }, {
        dataField: 'total',
        text: 'Total',
        editable: false,
        sort: true
    }];

    student_stats_columns =
    [{
        dataField: 'databaseId',
        text: 'uid',
        editable: false,
        sort: true
    }, {
        dataField: 'login',
        text: 'GitHub login',
        editable: false,
        sort: true
    },{
        dataField: 'name',
        text: 'Name',
        editable: false,
        sort: true
    },{
        dataField: 'team',
        text: 'Team',
        editable: false,
        sort: true
    }, {
        dataField: 'issueEdits',
        text: 'Issue Edits',
        editable: false,
        sort: true
    },{
        dataField: 'timelineItems',
        text: 'Issue Timeline Items',
        editable: false,
        sort: true
    }, {
        dataField: 'total',
        text: 'Total',
        editable: false,
        sort: true
    }];

    render() {
        const generalDebugging = (
            <Fragment>
                <JSONPrettyPanel
                    expression={"this.state.team_stats"}
                    value={this.state.team_stats}
                />
                <JSONPrettyPanel
                    expression={"this.state.team_stats_vector"}
                    value={this.state.team_stats_vector}
                />
                 <JSONPrettyPanel
                    expression={"this.state.student_stats"}
                    value={this.state.student_stats}
                />
                <JSONPrettyPanel
                    expression={"this.state.student_stats_vector"}
                    value={this.state.student_stats_vector}
                />
                <JSONPrettyPanel
                    expression={"this.state.overall_combined_count_by_team"}
                    value={this.state.overall_combined_count_by_team}
                />
                <JSONPrettyPanel
                    expression={"this.state.errors"}
                    value={this.state.errors}
                />
                <JSONPrettyPanel
                    expression={"this.props.course"}
                    value={this.props.course}
                />
                 <JSONPrettyPanel
                    expression={"this.props.org_teams"}
                    value={this.props.org_teams}
                />
                <JSONPrettyPanel
                    expression={"this.props.databaseId_to_team"}
                    value={this.props.databaseId_to_team}
                />
                <JSONPrettyPanel
                    expression={"this.props.databaseId_to_student"}
                    value={this.props.databaseId_to_student}
                />
                 <JSONPrettyPanel
                    expression={"this.state.repos"}
                    value={this.state.repos}
                />
            </Fragment>
        );

        const issueUserEditsDebugging = (
            <Fragment>
                <JSONPrettyPanel
                    expression={"this.state.edit_combined_count"}
                    value={this.state.edit_combined_count}
                />
                <JSONPrettyPanel
                    expression={"this.state.edit_combined_count_by_student"}
                    value={this.state.edit_combined_count_by_student}
                />
                <JSONPrettyPanel
                    expression={"this.state.edit_stats"}
                    value={this.state.edit_stats}
                />
                <JSONPrettyPanel
                    expression={"this.state.edit_query_results"}
                    value={this.state.edit_query_results}
                />
            </Fragment>
        );

        const issueTimelineItemsDebugging = (
            <Fragment>
                <JSONPrettyPanel
                    expression={"this.state.timeline_combined_count"}
                    value={this.state.timeline_combined_count}
                />
                <JSONPrettyPanel
                    expression={"this.state.timeline_combined_count_by_student"}
                    value={this.state.timeline_combined_count_by_student}
                />
                <JSONPrettyPanel
                    expression={"this.state.timeline_stats"}
                    value={this.state.timeline_stats}
                />
                 <JSONPrettyPanel
                    expression={"this.state.timeline_query_result"}
                    value={this.state.timeline_query_results}
                />
            </Fragment>
        );

        const debugging = (
            <Fragment>
            <Panel id="collapsible-panel-general-debugging" >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            General Debugging
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {generalDebugging}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <Panel id="collapsible-panel-issue-useredit-stats">
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Issue User Edits Debugging
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {issueUserEditsDebugging}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <Panel id="collapsible-panel-issue-timeline-debugging" >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Issue Timeline Items Debugging
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {issueTimelineItemsDebugging}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
            </Fragment>
        )

        const team_statistics = (
            <Fragment>
                <BootstrapTable
                    columns={this.team_stats_columns}
                    data={this.state.team_stats_vector}
                    keyField="name"
                    hidePageListOnlyOnePage={true}
                />
            </Fragment>
        );

        const student_statistics = (
            <Fragment>
               <BootstrapTable
                    columns={this.student_stats_columns}
                    data={this.state.student_stats_vector}
                    keyField="databaseId"
                    hidePageListOnlyOnePage={true}
                />
            </Fragment>
        );

        return (
            <Fragment>
                 {/* <Panel id="collapsible-panel-team-statistics" defaultExpanded >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Orphan Commits
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <p>Orphan Commits UI goes Here</p>
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel> */}
                <OrphanCommitsPanel {...this.props} />
                <Panel id="collapsible-panel-team-statistics" defaultExpanded >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Team Statistics
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {team_statistics}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <Panel id="collapsible-panel-student-statistics">
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Student Statistics
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {student_statistics}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <Panel id="collapsible-panel-debugging" >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Debugging
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {debugging}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
            </Fragment>
        );
    }
}

CourseGithubReposProjectReposStatistics.propTypes = {
    course_id : PropTypes.number.isRequired,
    course: PropTypes.object.isRequired,
    databaseId_to_student: PropTypes.object.isRequired,
    databaseId_to_team: PropTypes.object.isRequired,
    org_teams: PropTypes.array.isRequired
};


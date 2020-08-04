import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'

import vectorToCounts, {combineCounts, vectorToObject, errorToObject} from '../../../utilities/vectorToCounts';
import { graphqlRoute } from "../../../services/service-routes";
import GraphqlQuery from "../../../services/graphql-query"
import IssueUserEdits from "../../../graphql/IssueUserEdits"
import IssueTimelineItems from "../../../graphql/IssueTimelineItems"
import JSONPretty from 'react-json-pretty';

import isEqual from 'lodash.isequal';
import cloneDeep from "lodash.clonedeep"

export default class CourseGithubReposProjectReposStatistics extends Component {
    constructor(props) {
        super(props);
        GraphqlQuery.csrf_token_fix();
        this.state = {
            repos:null, 
            issueEdits:null,
             }
    }


    courseId = () => this.props.course.id;
    orgName = () => this.props.course.course_organization;
    repoName = (repo) => repo.repo.name;


    componentDidUpdate(prevProps,prevState) {
        if (!isEqual(this.props.repos,this.state.repos)) {
            this.setState({repos: this.props.repos});
            this.updateIssues();
        }
    }

    updateIssues = () => {
        const repos = this.props.repos;

        const repo_names = repos.map(
            (r) => r.repo.name
        )

        let repo_keys_to_null = vectorToObject(repo_names,()=>null);
        let repo_keys_to_empty_array = vectorToObject(repo_names,()=>[]);

        this.setState({ 
            edit_query_results: { ...repo_keys_to_null },
            edit_stats: { ...repo_keys_to_null },
            edit_combined_count: {},
            timeline_query_results: { ...repo_keys_to_null },
            timeline_stats: { ...repo_keys_to_null },
            timeline_combined_count: {},
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
                let new_errors = this.state.errors;

                if(o.success) {
                    try {
                        new_edit_query_results[this.repoName(repo)] = cloneDeep(o);
                        let this_repos_stats = IssueUserEdits.computeStats(o.data, this.props.databaseId_to_team);
                        new_edit_stats[this.repoName(repo)] = this_repos_stats;
                        new_edit_combined_count = combineCounts(
                            new_edit_combined_count,
                            this_repos_stats.statistics.activityTeamsCounts
                        )
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
                    errors: new_errors,
                });
            }

            let setIssueTimelineItems = (o) => {
                let new_timeline_query_results = this.state.timeline_query_results;
                let new_timeline_stats = this.state.timeline_stats;
                let new_timeline_combined_count = this.state.timeline_combined_count;
                let new_errors = this.state.errors;

                if(o.success) {
                    try {
                        new_timeline_query_results[this.repoName(repo)] = cloneDeep(o);
                        let this_repos_stats = IssueTimelineItems.computeStats(o.data, this.props.databaseId_to_team);
                        new_timeline_stats[this.repoName(repo)] = this_repos_stats;
                        new_timeline_combined_count = combineCounts(
                            new_timeline_combined_count,
                            this_repos_stats.statistics.timelineItemsTeamsCount
                        )
                        console.log(`new_timeline_combined_count, ${JSON.stringify(new_timeline_combined_count,null,2)}`)
                        console.log(`this_repos_stats.statistics.timelineItemsCount, ${JSON.stringify(this_repos_stats.statistics.timelineItemsCount,null,2)}`)
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
                    errors: new_errors,
                });
            }

            let issueEditsQueryObject = new GraphqlQuery(url,ieQuery,ieAccept,setIssueEdits,{repo: repo.name});
            issueEditsQueryObject.post();
            let timelineItemsQueryObject = new GraphqlQuery(url,tlQuery,tlAccept,setIssueTimelineItems,{repo: repo.name});
            timelineItemsQueryObject.post();
        });
    }

    render() {
        const statsDisplay = (
            <Fragment>
                
                <p><code>this.state.edit_combined_count:</code></p>
                <JSONPretty data={this.state.edit_combined_count} />
                <p><code>this.state.timeline_combined_count:</code></p>
                <JSONPretty data={this.state.timeline_combined_count} />
                <p><code>this.state.edit_stats:</code></p>
                <JSONPretty data={this.state.edit_stats} />
                <p><code>this.state.timeline_stats:</code></p>
                <JSONPretty data={this.state.timeline_stats} />
            </Fragment>
        );
        const debugDisplay = (
            <Fragment>
            
               <p><code>this.state.errors:</code></p>
                <JSONPretty data={this.state.errors} />

                <p><code>this.state.edit_query_results:</code></p>
                <JSONPretty data={this.state.edit_query_results} />

                <p><code>this.props.databaseId_to_team:</code></p>
                <JSONPretty data={this.props.databaseId_to_team} />

                <p><code>this.props.databaseId_to_student:</code></p>
                <JSONPretty data={this.props.databaseId_to_student} />

                <p><code>this.state.repos:</code></p>
                <JSONPretty data={this.state.repos} />
               
            </Fragment>
        );
        return (
            <Fragment>
                <Panel id="collapsible-panel-issue-useredit-stats" defaultExpanded>
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Issue User Edit Statistics
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {statsDisplay}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <Panel id="collapsible-panel-issue-useredit-debugging" >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Issue User Edits Debugging
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {debugDisplay}
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
    databaseId_to_team: PropTypes.object.isRequired
};


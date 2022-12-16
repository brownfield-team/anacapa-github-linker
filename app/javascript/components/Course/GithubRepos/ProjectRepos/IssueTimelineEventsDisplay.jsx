import React, { Component } from 'react';
import IssueTimelineEventsTable from './IssueTimelineEventsTable';
import PropTypes from 'prop-types';

import GraphqlQuery from "services/graphql-query";
import { graphqlRoute } from "services/service-routes";

import IssueTimelineItems from "graphql/IssueTimelineItems";
import cloneDeep from "lodash.clonedeep"
import JSONPrettyPanel from 'components/Utilities/JsonPrettyPanel';

import isEqual from 'lodash.isequal';

class IssueTimelineEventsDisplay extends Component {

    constructor(props) {
        super(props);
        GraphqlQuery.csrf_token_fix();
        this.state = {
            repos:null,
            events: [],
            timeline_query_results: {},
        }
    }

    componentDidUpdate(prevProps,prevState) {
        if (!isEqual(this.props.repos,this.state.repos)) {
            this.setState({repos: this.props.repos});
            this.updateEvents();
        }
    }
   
    courseId = () => this.props.course.id;
    orgName = () => this.props.course.course_organization;
    repoName = (repo) => repo.name;

    updateEvents = () => {
        const repos = this.props.repos;

        console.log("updateEvents was called");
        console.log("this.props is",this.props);
        console.log("this.props.repos is",this.props.repos);

        const url = graphqlRoute(this.courseId());

        console.log("url=",url);

        repos.forEach( (repo) => {
            console.log("repo=",repo);
            let allEvents = [];
            let tlQuery = IssueTimelineItems.query(this.orgName(), this.repoName(repo), "");
            let tlAccept =  IssueTimelineItems.accept();

            let setIssueTimelineItems = (o) => {
                let new_timeline_query_results = this.state.timeline_query_results;
                let new_errors = this.state.errors;

                if(o.success) {
                    try {
                        new_timeline_query_results[this.repoName(repo)] = cloneDeep(o);
                        let thisReposEvents = IssueTimelineItems.computeIssueTimelineEventsTable(o.data, this.props.databaseId_to_team);
                        allEvents = allEvents.concat(thisReposEvents.events);
                    } catch (e) {
                        new_errors[this.repoName(repo)].push(errorToObject(e))
                    }
                } else {
                    new_errors[this.repoName(repo)].push(o.error)
                }

                this.setState({
                    timeline_query_results: new_timeline_query_results,
                    events: allEvents,
                    errors: new_errors,
                });
            }

            let timelineItemsQueryObject = new GraphqlQuery(url,tlQuery,tlAccept,setIssueTimelineItems,{repo: repo.name});
            timelineItemsQueryObject.post();
    
        });

        console.log("updateEvents is finished");
    }

    /* TODO: Add code that gets the events from the backend */

    render() {
        return (
            <>
                <h2>Issue Timeline Events</h2>
                <IssueTimelineEventsTable events={this.state.events } course={this.props.course} />
                <JSONPrettyPanel
                    expression={"this.state.timeline_query_results"}
                    value={this.state.timeline_query_results}
                />
                 <JSONPrettyPanel
                    expression={"this.state.errors"}
                    value={this.state.errors}
                />
                 <JSONPrettyPanel
                    expression={"this.state.events"}
                    value={this.state.events}
                />
            </>              
        );
    }
}

IssueTimelineEventsDisplay.propTypes = {
    course_id : PropTypes.number.isRequired,
    course: PropTypes.object.isRequired,
    databaseId_to_student: PropTypes.object.isRequired,
    databaseId_to_team: PropTypes.object.isRequired,
    org_teams: PropTypes.array.isRequired
};


export default IssueTimelineEventsDisplay;

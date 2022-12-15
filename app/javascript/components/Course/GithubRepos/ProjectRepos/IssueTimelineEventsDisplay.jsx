import React, { Component } from 'react';
import IssueTimelineEventsTable from './IssueTimelineEventsTable';
import PropTypes from 'prop-types';

import GraphqlQuery from "services/graphql-query";

import isEqual from 'lodash.isequal';

class IssueTimelineEventsDisplay extends Component {

    constructor(props) {
        super(props);
        GraphqlQuery.csrf_token_fix();
        this.state = {
            repos:null,
            events:null
        }
    }

    componentDidUpdate(prevProps,prevState) {
        if (!isEqual(this.props.repos,this.state.repos)) {
            this.setState({repos: this.props.repos});
            this.updateEvents();
        }
    }
   
    updateEvents = () => {
        console.log("updateEvents was called");
        console.log("this.props is",this.props);
        console.log("this.props.repos is",this.props.repos);
        console.log("updateEvents is finished");
    }

    /* TODO: Add code that gets the events from the backend */

    render() {
        return (
            <>
                <h2>Issue Timeline Events</h2>
                <IssueTimelineEventsTable events={[]} course={this.props.course} />
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

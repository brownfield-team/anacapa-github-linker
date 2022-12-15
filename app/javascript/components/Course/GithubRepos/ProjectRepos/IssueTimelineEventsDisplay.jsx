import React, { Component } from 'react';
import IssueTimelineEventsTable from './IssueTimelineEventsTable';
import PropTypes from 'prop-types';

import GraphqlQuery from "services/graphql-query";

class IssueTimelineEventsDisplay extends Component {

    constructor(props) {
        super(props);
        GraphqlQuery.csrf_token_fix();
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
    course: PropTypes.object
};

export default IssueTimelineEventsDisplay;

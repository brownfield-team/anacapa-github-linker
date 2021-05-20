import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import IssueTimelineItems from "../../../graphql/IssueTimelineItems";
import { graphqlRoute } from "../../../services/service-routes";
import JSONPretty from 'react-json-pretty';
import GraphqlQuery from "../../../services/graphql-query"
import { Panel } from 'react-bootstrap';

export default class CourseGithubRepoIssueTimeline extends Component {

    constructor(props) {
        super(props);
        GraphqlQuery.csrf_token_fix();
        this.state = { timelineItems: null};
    }

    componentDidMount() {
        this.updateIssues();
    }

    updateIssues = () => {
        const url = graphqlRoute(this.courseId());

        const tlQuery = IssueTimelineItems.query(this.orgName(), this.repoName(), ""); 
        const tlAccept =  IssueTimelineItems.accept();
       
        const setTimelineItems = (o) => {this.setState({timelineItems: o});}
        const timelineQueryObject = new GraphqlQuery(url,tlQuery,tlAccept,setTimelineItems);
        timelineQueryObject.post();
    }

    courseId = () => this.props.repo.repo.course_id;
    orgName = () => this.props.course.course_organization;
    repoName = () => this.props.repo.repo.name;


    render() {

       let statsDisplay = "";
       let debugDisplay = "";
       
        if (this.state.timelineItems && 
            this.state.timelineItems.success) {
            let statistics = IssueTimelineItems.computeStats(this.state.timelineItems.data)
            statsDisplay = (
                <JSONPretty data={statistics}></JSONPretty>
            )
            debugDisplay = (
                <Fragment>
                    <p>status_code: {this.state.timelineItems.status}</p>
                    <JSONPretty data={this.state.timelineItems.data}></JSONPretty>
                </Fragment>
            )
        } else if (this.state.timelineItems && 
                   this.state.timelineItems.status != 0) {
            debugDisplay = (
                <Fragment>
                    <p>status_code: {this.state.timelimeItems.status} status: {this.state.error.status} </p>
                    <pre>{this.state.timelimeItems.error}</pre>
                </Fragment>
            )
        }
        return (
            <Fragment>
                 <Panel id="collapsible-panel-issue-timeline-stats" defaultExpanded>
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Issue Timeline Item Statistics
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                            {statsDisplay}
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <Panel id="collapsible-panel-issue-timeline-debugging" >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Issue Timeline Item Debugging
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

CourseGithubRepoIssueTimeline.propTypes = {
    repo : PropTypes.object.isRequired,
    course: PropTypes.object.isRequired,
};


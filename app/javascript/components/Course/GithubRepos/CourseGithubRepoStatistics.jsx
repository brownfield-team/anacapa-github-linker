import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import IssueTimelineItems from "../../../graphql/IssueTimelineItems";
import { graphqlRoute } from "../../../services/service-routes";
import JSONPretty from 'react-json-pretty';
import GraphqlQuery from "../../../services/graphql-query"
import IssueUserEdits from '../../../graphql/IssueUserEdits';
import { Panel } from 'react-bootstrap';

class CourseGithubRepoStatistics extends Component {

    constructor(props) {
        super(props);

        this.state = { issueEdits : null, timelineItems: null};
        console.log(`constructor:, this.state=${JSON.stringify(this.state)}`);
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

        const ieQuery = IssueUserEdits.query(this.orgName(), this.repoName(), ""); 
        const ieAccept =  IssueUserEdits.accept();
       
        const setIssueEdits = (o) => {this.setState({issueEdits: o});}
        const issueEditsQueryObject = new GraphqlQuery(url,ieQuery,ieAccept,setIssueEdits);
        issueEditsQueryObject.post();
    }

    courseId = () => this.props.repo.repo.course_id;
    orgName = () => this.props.course.course_organization;
    repoName = () => this.props.repo.repo.name;

    computeStats = (data) => {
      
        let statistics = {};
        let errors = {};

        try {
            let issues = data.data.repository.issues;
            let issueNodes = issues.nodes;
            let timelineItemsTotalCountVector =
               issueNodes.map( (n) => n.timelineItems.totalCount);
            let sum = (a,b)=>a+b;
            let timelineItemsCount = 
                timelineItemsTotalCountVector.reduce(sum, 0)
            statistics["totalIssues"] = issues.totalCount;
            statistics["timelineItemsCount"] = timelineItemsCount;
        } catch(e) { 
             errors = {
                 name : e.name,
                 message: e.message
             };
         }

        return {
            statistics: statistics,
            errors: errors
        };
        return {}
    }

    render() {
       console.log(`render called: this.state=${JSON.stringify(this.state)}`);

       let statsDisplay = "";
       let debugDisplay = "";
       
        if (this.state.timelineItems && 
            this.state.timelineItems.success) {
            let statistics = this.computeStats(this.state.timelineItems.data)
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
                <Panel id="collapsible-panel-issue-timeline-debugging" defaultCollapsed>
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

CourseGithubRepoStatistics.propTypes = {
    repo : PropTypes.object.isRequired,
    course: PropTypes.object.isRequired,
};

export default CourseGithubRepoStatistics;
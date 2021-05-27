import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import IssueUserEdits from "../../../graphql/IssueUserEdits";
import { graphqlRoute } from "../../../services/service-routes";
import JSONPretty from 'react-json-pretty';
import GraphqlQuery from "../../../services/graphql-query"
import { Panel } from 'react-bootstrap';


export default class CourseGithubRepoIssueUserEdits extends Component {

    constructor(props) {
        super(props);
        GraphqlQuery.csrf_token_fix();
        this.state = { issueEdits : null};
    }

    componentDidMount() {
        console.log(this.props.repo);
        this.updateIssues();
    }

    updateIssues = () => {
        const url = graphqlRoute(this.courseId());

        const ieQuery = IssueUserEdits.query(this.orgName(), this.repoName(), "");
        const ieAccept =  IssueUserEdits.accept();

        const setIssueEdits = (o) => {this.setState({issueEdits: o});}
        const issueEditsQueryObject = new GraphqlQuery(url,ieQuery,ieAccept,setIssueEdits);
        issueEditsQueryObject.post();
    }

    courseId = () => this.props.repo.course_id;
    orgName = () => this.props.repo.organization;
    repoName = () => this.props.repo.name;

    render() {
       let statsDisplay = "";
       let debugDisplay = "";

        if (this.state.issueEdits &&
            this.state.issueEdits.success) {
            let statistics = IssueUserEdits.computeStats(this.state.issueEdits.data, this.props.databaseId_to_team)
            statsDisplay = (
                <JSONPretty data={statistics}></JSONPretty>
            )
            debugDisplay = (
                <Fragment>
                    <p>status_code: {this.state.issueEdits.status}</p>
                    <JSONPretty data={this.state.issueEdits.data}></JSONPretty>
                </Fragment>
            )
        } else if (this.state.issueEdits &&
                   this.state.issueEdits.status != 0) {
            debugDisplay = (
                <Fragment>
                    <p>status_code: {this.state.issueEdits.status} status: {this.state.error.status} </p>
                    <pre>{this.state.issueEdits.error}</pre>
                </Fragment>
            )
        }
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

CourseGithubRepoIssueUserEdits.propTypes = {
    repo : PropTypes.object.isRequired,
    course: PropTypes.object.isRequired,
    databaseId_to_student: PropTypes.object.isRequired,
    databaseId_to_team: PropTypes.object.isRequired
};


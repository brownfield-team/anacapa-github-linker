import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import IssueUserEdits from "../../../graphql/IssueUserEdits";
import { graphqlRoute } from "../../../services/service-routes";
import JSONPretty from 'react-json-pretty';
import GraphqlQuery from "../../../services/graphql-query"
import { Panel } from 'react-bootstrap';
import vectorToCounts, {combineCounts} from '../../../utilities/vectorToCounts';

export default class CourseGithubRepoIssueUserEdits extends Component {

    constructor(props) {
        super(props);
        this.state = { issueEdits : null};
    }

    componentDidMount() {
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

    courseId = () => this.props.repo.repo.course_id;
    orgName = () => this.props.course.course_organization;
    repoName = () => this.props.repo.repo.name;


    convertDatabaseIdMapToLogin = (dbId2Value) => {
        let result = {}
        Object.keys(dbId2Value).forEach( (oldKey) => {
            let newKey
            try {
              newKey = this.props.databaseId_to_student[oldKey].login
            } catch (e) {
               newKey = oldKey
            }
            result[newKey] = dbId2Value[oldKey]
        });
        return result;
    }

    computeStats = (data) => {
      
        let statistics = {};
        let errors = {};

        try {
            let issues = data.data.repository.issues;
            let issueNodes = issues.nodes;

            let userEditTotalCountVector =
                    issueNodes.map( (n) => n.userContentEdits.totalCount);
            let sum = (a,b)=>a+b;
            let userContentEditCount  = 
                userEditTotalCountVector.reduce(sum, 0)
            
            let issueAuthorsVector = 
                issueNodes.map( (n) => n.author.databaseId );

            let issueAuthorsLoginsVector = 
                issueNodes.map( (n) => n.author.login );
                
            let issueAuthorsLoginsCounts = vectorToCounts(issueAuthorsLoginsVector);

            let issueEditorsVector =  issueNodes.map( (n) => 
                    n.userContentEdits.nodes.map( (e) =>
                        e.editor.databaseId
                    ) 
                ).flat();

            let issueEditorsLoginsVector =  issueNodes.map( (n) => 
                n.userContentEdits.nodes.map( (e) =>
                    e.editor.login
                ) 
            ).flat();    

            let issueEditorsLoginsCounts = vectorToCounts(issueEditorsLoginsVector);

            statistics["totalUserEdits"] = issues.totalCount;

            statistics["issueAuthorsLoginsCounts"] = issueAuthorsLoginsCounts;

            statistics["issueEditorsLoginsCounts"] = issueEditorsLoginsCounts;

            statistics["activityCounts"] = combineCounts(
                statistics["issueAuthorsLoginsCounts"],
                statistics["issueEditorsLoginsCounts"]
            );
        
            let issueAuthorsTeamsVector = issueAuthorsVector.map(
                (databaseId) => this.props.databaseId_to_team[databaseId]
            );
            let issueAuthorTeamsCounts = vectorToCounts(issueAuthorsTeamsVector);

            let issueEditorsTeamsVector = issueEditorsVector.map(
                (databaseId) => this.props.databaseId_to_team[databaseId]
            );
            let issueEditorsTeamsCounts = vectorToCounts(issueEditorsTeamsVector);

            // statistics["issueAuthorsTeamsVector"] = issueAuthorsTeamsVector;
            statistics["issueAuthorTeamsCounts"] = issueAuthorTeamsCounts;
            statistics["issueEditorsTeamsCounts"] = issueEditorsTeamsCounts;
            statistics["activityTeamsCounts"] = combineCounts(issueAuthorTeamsCounts,issueEditorsTeamsCounts);
       
                
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
       let statsDisplay = "";
       let debugDisplay = "";
       
        if (this.state.issueEdits && 
            this.state.issueEdits.success) {
            let statistics = this.computeStats(this.state.issueEdits.data)
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


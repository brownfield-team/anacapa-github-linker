import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'

import vectorToCounts, {combineCounts} from '../../../utilities/vectorToCounts';
import { graphqlRoute } from "../../../services/service-routes";
import GraphqlQuery from "../../../services/graphql-query"
import IssueUserEdits from "../../../graphql/IssueUserEdits"

import JSONPretty from 'react-json-pretty';

import isEqual from 'lodash.isequal';

export default class CourseGithubReposProjectReposStatistics extends Component {
    constructor(props) {
        super(props);
        // console.log(`constructor props=${JSON.stringify(props)}`);
        this.state = {repos:null, issueEdits:null}
        // console.log(`constructor this.state=${JSON.stringify(this.state)}`);
    }


    componentDidMount() {
        this.updateIssues();
    }

    courseId = () => this.props.course.id;
    orgName = () => this.props.course.course_organization;
    repoName = (repo) => repo.repo.name;


    componentDidUpdate(prevProps,prevState) {
        // console.log(`componentDidUpdate prevProps=${JSON.stringify(prevProps)}`);
        // console.log(`componentDidUpdate prevState=${JSON.stringify(prevState)}`);

        // console.log(`componentDidUpdate this.props=${JSON.stringify(this.props)}`);

        if (!isEqual(this.props.repos,this.state.repos)) {
            this.setState({repos: this.props.repos});
            this.updateIssues();
        }
        // console.log(`componentDidUpdate this.state=${JSON.stringify(this.state)}`);
    }

    updateIssues = () => {
        // console.log(`updateIssues this.props=${JSON.stringify(this.props)}`);

        const repos = this.props.repos;

        const repo_names = repos.map(
            (r) => r.repo.name
        )
        // console.log(`updateIssues repo_names=${JSON.stringify(repo_names)}`);

        let repo_keys_to_null = {}
        repo_names.forEach(
            (repo_name)=>{
                repo_keys_to_null[repo_name] = null;
            }
        )
        this.setState({ repo_edit_stats: { ...repo_keys_to_null }});
        // console.log(`updateIssues this.props=${JSON.stringify(this.props)}`);
        // console.log(`updateIssues this.state=${JSON.stringify(this.state)}`);

        const url = graphqlRoute(this.courseId());

        repos.forEach( (repo) => {
            let ieQuery = IssueUserEdits.query(this.orgName(), this.repoName(repo), ""); 
            let ieAccept =  IssueUserEdits.accept();

            let setIssueEdits = (o) => {
                let new_repo_edit_stats = this.state.repo_edit_stats 
                new_repo_edit_stats[repo.name] = o;
                this.setState({repo_edit_stats: new_repo_edit_stats});
                // console.log(`post callback: this.state=${JSON.stringify(this.state)}`);
            }
            let issueEditsQueryObject = new GraphqlQuery(url,ieQuery,ieAccept,setIssueEdits);
            issueEditsQueryObject.post();
        });
    }

    render() {
        // console.log(`render this.props=${JSON.stringify(this.props)}`);
        // console.log(`render this.state=${JSON.stringify(this.state)}`);
        const statsDisplay = (
            <Fragment>
                
            </Fragment>
        );
        const debugDisplay = (
            <Fragment>
               
                <p><code>this.props.databaseId_to_team:</code></p>
                <JSONPretty data={this.props.databaseId_to_team} />

                <p><code>this.props.databaseId_to_student:</code></p>
                <JSONPretty data={this.props.databaseId_to_student} />

                <p><code>this.state.repos:</code></p>
                <JSONPretty data={this.state.repos} />
            
                <p><code>this.state.repo_edit_stats:</code></p>
                <JSONPretty data={this.state.repo_edit_stats} />

               
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


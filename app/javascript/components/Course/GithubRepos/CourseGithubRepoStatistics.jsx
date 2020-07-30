import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import IssueTimelineItems from "../../../graphql/IssueTimelineItems";
import { graphqlRoute } from "../../../services/service-routes";
import JSONPretty from 'react-json-pretty';
import GraphqlQuery from "../../../services/graphql-query"


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
        console.log(`url=${url}`);
        const query = IssueTimelineItems.query(this.orgName(), this.repoName(), ""); 
        const accept =  IssueTimelineItems.accept();
       
        const setTimelineItems = (o) => {this.setState({timelineItems: o});}
        const timelineQueryObject = 
            new GraphqlQuery(url,query,accept,setTimelineItems);


        timelineQueryObject.post();
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

       let display = "";
        if (this.state.timelineItems && 
            this.state.timelineItems.success) {
            let statistics = this.computeStats(this.state.timelineItems.data)
            display = (
                <Fragment>
                    <p>status_code: {this.state.timelineItems.status}</p>
                    <JSONPretty data={statistics}></JSONPretty>
                    <JSONPretty data={this.state.timelineItems.data}></JSONPretty>
                </Fragment>
            )
        } else if (this.state.timelineItems && 
                   this.state.timelineItems.status != 0) {
            display = (
                <Fragment>
                    <p>status_code: {this.state.timelimeItems.status} status: {this.state.error.status} </p>
                    <pre>{this.state.timelimeItems.error}</pre>
                </Fragment>
            )
        }
        return (
            <Fragment>
                 <div className="panel panel-default">
                    <div className="panel-heading">
                        <div className="panel-title">Statistics</div>
                    </div>
                    <div className="panel-body">
                        {display}
                    </div>
                </div>
            </Fragment>
        );
    }
}

CourseGithubRepoStatistics.propTypes = {
    repo : PropTypes.object.isRequired,
    course: PropTypes.object.isRequired,
};

export default CourseGithubRepoStatistics;
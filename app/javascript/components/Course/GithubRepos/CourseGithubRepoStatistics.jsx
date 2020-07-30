import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import IssueUserEdits from "../../../graphql/IssueUserEdits";
import IssueTimelineItems from "../../../graphql/IssueTimelineItems";
import { graphqlRoute } from "../../../services/service-routes";
import JSONPretty from 'react-json-pretty';


class CourseGithubRepoStatistics extends Component {

    constructor(props) {
        super(props);
        this.state = { success: true, xhr_status: 0, data: {}, errors: {} };
        console.log(`constructor:, this.state=${JSON.stringify(this.state)}`);
    }

    componentDidMount() {
        this.updateIssues();
    }

    updateIssues = () => {
        const url = graphqlRoute(this.courseId());
        const params = { 
            query: IssueTimelineItems.query(this.orgName(), this.repoName(), ""), 
            accept: IssueTimelineItems.accept()
        };
        const self = this; // needed to call self.setState below inside error function
        Rails.ajax({
            url: url,
            type: "post",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data, status, xhr) {
                // const totalRecords = parseInt(xhr.getResponseHeader("X-Total"));
                // const page = parseInt(xhr.getResponseHeader("X-Page"));
                // next line must be self.setState, not this.setState
                // because this refers to success function in this context
                console.log(`status=${status}`)
                self.setState({ 
                    success: true,
                    xhr_status: xhr.status,
                    data: data,  
                    error: {} 
                });
            },
            error: function (data, status, xhr) {
                // must be self.setState not this.setState
                self.setState({ 
                    success: false,
                    xhr_status: xhr.status,
                    data: {}, 
                    error: {
                        status: status,
                        data: data
                    }
                });
            }
        });
        console.log(`this.state=${JSON.stringify(this.state)}`);
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
       let display = "";
        if (this.state.success) {
            let statistics = this.computeStats(this.state.data)
            display = (
                <Fragment>
                    <p>status_code: {this.state.xhr_status}</p>
                    <JSONPretty data={statistics}></JSONPretty>
                    <JSONPretty data={this.state.data}></JSONPretty>
                </Fragment>
            )
        } else if (this.state.xhr_status != 0) {
            display = (
                <Fragment>
                    <p>status_code: {this.state.xhr_status} status: {this.state.error.status} </p>
                    <pre>{this.state.error.data}</pre>
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
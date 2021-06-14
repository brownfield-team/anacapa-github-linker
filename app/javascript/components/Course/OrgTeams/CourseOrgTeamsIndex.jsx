import React, { Component } from 'react';
import PropTypes from 'prop-types';
import CourseOrgTeamsTable from "./CourseOrgTeamsTable";

import { Alert } from 'react-bootstrap';

import { orgTeamsRoute } from "../../../services/service-routes";

class CourseOrgTeamsIndex extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "", type: this.props.visibility ?? "", error: "", teams: [], page: 1, pageSize: 25, totalSize: 0 };
    }

    componentDidMount() {
        this.updateTeams();
    }

    performSearch = (searchValue) => {
        this.setState({page: 1, search: searchValue}, () => {
            this.updateTeams();
        });
    }

    onVisibilityChanged = (visibilityValue) => {
        if (visibilityValue === this.props.visibility) {
            return;
        }

        this.setState({page: 1, visibility: visibilityValue}, () => {
           this.updateTeams();
        });
    }

    paginationHandler = (page, pageSize) => {
        this.setState({page: page, pageSize: pageSize}, () => {
            this.updateTeams();
        });
    }

    updateTeams = () => {
        const url = orgTeamsRoute(this.props.course_id);
        const params = {search: this.state.search, visibility: this.state.visibility, page: this.state.page, per_page: this.state.pageSize};
        // Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: url,
            type: "get",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data, status, xhr) {
                const totalRecords = parseInt(xhr.getResponseHeader("X-Total"));
                const page = parseInt(xhr.getResponseHeader("X-Page"));
                self.setState({ teams: data, totalSize: totalRecords, page: page, error: "" });
            },
            error: function (data) {
                self.setState({ error: data });
            }
        });
    }

    renderError() { // Or don't
        const error = this.state.error;
        return (
            <div>
            { error !== "" &&
                <Alert id="error-alert" variant="danger"> {error} </Alert>
            }
            </div>
        );
    }

    render() {
        return (
            <div>
                { this.renderError() }
                <CourseOrgTeamsTable
                    teams={this.state.teams}
                    page={this.state.page}
                    pageSize={this.state.pageSize}
                    totalSize={this.state.totalSize}
                    paginationHandler={this.paginationHandler}
                    course={this.props.course}
                    {...this.props}
                />
            </div>
        );
    }
}

CourseOrgTeamsIndex.propTypes = {
    search: PropTypes.string,
    type: PropTypes.string,
    course_id : PropTypes.number.isRequired,
    course : PropTypes.object.isRequired
};

export default CourseOrgTeamsIndex;
import React, { Component } from 'react';
import PropTypes from 'prop-types';

import { Alert, Panel, DropdownButton, MenuItem, ButtonToolbar } from 'react-bootstrap';

import { orgTeamsRoute } from "../../../services/service-routes";
import CourseOrgTeam from './CourseOrgTeam';

class CourseOrgTeamsIndex extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "", type: this.props.visibility ?? "", error: "", teams: [], org_team_id: undefined, teamName: undefined };
    }

    componentDidMount() {
        this.updateTeams();
    }

    performSearch = (searchValue) => {
        this.setState({ search: searchValue }, () => {
            this.updateTeams();
        });
    }

    onVisibilityChanged = (visibilityValue) => {
        if (visibilityValue === this.props.visibility) {
            return;
        }

        this.setState({ visibility: visibilityValue }, () => {
            this.updateTeams();
        });
    }

    updateTeams = () => {
        const url = orgTeamsRoute(this.props.course_id);
        const params = { search: this.state.search, visibility: this.state.visibility };
        // self=this; Otherwise , calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: url,
            type: "get",
            data: $.param(params),
            beforeSend: function () {
                return true;
            },
            success: function (data, status, xhr) {
                const totalRecords = parseInt(xhr.getResponseHeader("X-Total"));

                if (self.state.org_team_id == undefined && data.length > 0) {
                    self.setState({ org_team_id: data[0].id.toString(), teamName: data[0].name });
                }

                self.setState({ teams: data, error: "" });   
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
                {error !== "" &&
                    <Alert id="error-alert" variant="danger"> {error} </Alert>
                }
            </div>
        );
    }

    onButtonClick(team) {
        this.setState({ org_team_id: team.id.toString(), teamName: team.name}, () => {
            this.forceUpdate();
        })
        
    }

    render() {
        const teams = this.state.teams;

        if (teams == undefined) return "Loading...";
        else if (teams.length == 0) return "No teams found. Try running a job?"

        const org_team_id = this.state.org_team_id;

        if (org_team_id == undefined) return "Loading...";

        return (
            <div>
                {this.renderError()}
                <Panel>
                    <Panel.Heading>
                            <Panel.Title>{this.state.teamName}
                                <div style={{ display: "flex", alignItems: "center", justifyContent: "flex-end", padding: "0px", margin: "0px" }}>
                                    Select Team: <ButtonToolbar>
                                        <DropdownButton title={this.state.teamName} id="dropdown-size-medium">
                                            {teams.map((object, index) => {
                                                return(<MenuItem key={object["name"]} onClick={() => this.onButtonClick(object)}>{object["name"]}</MenuItem>);
                                            })}
                                        </DropdownButton>
                                    </ButtonToolbar>
                                </div>
                            </Panel.Title>
                    </Panel.Heading>
                    <Panel.Body>
                        <CourseOrgTeam
                            org_team_id={org_team_id}
                            course_id={this.props.course_id.toString()}
                        />
                    </Panel.Body>
                </Panel>
            </div>
        );
    }
}

CourseOrgTeamsIndex.propTypes = {
    search: PropTypes.string,
    type: PropTypes.string,
    course_id: PropTypes.number.isRequired,
    course: PropTypes.object.isRequired
};

export default CourseOrgTeamsIndex;
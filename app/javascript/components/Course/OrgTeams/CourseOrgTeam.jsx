import React, { Component, Fragment } from 'react';
import {Panel, ButtonToolbar, DropdownButton, MenuItem} from "react-bootstrap";
import * as PropTypes from 'prop-types';
import CourseOrgTeamsTable from "./CourseOrgTeamsTable";
import CourseOrgTeamMemberList from "./CourseOrgTeamMemberList";
import CourseGithubReposTable from "../GithubRepos/CourseGithubReposTable";

import OrgTeamsService from "../../../services/org-teams-service";
import CourseOrgTeamRepoList from './CourseOrgTeamRepoList';
import CommitsAnalytics from '../Analytics/CommitsAnalytics';
import ChangeAnalytics from '../Analytics/ChangeAnalytics';


class CourseOrgTeam extends Component {

    constructor(props) {
        super(props);
        this.state = {team: undefined, projRepos: undefined, projRepo: undefined, projRepoName: undefined, projRepoId: undefined, page: 1, pageSize: 25, totalSize: 0};
    }

    componentDidMount() {
        this.fetchTeam();
    }

    paginationHandler = (page, pageSize) => {
        this.setState({page: page, pageSize: pageSize}, () => {
            this.updateRepos();
        });
    }

    componentDidUpdate(prevProps, prevState) {
        if (prevProps.org_team_id != this.props.org_team_id) {
            this.setState({projRepo: undefined, projRepoId: undefined, projRepoName: undefined})
            this.fetchTeam();
        }

        if (prevState.team != this.state.team) {
            this.getProjectRepos(this.state.team)
        }
    }

    fetchTeam = () => {
        OrgTeamsService.getOrgTeam(this.props.course_id, this.props.org_team_id).then(
            (team) => {
                this.setState({team: team})
            }
        ).then(() => {
            if (this.state.team.org_team.project_repo_id != null) {
                const response = fetch(`/api/courses/${this.props.course_id}/github_repos/${this.state.team.org_team.project_repo_id}`).then(response => response.json()).then(json => {
                    const projRepo = [];
                    projRepo.push(json);
                    this.setState({projRepoName: json["name"], projRepoId: json["id"].toString(), projRepo: projRepo })
                })
            }
        })
    }

    getProjectRepos = (team) => {
        const response = fetch(`/api/courses/${team.org_team.course_id}/github_repos?is_project_repo=true`).then(response => response.json()).then(json => {
            if (json.length > 0) {
                this.setState({projRepos: json})
            } else if (json.length == 0) {
                this.setState({projRepos: []})
            }
        });
    }

    onButtonClickGetRepo(repo) {
        this.state.team.org_team.project_repo_id = repo["id"].toString()
        const params = this.state.team
        Rails.ajax({
            url: `/api/courses/${this.props.course_id}/org_teams/${this.props.org_team_id}`,
            type: 'put',
            data: $.param(params),
        })

        const projRepo = [];
        projRepo.push(repo);
        this.setState({ projRepoName: repo["name"], projRepoId: repo["id"].toString(), projRepo: projRepo });
    }

    render() {
        const team = this.state.team;

        if (team == null) return "Loading...";

        const projRepos = this.state.projRepos;

        if (projRepos == null) return "Loading...";
        else if (projRepos.length == 0) return "No project repos found. Try running a job?"

        console.log("projRepo", this.state.projRepo)
        return (
            <Fragment>
                <CourseOrgTeamsTable
                    teams={[team.org_team]}
                    page={1}
                    pageSize={1}
                    totalSize={1}
                    {...this.props}
                />
                <div style={{ display: "flex", alignItems: "center", justifyContent: "flex-start" }}>
                    Select Repo: <ButtonToolbar>
                        <DropdownButton title={typeof this.state.projRepoName !== 'undefined' ? this.state.projRepoName : "Assign Repo" } id="dropdown-size-medium">
                            {this.state.projRepos.map((object, index) => {
                                return(<MenuItem key={object["name"]} onClick={() => this.onButtonClickGetRepo(object)}>{object["name"]}</MenuItem>);
                            })}
                        </DropdownButton>
                    </ButtonToolbar>
                </div>
                {typeof this.state.projRepo !== "undefined" ? <CourseGithubReposTable
                        repos={this.state.projRepo}
                        {...this.props}
                    /> : ""}
                
                <CourseOrgTeamMemberList 
                    team={team}
                    {...this.props}
                />
                <CourseOrgTeamRepoList
                    team={team}
                    {...this.props}
                />
                <Panel>
                    <Panel.Heading>
                            <Panel.Title>Commit Analytics</Panel.Title>
                    </Panel.Heading>
                    <Panel.Body>
                        <div align="center">
                            <CommitsAnalytics
                                team={team}
                                project_repo_id={this.state.projRepoId}
                                {...this.props}
                            />
                        </div>
                    </Panel.Body>
                </Panel>
                <Panel>
                    <Panel.Heading>
                            <Panel.Title>LOC Changed</Panel.Title>
                    </Panel.Heading>
                    <Panel.Body>
                        <div align="center">
                            <ChangeAnalytics
                                team={team}
                                project_repo_id={this.state.projRepoId}
                                {...this.props}
                            />
                        </div>
                    </Panel.Body>
                </Panel>
            </Fragment>
        );
    }
}

CourseOrgTeam.propTypes = {
    org_team_id: PropTypes.string.isRequired,
    course_id: PropTypes.string.isRequired
};

export default CourseOrgTeam;

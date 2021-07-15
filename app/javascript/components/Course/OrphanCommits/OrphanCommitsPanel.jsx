import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'

import isEqual from 'lodash.isequal';


export default class OrphanCommitsPanel extends Component {
    constructor(props) {
        super(props);
        this.state = {
            repos: null,
        }
    }


    courseId = () => this.props.course.id;
    orgName = () => this.props.course.course_organization;
    repoName = (repo) => repo.name;

    componentDidUpdate(prevProps,prevState) {
        if (!isEqual(this.props.repos,this.state.repos)) {
            this.setState({repos: this.props.repos});
            this.updateOrphanCommits();
        }
    }

    updateOrphanCommits = () => {
        
    }

    render() {
        return (
            <>
                 <Panel id="collapsible-panel-team-statistics" defaultExpanded >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Orphan Commits
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <p>YES!!! Orphan Commits UI goes Here</p>
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
            </>
        );
    }
}

OrphanCommitsPanel.propTypes = {
    course_id : PropTypes.number.isRequired,
    course: PropTypes.object.isRequired,
    databaseId_to_student: PropTypes.object.isRequired,
    databaseId_to_team: PropTypes.object.isRequired,
    org_teams: PropTypes.array.isRequired
};


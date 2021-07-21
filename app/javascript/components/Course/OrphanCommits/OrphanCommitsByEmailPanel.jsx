import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'
import OrphanCommitsByEmailTable from './OrphanCommitsByEmailTable';
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';
import RepoCommitEventsTable from '../../RepoCommitEvents/RepoCommitEventsTable';

export default class OrphanCommitsByEmailPanel extends Component {
    constructor(props) {
        super(props);
    }

    componentDidUpdate(prevProps,prevState) {
      
    }

    render() {
        console.log("this.props=",this.props);
        const author_emails = this.props.orphanCommits.orphan_author_emails;
        return (
            <>
                 <Panel id="collapsible-panel-orphan-commits" defaultExpanded >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Orphan Commits By Email
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <OrphanCommitsByEmailTable 
                                emails={author_emails} 
                                course_id={this.props.course_id} />
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>        
            </>
        );
    }
}

OrphanCommitsByEmailPanel.propTypes = {
   
};


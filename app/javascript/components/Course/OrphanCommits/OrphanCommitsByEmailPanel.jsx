import React, { Component } from 'react';
import { Panel } from 'react-bootstrap'
import OrphanCommitsByEmailTable from './OrphanCommitsByEmailTable';

export default class OrphanCommitsByEmailPanel extends Component {
    constructor(props) {
        super(props);
    }

    render() {
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



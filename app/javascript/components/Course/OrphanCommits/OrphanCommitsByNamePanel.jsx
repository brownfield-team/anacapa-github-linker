import React, { Component } from 'react';
import { Panel } from 'react-bootstrap'
import OrphanCommitsByNameTable from './OrphanCommitsByNameTable';

export default class OrphanCommitsByNamePanel extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        const author_names = this.props.orphanCommits.orphan_author_names;
        return (
            <>
                 <Panel id="collapsible-panel-orphan-commits" defaultExpanded >
                    <Panel.Heading>
                        <Panel.Title toggle>
                            Orphan Commits By Name
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <OrphanCommitsByNameTable 
                                names={author_names} 
                                course_id={this.props.course_id} />
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>        
            </>
        );
    }
}



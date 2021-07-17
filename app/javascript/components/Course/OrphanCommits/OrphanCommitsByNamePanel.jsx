import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'
import OrphanCommitsByNameTable from './OrphanCommitsByNameTable';
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';

export default class OrphanCommitsByNamePanel extends Component {
    constructor(props) {
        super(props);
    }

    componentDidUpdate(prevProps,prevState) {
      
    }

    render() {
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
                           <OrphanCommitsByNameTable names={[{name: "name1", count: 5},{name: "name2", count:3 }]} />
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <JSONPrettyPanel 
                  expression={"this.props.orphanCommits"}
                  value={this.props.orphanCommits}
                 />
            </>
        );
    }
}

OrphanCommitsByNamePanel.propTypes = {
   
};


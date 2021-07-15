import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'


export default class OrphanCommitsPanel extends Component {
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
                            Orphan Commits
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <p>Orphan Commits UI will go Here</p>
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
            </>
        );
    }
}

OrphanCommitsPanel.propTypes = {
   
};


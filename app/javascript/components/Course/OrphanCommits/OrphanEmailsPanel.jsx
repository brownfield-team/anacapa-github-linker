import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'
import OrphanEmailsTable from './OrphanEmailsTable';

export default class OrphanEmailsPanel extends Component {
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
                            Orphan Email Mappings
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <OrphanEmailsTable emails={this.props.emails} />
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
            </>
        );
    }
}

OrphanEmailsPanel.propTypes = {
   
};


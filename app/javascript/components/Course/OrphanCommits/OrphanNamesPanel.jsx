import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'
import OrphanNamesTable from './OrphanNamesTable';
import JSONPrettyPanel from '../../Utilities/JsonPrettyPanel';

export default class OrphanNamesPanel extends Component {
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
                            Orphan Name Mappings
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <OrphanNamesTable names={this.props.names} />
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
                <JSONPrettyPanel 
                  expression={"this.props"}
                  value={this.props}
                 />
            </>
        );
    }
}

OrphanNamesPanel.propTypes = {
   
};


import React, { Component, Fragment } from 'react';
import PropTypes from 'prop-types';
import { Panel } from 'react-bootstrap'
import JSONPretty from 'react-json-pretty';


export default class JSONPrettyPanel extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <Fragment>
                <Panel id={`JSONPrettyPanel-${this.props.expression}`}>
                    <Panel.Heading>
                        <Panel.Title toggle>
                           <code>{this.props.expression}</code>
                        </Panel.Title>
                    </Panel.Heading>
                    <Panel.Collapse>
                        <Panel.Body>
                           <JSONPretty data={this.props.value} />
                        </Panel.Body>
                    </Panel.Collapse>
                </Panel>
            </Fragment>
        );
    }
}

JSONPrettyPanel.propTypes = {
    expression : PropTypes.string.isRequired,
};


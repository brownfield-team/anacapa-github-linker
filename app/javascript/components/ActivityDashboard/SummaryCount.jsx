import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Col, Panel} from "react-bootstrap";

class SummaryCount extends Component {
    render() {
        return (
            <Fragment>
                <Col style={{paddingLeft: 10, paddingRight: 10}} md={2}>
                    <Panel>
                        <Panel.Heading>
                            <Panel.Title>{this.props.name}</Panel.Title>
                        </Panel.Heading>
                        <Panel.Body>
                            <h3>{this.props.count}</h3>
                        </Panel.Body>
                    </Panel>
                </Col>
            </Fragment>
        );
    }
}

SummaryCount.propTypes = {
    name: PropTypes.string.isRequired,
    count: PropTypes.number.isRequired
};

export default SummaryCount;
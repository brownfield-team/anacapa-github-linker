import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';
import {Col, ControlLabel, Grid, Row} from "react-bootstrap";

class ShowProjectTeamField extends Component {
    render() {
        const fieldValue = this.props.url ? <a href={this.props.url}>{this.props.fieldValue}</a> : <span>{this.props.fieldValue}</span>;
        return (
            <Fragment>
                <Row>
                    <Col componentClass={ControlLabel} sm={2}>
                        {this.props.fieldName}
                    </Col>
                    <Col sm={8}>
                        {fieldValue}
                    </Col>
                </Row>
            </Fragment>
        );
    }
}

ShowProjectTeamField.propTypes = {
    fieldName: PropTypes.string.isRequired,
    fieldValue: PropTypes.string.isRequired,
    url: PropTypes.string
};

export default ShowProjectTeamField;
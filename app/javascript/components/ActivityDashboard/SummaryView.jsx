import React, {Component, Fragment} from 'react';
import * as PropTypes from 'prop-types';

class SummaryView extends Component {
    render() {
        return (
            <Fragment>

            </Fragment>
        );
    }
}

SummaryView.propTypes = {
    commits: PropTypes.array.isRequired
};

export default SummaryView;
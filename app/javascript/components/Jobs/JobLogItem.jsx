import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';

class JobLogItem extends Component {
    render() {
        const cj = this.props.completed_job; // Save some characters
        return(
                <tr key={`completed-job-${cj.id}`}> 
                    <td>{cj.job_name}</td>
                    <td>{cj.run_at}</td>
                    <td>{cj.time_elapsed}</td>
                    <td>{cj.summary}</td>
                </tr>
            );
    }
}

JobLogItem.propTypes = {
    completed_job: PropTypes.object.isRequired
};

export default JobLogItem;
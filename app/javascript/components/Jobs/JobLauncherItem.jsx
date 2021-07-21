import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';

class JobLauncherItem extends Component {
    render() {
        console.log("JobLauncherItem, this.props=",this.props)

        const j = this.props.job; // Save some characters

        var confirmationDialogProps = {}
        if (j.confirmation_dialog) {
            confirmationDialogProps = {
                "data-confirm": j.confirmation_dialog
            };
        }
        const href = `${this.props.run_url_prefix}?job_name=${j.job_short_name}${this.props.redirect_url ? ("&redirect_url=" + this.props.redirect_url) : ""}`
        console.log("href=",href);
        return (
            <tr>
                <td><span className="job_name" data-toggle="tooltip" title={`${j.job_description}`} >{j.job_name}</span></td>
                <td>{j.last_run}</td>
                <td>
                    <a
                        {...confirmationDialogProps}
                        rel="nofollow"
                        data-method="post"
                        href={href}>
                        Run Job
                    </a>
                </td>
            </tr >
        );  
    }
}

JobLauncherItem.propTypes = {
    job: PropTypes.object.isRequired
};

export default JobLauncherItem;
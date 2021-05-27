import React, {Component} from 'react';
import PropTypes from 'prop-types';
import ExternalRepoRow from "./ExternalRepoRow";
import {Button, ControlLabel, FormControl, FormGroup} from "react-bootstrap";
import ReposService from "../../../../services/repos-service";

class ExternalRepoForm extends Component {
    constructor(props) {
        super(props)
        this.state = {
            repoName: "",
            repoOrganization: "",
        }
    }

    isInputValid = () => {
        const {repoName, repoOrganization} = this.state;
        return repoName.length > 0 && repoOrganization.length > 0;
    }

    onRepoSubmitted = () => {
        const {repoName, repoOrganization} = this.state;
        const repoObject = {name: repoName, organization: repoOrganization};
        ReposService.createGithubRepo(this.props.courseId, repoObject).then(_ => {
            this.props.onRepoCreated();
            this.setState({repoName: "", repoOrganization: ""});
        });
    }

    render() {
        return (
            <div>
                <div className="panel panel-default">
                    <div className="panel-heading">
                        <div className="panel-title">Add External Repository</div>
                    </div>
                    <div className="panel panel-body">
                        <FormGroup>
                            <ControlLabel>Organization</ControlLabel>
                            <FormControl
                                type="text"
                                value={this.state.repoOrganization}
                                placeholder="Enter repo organization or owner"
                                onChange={e => this.setState({repoOrganization: e.target.value})}
                            />
                            <br/>
                            <ControlLabel>Name</ControlLabel>
                            <FormControl
                                type="text"
                                value={this.state.repoName}
                                placeholder="Enter repo name"
                                onChange={e => this.setState({repoName: e.target.value})}
                            />
                            <br/>
                            <Button disabled={!this.isInputValid()} onClick={this.onRepoSubmitted} type="submit">Submit</Button>
                        </FormGroup>
                    </div>
                </div>
            </div>
        );
    }
}

ExternalRepoForm.propTypes = {
    courseId: PropTypes.number.isRequired,
    onRepoCreated: PropTypes.func.isRequired,
};

export default ExternalRepoForm;

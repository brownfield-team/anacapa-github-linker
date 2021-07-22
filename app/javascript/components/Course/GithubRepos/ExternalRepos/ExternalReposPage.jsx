import React, {Component} from 'react';
import PropTypes from 'prop-types';
import ReposService from "../../../../services/repos-service";
import ExternalRepoForm from "./ExternalRepoForm";
import ExternalReposTable from "./ExternalReposTable";
import ReactOnRails from "react-on-rails";
import axios from "axios";

class ExternalReposPage extends Component {
    constructor(props) {
        super(props);
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
        this.state = {
            repos: [],
        };
    }

    componentDidMount() {
        this.fetchExternalRepos();
    }

    onRepoCreated = () => {
        this.fetchExternalRepos();
    }

    fetchExternalRepos = () => {
        ReposService.getExternalRepos(this.props.course_id).then(repos => this.setState({repos: repos}));
    }

    deleteExternalRepo = (repo) => {
        axios.delete(repo.api_path).then(_ => this.fetchExternalRepos());
    }

    render() {
        return (
            <div>
                <ExternalRepoForm onRepoCreated={this.onRepoCreated} courseId={this.props.course_id}/>
                <ExternalReposTable repos={this.state.repos} onRepoDelete={this.deleteExternalRepo}/>
            </div>
        );
    }
}

ExternalReposPage.propTypes = {
    course_id: PropTypes.number.isRequired,
};

export default ExternalReposPage;

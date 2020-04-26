import React, {Component} from 'react';
import PropTypes from 'prop-types';
import { Alert, Form } from 'react-bootstrap';
import UsersTable from './UsersTable';
import {debounce} from "debounce";
import UsersSearch from "./UsersSearch";

class Users extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "", type: this.props.type ?? "", error: "", users: [], page: 1, per_page: 25, totalSize: 0 };
        this.onSearchChanged = debounce(this.onSearchChanged, 500);
        // this.onTypeChanged = debounce(this.onTypeChanged, 500);
    }

    componentDidMount() {
        this.updateUsers();
    }

    onSearchChanged = (searchValue) => {
        if (searchValue === this.props.search) {
            return;
        }
        this.setState({search: searchValue}, () => {
            this.updateUsers();
        });
    }

    onTypeChanged = (typeValue) => {
        if (typeValue === this.props.type) {
            return;
        }
        this.setState({type: typeValue}, () => {
           this.updateUsers();
        });
    }

    paginationHandler = (page, per_page) => {
        this.setState({page: page, per_page: per_page}, () => {
            this.updateUsers();
        });
    }

    updateUsers = () => {
        const params = {search: this.state.search, type: this.state.type, page: this.state.page, per_page: this.state.per_page};
        // Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: "/users.json",
            type: "get",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data, status, xhr) {
                const totalRecords = parseInt(xhr.getResponseHeader("X-Total"));
                const page = parseInt(xhr.getResponseHeader("X-Page"));
                self.setState({ users: data, totalSize: totalRecords, page: page, error: "" }, () => {
                    console.log("State updated");
                });
            },
            error: function (data) {
                self.setState({ error: data });
            }
        });
    }

    renderError() { // Or don't
        const error = this.state.error;
        return (
            <div>
            { error === "" &&
                <Alert id="error-alert" variant="danger"> {error} </Alert>
            }
            </div>
        );
    }

    render() {
        return (
            <div>
                <h1>Users</h1>
                { this.renderError() }
                <UsersSearch
                    onSearchChanged={this.onSearchChanged}
                    onTypeChanged={this.onTypeChanged}
                />
                <br />
                <UsersTable
                    users={this.state.users}
                    page={this.state.page}
                    per_page={this.state.per_page}
                    totalSize={this.state.totalSize}
                    paginationHandler={this.paginationHandler}
                />
            </div>
        );
    }
}

Users.propTypes = {
    search: PropTypes.string,
    type: PropTypes.string
};

export default Users;

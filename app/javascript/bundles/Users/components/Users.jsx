import React, {Component} from 'react';
import PropTypes, {func} from 'prop-types';
import { Alert, Form } from 'react-bootstrap';
import UsersTable from './UsersTable';
import {debounce} from "debounce";
import UsersSearch from "./UsersSearch";

class Users extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "", type: this.props.type ?? "", error: "", users: [], page: 1, pageSize: 25, totalSize: 0 };
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

    paginationHandler = (page, pageSize) => {
        this.setState({page: page, pageSize: pageSize}, () => {
            this.updateUsers();
        });
    }

    onUserRoleChange = (user) => {
        const params = {role: user.role}
        const self = this;
        Rails.ajax({
            url: "/users/" + user.id + ".json",
            type: "put",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data) {},
            error: function (data) {
                self.setState({error: data});
            }
        });
    }

    updateUsers = () => {
        const params = {search: this.state.search, type: this.state.type, page: this.state.page, per_page: this.state.pageSize};
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
                self.setState({ users: data, totalSize: totalRecords, page: page, error: "" });
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
                { this.renderError() }
                <h1>Users</h1>
                <UsersSearch
                    onSearchChanged={this.onSearchChanged}
                    onTypeChanged={this.onTypeChanged}
                />
                <br />
                <UsersTable
                    users={this.state.users}
                    page={this.state.page}
                    pageSize={this.state.pageSize}
                    totalSize={this.state.totalSize}
                    paginationHandler={this.paginationHandler}
                    onUserRoleChange={this.onUserRoleChange}
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

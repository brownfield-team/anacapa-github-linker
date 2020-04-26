import React, {Component} from 'react';
import PropTypes from 'prop-types';
import Alert from 'react-bootstrap/Alert';
import UsersTable from './UsersTable';

class Users extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "", type: this.props.type ?? "", error: "", users: [] };
    }

    componentDidMount() {
        this.updateUsers(this.state.search, this.state.type);
    }

    updateUsers(search, type) {
        const params = {search: search, type: type};
        // Otherwise, calling setState fails because the scope for "this" is the success/error function.
        const self = this;
        Rails.ajax({
            url: "/users.json",
            type: "get",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data) {
                self.setState({ users: data, error: "" });
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
                <Alert id="error-alert" variant="danger">
                    {error}
                </Alert>
            }
            </div>
        );
    }

    render() {
        return (
            <div>
                { this.renderError() }
                <UsersTable users={this.state.users} />
            </div>
        );
    }
}

Users.propTypes = {
    search: PropTypes.string,
    type: PropTypes.string
};

export default Users;

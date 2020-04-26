import React, {Component} from 'react';
import PropTypes from 'prop-types';

class Users extends Component {
    constructor(props) {
        super(props);
        this.state = { search: this.props.search ?? "", type: this.props.type ?? "" }
        this.setState( users:  )
    }

    getUsers(search, type) {
        var params = {search: "", type: ""};
        Rails.ajax({
            url: "/users.json",
            type: "get",
            data: $.param(params),
            beforeSend: function() {
                return true;
            },
            success: function (data) {
                this.setState({ users: data });
            },
            error: function (data) {
                console.log(data);
            }
        });
    }

    render() {
        return (
            <div>

            </div>
        );
    }
}

Users.propTypes = {
    search: PropTypes.string,
    type: PropTypes.string
};

export default Users;

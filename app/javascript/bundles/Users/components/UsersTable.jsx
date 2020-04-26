import React, {Component} from 'react';
import PropTypes from 'prop-types';
import BootstrapTable from 'react-bootstrap-table-next';

class UsersTable extends Component {
    constructor(props) {
        super(props);
        this.columns = [{
            dataField: 'name',
            text: 'Name',
            sort: true
        }, {
            dataField: 'username',
            text: 'Username',
            sort: true
        }, {
            dataField: 'uid',
            text: 'UID',
            sort: true
        }];
    }

    render() {
        return (
            <div>
                <BootstrapTable columns={this.columns} data={this.props.users} keyField="uid" />
            </div>
        );
    }
}

UsersTable.propTypes = {
    users: PropTypes.array.isRequired
};

export default UsersTable;

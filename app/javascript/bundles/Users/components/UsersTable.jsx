import React, {Fragment, Component} from 'react';
import PropTypes from 'prop-types';
import BootstrapTable from 'react-bootstrap-table-next';
import paginationFactory from 'react-bootstrap-table2-paginator';

class UsersTable extends Component {
    constructor(props) {
        super(props);
    }

    columns =
        [{
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

    render() {
        return (
            <Fragment>
                <BootstrapTable
                    columns={this.columns}
                    data={this.props.users}
                    keyField="uid"
                    pagination={ paginationFactory() }
                    remote={ { pagination: true, filter: false, sort: false } }
                />
            </Fragment>
        );
    }
}

UsersTable.propTypes = {
    users: PropTypes.array.isRequired
};

export default UsersTable;

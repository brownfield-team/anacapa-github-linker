import React, {Fragment, Component} from 'react';
import PropTypes from 'prop-types';
import BootstrapTable from 'react-bootstrap-table-next';
import paginationFactory from 'react-bootstrap-table2-paginator';
import cellEditFactory, { Type } from 'react-bootstrap-table2-editor';

class UsersTable extends Component {
    constructor(props) {
        super(props);
    }

    columns =
        [{
            dataField: 'name',
            text: 'Name',
        }, {
            dataField: 'username',
            text: 'Username',
        }, {
            dataField: 'uid',
            text: 'UID',
        }, {
            dataField: 'role',
            text: 'Role',
            editor: {
                type: Type.SELECT,
                options: [{
                    value: 'user',
                    label: 'User'
                }, {
                    value: 'instructor',
                    label: 'Instructor'
                }, {
                    value: 'admin',
                    label: 'Admin'
                }]
            }
        }];

    onTableChange = (type, newState) => {
        if (type !== "pagination") {
            return;
        }
        this.props.paginationHandler(newState.page, newState.sizePerPage);
    }

    paginationOptions = () => {
        return paginationFactory({
            totalSize: this.props.totalSize,
            page: this.props.page,
            sizePerPage: this.props.pageSize
        })
    }

    render() {
        return (
            <Fragment>
                <BootstrapTable
                    columns={this.columns}
                    data={this.props.users}
                    keyField="uid"
                    remote={ { pagination: true, filter: false, sort: false } }
                    pagination={ this.paginationOptions() }
                    onTableChange={ this.onTableChange }
                />
            </Fragment>
        );
    }
}

UsersTable.propTypes = {
    users: PropTypes.array.isRequired,
    paginationHandler: PropTypes.func.isRequired,
    page: PropTypes.number.isRequired,
    pageSize: PropTypes.number.isRequired,
    totalSize: PropTypes.number.isRequired
};

export default UsersTable;

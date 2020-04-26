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
            editable: false
        }, {
            dataField: 'username',
            text: 'Username',
            editable: false
        }, {
            dataField: 'uid',
            text: 'UID',
            editable: false
        }, {
            dataField: 'role',
            text: 'Role',
            editor: {
                type: Type.SELECT,
                options: [{
                    value: 'User',
                    label: 'User'
                }, {
                    value: 'Instructor',
                    label: 'Instructor'
                }, {
                    value: 'Admin',
                    label: 'Admin'
                }]
            }
        }];

    onTableChange = (type, newState) => {
        if (type !== "pagination") {
            // For now, sort and filter are disabled.
            return;
        }
        this.props.paginationHandler(newState.page, newState.sizePerPage);
    }

    paginationOptions = () => {
        return paginationFactory({
            totalSize: this.props.totalSize,
            page: this.props.page,
            sizePerPage: this.props.pageSize
        });
    }

    cellEditOptions = () => {
        return cellEditFactory({
            mode: 'click',
            blurToSave: true,
            beforeSaveCell: this.confirmRoleChange,
            afterSaveCell: (oldValue, newValue, row, column) => {
                this.props.onUserRoleChange(row);
            }
        });
    }

    confirmRoleChange(oldValue, newValue, row, column, done) {
        setTimeout(() => {
            if (oldValue !== newValue && confirm("Are you sure you want to change this user's role?")) {
                done(true);
            } else {
                done(false);
            }
        }, 0);
        return { async: true };
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
                    cellEdit={ this.cellEditOptions() }
                />
            </Fragment>
        );
    }
}

UsersTable.propTypes = {
    users: PropTypes.array.isRequired,
    paginationHandler: PropTypes.func.isRequired,
    onUserRoleChange: PropTypes.func.isRequired,
    page: PropTypes.number.isRequired,
    pageSize: PropTypes.number.isRequired,
    totalSize: PropTypes.number.isRequired
};

export default UsersTable;

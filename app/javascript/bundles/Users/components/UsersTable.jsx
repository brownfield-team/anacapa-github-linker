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
        }, {
            dataField: 'username',
            text: 'Username',
        }, {
            dataField: 'uid',
            text: 'UID',
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
            sizePerPage: this.props.per_page
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
    per_page: PropTypes.number.isRequired,
    totalSize: PropTypes.number.isRequired
};

export default UsersTable;

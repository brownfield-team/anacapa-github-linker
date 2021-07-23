import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';

import PropTypes from 'prop-types';
import paginationFactory from 'react-bootstrap-table2-paginator';

class RepoCommitEventsTable extends Component {

    constructor(props) {
        super(props);
    }

    columns =
        [{
            dataField: 'id',
            text: 'id',
        },
        {
            dataField: 'commit_hash',
            text: 'SHA',
            formatter: (cell, row) => this.formatCommitHash(cell, row)
        },{
            dataField: 'author_login',
            text: 'author_login',
        }, {
            dataField: 'author_name',
            text: 'author_name',
        },{
            dataField: 'author_email',
            text: 'author_email',
        },{
            dataField: 'commit_timestamp',
            text: 'timestamp',
        },  {
            dataField: 'github_repo.name',
            text: 'repo',
            formatter: (cell, row) => <a href={row.github_repo.url}>{cell}</a>

        }];

   formatCommitHash = (cell, row) => {
    return (
        <a href={row.url}>{cell.substr(0,8)}</a>
    );
   }

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

    render() {
        return (
            <Fragment>
                <h2>Repo Commit Events</h2>
                <BootstrapTable
                    columns={this.columns}
                    data={this.props.commits}
                    keyField="id"
                    remote={ { pagination: true, filter: false, sort: false } }
                    pagination={
                        this.props.paginationHandler ?
                        this.paginationOptions()  :
                        undefined
                    }
                    onTableChange={ this.onTableChange }
                    hidePageListOnlyOnePage={true}
                />
            </Fragment>
        );
    }
}

RepoCommitEventsTable.propTypes = {
    commits: PropTypes.array.isRequired,
    paginationHandler: PropTypes.func,
    page: PropTypes.number.isRequired,
    pageSize: PropTypes.number.isRequired,
    totalSize: PropTypes.number.isRequired,
};

export default RepoCommitEventsTable;

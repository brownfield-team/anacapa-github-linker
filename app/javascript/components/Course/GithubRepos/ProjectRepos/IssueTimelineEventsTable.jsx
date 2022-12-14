import React, { Component, Fragment } from 'react';
import BootstrapTable from 'react-bootstrap-table-next';

import PropTypes from 'prop-types';
import paginationFactory from 'react-bootstrap-table2-paginator';

class IssueTimelineEventsTable extends Component {

    constructor(props) {
        super(props);
    }

    columns =
        [
            {
                dataField: 'org',
                text: 'Org',
                editable: false,
            },
            {
                dataField: 'team',
                text: 'Team',
                editable: false,
            },
            {
                dataField: 'repo',
                text: 'Repo',
                editable: false,
            }
        ];

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
                <BootstrapTable
                    columns={this.columns}
                    data={this.props.events}
                    keyField="id"
                    remote={{ pagination: true, filter: false, sort: false }}
                    pagination={
                        this.props.paginationHandler ?
                            this.paginationOptions() :
                            undefined
                    }
                    onTableChange={this.onTableChange}
                    hidePageListOnlyOnePage={true}
                />
            </Fragment>
        );
    }
}

IssueTimelineEventsTable.propTypes = {
    events: PropTypes.array.isRequired,
    paginationHandler: PropTypes.func,
    page: PropTypes.number,
    pageSize: PropTypes.number,
    totalSize: PropTypes.number,
    course: PropTypes.object
};

export default IssueTimelineEventsTable;

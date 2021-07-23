import React, { Component, Fragment } from 'react';
import axios from "axios";
import { coursesRoute } from "../../services/service-routes";
import ReactOnRails from "react-on-rails";
import BootstrapTable from 'react-bootstrap-table-next';
import { Button, Alert } from "react-bootstrap";
import { Redirect } from 'react-router';
import * as PropTypes from 'prop-types';


class RosterStudentsTable extends Component {
	constructor(props) {
		super(props);
		this.state = {
			csrfToken: ""
		};
	}

	componentDidMount() {
		const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");
		this.setState({
			csrfToken: csrf
		});
	}

	columns = [
		{
			dataField: "Assign",
			text: "Assign",
			isDummyField: true,
			formatter: (cell, row) => this.renderAssignButton(cell, row),
			hidden: false /* use "true" if/when this is reused for basic roster student list */
		},
		{
			dataField: 'first_name',
			text: 'First Name',
			sort: true
		}, {
			dataField: 'last_name',
			text: 'Last Name',
			sort: true
		}, {
			dataField: 'email',
			text: 'Email',
			sort: true
		}, {
			dataField: 'section',
			text: 'Section',
			sort: true
		},
	];


	renderAssignButton = (cell, row) => {
		const url = this.props.assign_url( this.props.params.course_id, this.props.params[this.props.field], row.id);
		console.log("url", url)
		return (
			<form method="post" action={url}>
				<input
					type="hidden"
					name="authenticity_token"
					value={this.state.csrfToken}
				></input>
				<Button type="submit"
					className="btn btn-danger"
					variant="danger"
					data-testid={`assign-button-${row.id}`}
				>
					Assign
				</Button>
			</form>
		)
	}

	render() {
		return (
			<>
				{this.state.alert}
				<BootstrapTable
					boostrap4={true}
					columns={this.columns}
					data={this.props.rosterStudents}
					keyField="id"
					defaultSorted = {[{ dataField: "last_name", order: "asc"}]}

				/>
			</>
		);
	}
}

RosterStudentsTable.propTypes = {
	assign_url: PropTypes.func.isRequired,
	field: PropTypes.string.isRequired
};

export default RosterStudentsTable;

import React, { Component, Fragment } from 'react';
import axios from "axios";
import { coursesRoute } from "../../services/service-routes";
import ReactOnRails from "react-on-rails";
import BootstrapTable from 'react-bootstrap-table-next';
import { Button } from "react-bootstrap";

class CoursesIndex extends Component {
	constructor(props) {
		super(props);
		this.state = { courses: [] };
		const csrfToken = ReactOnRails.authenticityToken();
		axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
		axios.defaults.params = {}
		axios.defaults.params['authenticity_token'] = csrfToken;
	}


	 schoolDisplay = () => this.props.course.school ? this.props.course.school.abbreviation : ""; 

	 renderCourseUrl = (cell, row) => <a href={row.path}>{cell}</a>;

	 renderCourseOrgLink = (cell, row) => {
		const url = `https://github.com/${cell}`;
		return (
			<a href={url}>{cell}</a>
		)
	};

	 renderEditButton = (cell, row) => {
		return (
			<Button className="btn btn-warning" variant="warning" data-testid={`edit-button-${row.id}`} href={`${row.edit_path}`} >Edit</Button>
		)
	}

	 renderDeleteButton = (cell, row) => {
		return (
			<Button className="btn btn-danger" variant="danger" data-testid={`delete-button-${row.id}`} onClick={() => {if(window.confirm(`Delete course ${row.name}?`)) {this.deleteCourse(row)}}} >Delete</Button>
		)
	}

	 columns = [
		{
			dataField: 'school.abbreviation',
			text: 'School',
			sort: true
		}, {
			dataField: 'name',
			text: 'Name',
			sort: true,
			formatter: (cell, row) => this.renderCourseUrl(cell, row)
		}, {
			dataField: 'term',
			text: 'Term',
			sort: true
		}, {
			dataField: 'hidden',
			text: 'Hidden',
			sort: true
		}, {
			dataField: 'course_organization',
			text: 'Course Organization',
			sort: true,
			formatter: (cell, row) => this.renderCourseOrgLink(cell, row)
		}, {
			dataField: "edit",
			text: "Edit",
			isDummyField: true,
			formatter: (cell, row) => this.renderEditButton(cell, row),
			hidden: false /* should be true if this is not an instructor / admin */
		}, {
			dataField: "delete",
			text: "Delete",
			isDummyField: true,
			formatter: (cell, row) => this.renderDeleteButton(cell, row),
			hidden: false /* should be true if this is not an instructor / admin */
		}
	];


	componentDidMount() {
		this.getCourses();
	}

	getCourses = () => {
		axios.get(coursesRoute).then(response => {
			this.setState({ courses: response.data });
		});
	}

	deleteCourse = course => {
		axios.delete(course.path).then(_ => this.getCourses());
	}

	render() {
		return (

			<BootstrapTable
				boostrap4={true}
				columns={this.columns}
				data={this.state.courses}
				keyField="id"
			/>

			// <Fragment>
			// 	<div>
			// 		<div className="panel panel-body">
			// 			<table className="bootstrap-table" data-toggle="table" data-search="true" data-pagination="true" data-show-columns="true" data-show-columns-toggle-all="true" data-show-pagination-switch="true" data-filter-control="true">
			// 				<thead>
			// 					<tr>
			// 						<th scope="col">School</th>
			// 						<th scope="col">Name</th>
			// 						<th scope="col">Term</th>
			// 						<th scope="col">Hidden</th>
			// 						<th scope="col">GitHub Organization</th>
			// 						<th scope="col" colSpan="2">Actions</th>
			// 					</tr>
			// 				</thead>
			// 				<tbody>
			// 					{this.state.courses.map(course =>
			// 						<CoursesIndexItem course={course} onDelete={this.deleteCourse} key={course.id} />
			// 					)}
			// 				</tbody>
			// 			</table>
			// 		</div>
			// 	</div>
			// </Fragment>


		);
	}
}

CoursesIndex.propTypes = {};

export default CoursesIndex;

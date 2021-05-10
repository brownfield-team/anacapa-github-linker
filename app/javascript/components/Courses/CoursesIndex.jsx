import React, { Component, Fragment } from 'react';
import CoursesIndexItem from "./CoursesIndexItem"
import * as PropTypes from 'prop-types';
import axios from "axios";
import {coursesRoute} from "../../services/service-routes";
import ReactOnRails from "react-on-rails";

class CoursesIndex extends Component {
	constructor(props) {
		super(props);
		this.state = {courses: []};
		const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
	}


	componentDidMount() {
		this.getCourses();
	}

	getCourses = () => {
		axios.get(coursesRoute).then(response => {
			this.setState({courses: response.data});
		});
	}

	deleteCourse = course => {
		axios.delete(course.path).then(_ => this.getCourses());
	}

	render() {
		return (
			<Fragment>
				<div>
					<div className="panel panel-body">
						<table className="bootstrap-table" data-toggle="table" data-search="true" data-pagination="true" data-show-columns="true" data-show-columns-toggle-all="true" data-show-pagination-switch="true" data-filter-control="true">
							<thead>
								<tr>
									<th scope="col">School</th>
									<th scope="col">Name</th>
									<th scope="col">Term</th>
									<th scope="col">Hidden</th>
									<th scope="col">GitHub Organization</th>
									<th scope="col" colSpan="2">Actions</th>
								</tr>
							</thead>
							<tbody>
								{this.state.courses.map(course =>
									<CoursesIndexItem course={course} onDelete={this.deleteCourse} key={course.id}/>
								)}
							</tbody>
						</table>
					</div>
				</div>
			</Fragment>
		);
	}
}

CoursesIndex.propTypes = {};

export default CoursesIndex;

import React, { Component } from 'react';
import * as PropTypes from 'prop-types';
import axios from "axios";

class CoursesIndexItem extends Component {
	constructor(props) {
		super(props);
		// Do I need csrf token stuff here?
	}

	hiddenText(hidden) {
		if (hidden) {
			return(<td> Hidden </td>);
		}
		else {
			return(<td> Visible </td>);
		}
	}


	render() {
		return (
			<tr>
				<td> {this.props.course.school.abbreviation} </td>
				<td><a href={this.props.course.path}>{this.props.course.name}</a></td>
				<td> {this.props.course.term} </td>
				<this.hiddenText hidden={this.props.course.hidden}/>
				<td> {this.props.course.course_organization} </td>
				<td>
					<a className='btn btn-warning btn-sm' href={this.props.course.edit_path}>Edit</a>
					<a className='btn btn-danger btn-sm' onClick={() => this.props.onDelete(this.props.course)}>Delete</a>
				</td>
			</tr>
		);
	}
}

CoursesIndexItem.propTypes = {
	course: PropTypes.object.isRequired,
	onDelete: PropTypes.func.isRequired,
};

export default CoursesIndexItem;

import React, { Component } from 'react';
import * as PropTypes from 'prop-types';
import axios from "axios";

class SchoolsIndexItem extends Component {
	constructor(props) {
		super(props);
		// Do I need csrf token stuff here?
	}


	render() {
		return (
			<tr>
				<td> {this.props.school.name} </td>
				<td> {this.props.school.abbreviation} </td>
				<td><a href={this.props.school.path}>Show</a></td>
				<td><a href={this.props.school.edit_path}>Edit</a></td>
				<td><button onClick={() => this.props.onDelete(this.props.school)}>Delete</button></td>
			</tr>
		);

	}
}

SchoolsIndexItem.propTypes = {
	school: PropTypes.object.isRequired,
	onDelete: PropTypes.func.isRequired,
};

export default SchoolsIndexItem;

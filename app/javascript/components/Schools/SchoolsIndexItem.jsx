import React, { Component } from 'react';
import * as PropTypes from 'prop-types';

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
				<td> Show </td>
				<td> Edit </td>
				<td> Destroy </td>
			</tr>
		);

	}
}

SchoolsIndexItem.propTypes = {
	school: PropTypes.object.isRequired
};

export default SchoolsIndexItem;

import React, { Component, Fragment } from 'react';
import SchoolsIndexItem from "./SchoolsIndexItem"
import * as PropTypes from 'prop-types';

class SchoolsIndex extends Component {
	constructor(props) {
		super(props);
		// Do I need csrf token stuff here?
	}

	render() {
		return (
			<Fragment>
				<div>
					<div className="panel panel-default">
						<div className="panel-heading">
							<div className="panel-title">Schools</div>
						</div>
					</div>
					<div className="panel-body">
						<table className="table">
							<thead>
								<tr>
									<th>Name</th>
									<th>Abbreviation</th>
									<th colSpan="3"></th>
								</tr>
							</thead>
							<tbody>
								{this.props.schools_list.map(school =>
									<SchoolsIndexItem school={school} key={`school-${school.abbreviation}`}/>
								)}
							</tbody>
						</table>
					</div>
				</div>
			</Fragment>
		);
	}
}

SchoolsIndex.propTypes = {
	schools_list: PropTypes.array.isRequired
};

export default SchoolsIndex;

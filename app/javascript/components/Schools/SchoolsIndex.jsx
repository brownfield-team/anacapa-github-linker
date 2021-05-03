import React, { Component, Fragment } from 'react';
import SchoolsIndexItem from "./SchoolsIndexItem"
import * as PropTypes from 'prop-types';
import axios from "axios";
import {schoolsRoute} from "../../services/service-routes";
import ReactOnRails from "react-on-rails";

class SchoolsIndex extends Component {
	constructor(props) {
		super(props);
		this.state = {schools: []};
		const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
	}


	componentDidMount() {
		this.getSchools();
	}

	getSchools() {
		axios.get(schoolsRoute).then(response => {
			this.setState({schools: response.data});
		});
	}

	deleteSchool(school) {
		axios.delete(school.path).then(_ => this.getSchools());
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
					<div className="panel panel-body">
						<table className="table">
							<thead>
								<tr>
									<th>Name</th>
									<th>Abbreviation</th>
									<th colSpan="3"></th>
								</tr>
							</thead>
							<tbody>
								{this.state.schools.map(school =>
									<SchoolsIndexItem school={school} onDelete={this.deleteSchool} key={school.id}/>
								)}
							</tbody>
						</table>
					</div>
				</div>
			</Fragment>
		);
	}
}

SchoolsIndex.propTypes = {};

export default SchoolsIndex;

import React, { Component } from 'react';
import * as PropTypes from 'prop-types';
import axios from "axios";

class ReactTest extends Component {
	constructor(props) {
		super(props);
		// Do I need csrf token stuff here?
	}


	render() {
		return (
			<p> Whee!!!! </p>
		);

	}
}

ReactTest.propTypes = {};

export default ReactTest;

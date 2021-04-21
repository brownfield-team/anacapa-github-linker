import React, { Component, Fragment } from 'react';
import * as PropTypes from 'prop-types';
import CoursesService from '../../services/courses-service'
import ReactOnRails from "react-on-rails";
import { Row, Col, MenuItem, Tab, Nav, NavItem, NavDropdown, Button } from "react-bootstrap";

class HomePage extends Component {

    joinCourse(courseId) {
        CoursesService.joinCourse(courseId)
    }

    constructor(props) {
        super(props);
        const csrfToken = ReactOnRails.authenticityToken();
        axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
        axios.defaults.params = {}
        axios.defaults.params['authenticity_token'] = csrfToken;
    }

    render() {
        return (<table class="table table-sm" id="course_list">
        <thead>
          <tr>
            <th>Name</th>
            <th colspan="2"></th>
          </tr>
        </thead>
        <tbody>
          {this.props.courses.map(course=><tr>
            <td>
                {course.name}
            </td>
            <td>
                <button onClick={()=>this.joinCourse(course.id)} className={"btn btn-info btn-sm"}>
                    Join
                </button>
            </td>
          </tr>
          )}
        </tbody>
      </table>)
        
    }
}

HomePage.propTypes = {
    courses : PropTypes.array.isRequired
};

export default HomePage;
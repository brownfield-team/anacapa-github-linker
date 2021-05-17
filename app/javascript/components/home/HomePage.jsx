import React, {Component, Fragment} from 'react';
import VisitorsService from "../../services/visitors-service";

class HomePage extends Component {
    constructor(props) {
        super(props);
        this.state = {courses: [], filteredCourses: []}
    }

    componentDidMount() {
        VisitorsService.getCourseList().then(coursesResponse => {
            this.setState({courses: coursesResponse, filteredCourses: coursesResponse});
        })
    }

    renderCourseName = (course) => {
        if (!course.can_read && !course.can_manage) {
            return course.name;
        } else if (course.can_read && !course.can_manage) {
            return <a className={"list-group-item justify-content-between"} href={course.path}>{course.name}</a>;
        } else if (course.can_manage) {
            return <a className={"list-group-item justify-content-between list-group-item-info"}
                      href={course.path}>{course.name}</a>;
        }
    }

    filterCourses = (query) => {
        const filteredCourses = this.state.courses.filter(c => c.name.indexOf(query) !== -1);
        this.setState({filteredCourses})
    }


    render() {
        return (
            <Fragment>
                <div className="input-group">
                    <span className="input-group-addon" id="basic-addon1">Course Name</span>
                    <input onChange={e => this.filterCourses(e.target.value)} id="courses_search" type="text" className="form-control" placeholder="Search courses..."/>
                </div>
                <table className="table table-sm" id="course_list">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th colSpan="2"/>
                    </tr>
                    </thead>
                    <tbody>
                    {this.state.filteredCourses.map(course => <tr key={course.id} class="is_course_row">
                            <td>
                                {this.renderCourseName(course)}
                            </td>
                            <td>
                                {!course.user_enrolled ?
                                    <a href={course.join_path} data-method={"post"} className={"btn btn-info btn-sm"}>
                                        Join
                                    </a> :
                                    <span> You have already joined the course: <a
                                        href={`https://github.com/${course.course_organization}`}>{course.course_organization}</a>
                            </span>}
                            </td>
                        </tr>
                    )}
                    </tbody>
                </table>
            </Fragment>
        );
    }
}

export default HomePage;
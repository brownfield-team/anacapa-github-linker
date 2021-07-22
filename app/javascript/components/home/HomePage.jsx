import React, {Component, Fragment} from 'react';
import VisitorsService from "../../services/visitors-service";
import BootstrapTable from 'react-bootstrap-table-next';
import { Button } from "react-bootstrap";
import { coursesRoute } from "../../services/service-routes";
import axios from "axios";

class HomePage extends Component {
    constructor(props) {
        super(props);
        this.state = {courses: [], filteredCourses: [], csrfToken: ""}
    }

    componentDidMount() {
        VisitorsService.getCourseList().then(coursesResponse => {
            this.setState({courses: coursesResponse, filteredCourses: coursesResponse});
        })

		const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");
		this.setState({
			csrfToken: csrf
		});
    }

    filterCourses = (query) => {
        const filteredCourses = this.state.courses.filter(c => c.name.indexOf(query) !== -1);
        this.setState({filteredCourses})
    }

	renderCourseUrl = (cell, row) => <a href={row.path}>{cell}</a>;

	renderCourseOrgLink = (cell, row) => {
		const url = `https://github.com/${cell}`;
		return (
			<a href={url}>{cell}</a>
		)
	};

    renderJoinButton = (cell, row) => {
		return (
            <div>
                {!row.user_enrolled ?
					<form method="post" action={`${row.join_path}`}>
						<input
							type="hidden"
							name="authenticity_token"
							value={this.state.csrfToken}
						></input>
						<Button type="submit"
							className="btn btn-success"
							variant="success"
							data-testid={`assign-button-${row.id}`}
						>
							Join
						</Button>
					</form>
                     :
                    <span> You have already joined the course: <a
                        href={`https://github.com/${row.course_organization}`}>{row.course_organization}</a>
            </span>}
            </div>
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
			dataField: 'course_organization',
			text: 'Course Organization',
			sort: true,
			formatter: (cell, row) => this.renderCourseOrgLink(cell, row)
		}, {
			dataField: "user_enrolled",
			text: "Join",
            sort: true,
			formatter: (cell, row) => this.renderJoinButton(cell, row),
		}
	];

    defaultSorted = [{
        dataField: 'user_enrolled',
        order: 'desc'
    }];      

    getCourses = () => {
		axios.get(coursesRoute).then(response => {
			this.setState({ courses: response.data });
		});
	}

    render() {
        return (
            <Fragment>
                <div className="input-group">
                    <span className="input-group-addon" id="basic-addon1">Course Name</span>
                    <input onChange={e => this.filterCourses(e.target.value)} id="courses_search" type="text" className="form-control" placeholder="Search courses..."/>
                </div>
                <BootstrapTable
				boostrap4={true}
				columns={this.columns}
				data={this.state.filteredCourses}
				keyField="id"
				id="course_list"
                defaultSorted={this.defaultSorted}
			    />
            </Fragment>
        );
    }
}

export default HomePage;
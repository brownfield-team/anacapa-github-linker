import React, { useState, useEffect } from 'react';
import axios from "axios";
import { coursesRoute } from "../../services/service-routes";
import ReactOnRails from "react-on-rails";
import BootstrapTable from 'react-bootstrap-table-next';
import { Button } from "react-bootstrap";

const csrfToken = ReactOnRails.authenticityToken();
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
axios.defaults.params = {}
axios.defaults.params['authenticity_token'] = csrfToken;

export default function CoursesIndex(){
	const [courses, setCourses] = useState([]);

	const renderCourseUrl = (cell, row) => <a href={row.path}>{cell}</a>;

	const renderCourseOrgLink = (cell, row) => {
		const url = `https://github.com/${cell}`;
		return (
			<a href={url}>{cell}</a>
		)
	};

	const renderEditButton = (cell, row) => {
		if(row.can_control){
			return (
				<Button className="btn btn-warning" variant="warning" data-testid={`edit-button-${row.id}`} href={`${row.edit_path}`} >Edit</Button>
			)
		}
	}

	const renderDeleteButton = (cell, row) => {
		if(row.can_control){
			return (
				<Button className="btn btn-danger" variant="danger" data-testid={`delete-button-${row.id}`} onClick={() => {if(window.confirm(`Delete course ${row.name}?`)) {deleteCourse(row)}}} >Delete</Button>
			)
		}
	}

	 const renderShowHideButton = (cell, row) => {
		if(row.can_control){
		 return (
			 <Button data-testid={`hidden-button-${row.id}` } onClick={() => hideOrShowCourse(row)}>{row.hidden == false ? 'Hide' : 'Show'}</Button>
		 )
		}
	 }

	 const columns = [
		{
			dataField: 'school.abbreviation',
			text: 'School',
			sort: true
		}, {
			dataField: 'name',
			text: 'Name',
			sort: true,
			formatter: (cell, row) => renderCourseUrl(cell, row)
		}, {
			dataField: 'term',
			text: 'Term',
			sort: true
		},{
			dataField: 'course_organization',
			text: 'Course Organization',
			sort: true,
			formatter: (cell, row) => renderCourseOrgLink(cell, row)
		}, {
			dataField: 'hidden',
			text: 'Hidden',
			sort: true,
			formatter: (cell, row) => renderShowHideButton(cell, row)
		}, {
			dataField: "edit",
			text: "Edit",
			isDummyField: true,
			formatter: (cell, row) => renderEditButton(cell, row)
		}, {
			dataField: "delete",
			text: "Delete",
			isDummyField: true,
			formatter: (cell, row) => renderDeleteButton(cell, row)
		}
	];

	 
	useEffect(()=>{ getCourses(); }, []);

	const getCourses = async () => {
		axios.get(coursesRoute).then(response => {
			setCourses(response.data);
		});
	}

	const deleteCourse = course => {
		axios.delete(course.path).then(_ => getCourses());
	}

	const hideOrShowCourse = course => {
		let hidden = undefined

		if (course.hidden == false) {
			hidden = true
		} else {
			hidden = false
		}

		axios.put(course.path, {
			hidden: hidden
		}).then(_ => getCourses())
	}

	return (
		<BootstrapTable
			boostrap4={true}
			columns={columns}
			data={courses}
			keyField="id"
			id="course_list"
		/>
	);
}

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

export default function CourseStudentPage({ course, path }) {

    return (
        <>
            <h1>
                <a href={path}>{course.name}</a>
            </h1>
            <p>This is the student page</p>
        </>
    );
}

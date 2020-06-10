import axios from '../helpers/axios-rails'
import {studentActivityRoute} from "./service-routes";

class StudentsService {
    static async getActivity(courseId, rosterStudentId, startDate, endDate) {
        const dateParams = {start_date: startDate, end_date: endDate};
        return axios.get(studentActivityRoute(courseId, rosterStudentId), {params: dateParams}).then(response => response.data);
    }
}

export default StudentsService;
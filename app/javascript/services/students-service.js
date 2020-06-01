import axios from '../helpers/axios-rails'
import {studentCommitsRoute} from "./service-routes";

class StudentsService {
    static async getCommits(courseId, rosterStudentId) {
        return axios.get(studentCommitsRoute(courseId, rosterStudentId)).then(response => response.data);
    }
}

export default StudentsService;
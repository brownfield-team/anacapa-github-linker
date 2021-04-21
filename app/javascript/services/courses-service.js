import axios from '../helpers/axios-rails';
import {courseJoinRoute} from "./service-routes";

class CoursesService {
    static async joinCourse(courseId) {
        return axios.post(courseJoinRoute(courseId)).then(response=>response.data);
    }
}

export default CoursesService;
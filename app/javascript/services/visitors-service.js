import axios from '../helpers/axios-rails';
import {visitorsRoute} from "./service-routes";

class VisitorsService {
    static async getCourseList() {
        return axios.get(visitorsRoute).then(response => response.data);
    }
}

export default VisitorsService;

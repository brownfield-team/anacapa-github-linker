import axios from '../../../axios-rails';
import {unaddedTeamsRoute} from "./teams-service-routes";

class TeamsService {
    static getProjectTeams(courseId) {

    }

    static async getUnaddedTeams(courseId) {
        return axios.get(unaddedTeamsRoute(courseId)).then(response => response.data);
    }
}
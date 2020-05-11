import axios from '../../../axios-rails';
import {projectTeamsRoute, unaddedTeamsRoute} from "./teams-service-routes";

class TeamsService {
    constructor(courseId) {
        this.courseId = courseId;
    }

    async getProjectTeams() {
        return axios.get(projectTeamsRoute(this.courseId)).then(response => response.data);
    }

    async getUnaddedTeams() {
        return axios.get(unaddedTeamsRoute(this.courseId)).then(response => response.data);
    }
}

export default TeamsService;
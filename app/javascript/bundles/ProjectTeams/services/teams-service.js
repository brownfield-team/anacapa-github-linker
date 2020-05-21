import axios from '../../../helpers/axios-rails';
import {projectTeamsRoute, orgTeamsRoute, projectTeamRoute} from "./teams-service-routes";

class TeamsService {

    static async getProjectTeams(courseId) {
        return axios.get(projectTeamsRoute(courseId)).then(response => response.data);
    }

    static async getProjectTeam(courseId, projectTeamId) {
        return axios.get(projectTeamRoute(courseId, projectTeamId)).then(response => response.data);
    }

    static async createProjectTeam(courseId, projectTeam) {
        return axios.post(projectTeamsRoute(courseId), projectTeam).then(response => response.data);
    }

    static async updateProjectTeam(courseId, projectTeamId, projectTeam) {
        return axios.put(projectTeamRoute(courseId, projectTeamId), projectTeam).then(response => response.data);
    }

    static async deleteProjectTeam(courseId, projectTeamId) {
        return axios.delete(projectTeamRoute(courseId, projectTeamId)).then(response => response.data);
    }

    static async getOrgTeams(courseId) {
        return axios.get(orgTeamsRoute(courseId)).then(response => response.data);
    }
}

export default TeamsService;
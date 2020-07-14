import axios from '../helpers/axios-rails';
import {orgTeamsRoute, orgTeamRoute} from "./service-routes";

class OrgTeamsService {
    static async getOrgTeams(courseId) {
        return axios.get(orgTeamsRoute(courseId)).then(response => response.data);
    }

    static async getProjectTeam(courseId, projectTeamId) {
        return axios.get(orgTeamRoute(courseId, projectTeamId)).then(response => response.data);
    }

    static async getOrgTeam(courseId, orgTeamId) {
        return axios.get(orgTeamRoute(courseId, orgTeamId)).then(response => response.data);
    }

    static async createOrgTeam(courseId, orgTeam) {
        return axios.post(orgTeamsRoute(courseId), orgTeam).then(response => response.data);
    }

    static async updateOrgTeam(courseId, orgTeamId, orgTeam) {
        return axios.put(orgTeamRoute(courseId, orgTeamId), orgTeam).then(response => response.data);
    }

    static async deleteOrgTeam(courseId, orgTeamId) {
        return axios.delete(orgTeamRoute(courseId, orgTeamId)).then(response => response.data);
    }
}

export default OrgTeamsService;
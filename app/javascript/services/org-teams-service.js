import axios from '../helpers/axios-rails';
import {orgTeamsRoute, orgTeamRoute} from "./service-routes";

class OrgTeamsService {
    static async getOrgTeams(courseId) {
        return axios.get(orgTeamsRoute(courseId)).then(response => response.data);
    }

    static async getOrgTeam(courseId, orgTeamId) {
        return axios.get(orgTeamRoute(courseId, orgTeamId)).then(response => response.data);
    }
}

export default OrgTeamsService;

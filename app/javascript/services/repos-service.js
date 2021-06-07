import axios from '../helpers/axios-rails';
import {githubReposRoute, githubRepoRoute, externalReposRoute} from "./service-routes";

class ReposService {
    static async getGithubRepos(courseId) {
        return axios.get(githubReposRoute(courseId)).then(response => response.data);
    }

    static async getGithubRepo(courseId, githubRepoId) {
        return axios.get(githubRepoRoute(courseId, githubRepoId)).then(response => response.data);
    }

    static async createGithubRepo(courseId, githubRepo) {
        return axios.post(githubReposRoute(courseId), githubRepo).then(response => response.data);
    }

    static async updateGithubRepo(courseId, githubRepoId, githubRepo) {
        return axios.put(githubRepoRoute(courseId, githubRepoId), githubRepo).then(response => response.data);
    }

    static async getExternalRepos(courseId) {
        return axios.get(githubReposRoute(courseId), {params: {external: true}}).then(response => response.data);
    }
}

export default ReposService;

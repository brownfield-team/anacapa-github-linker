import ReactOnRails from 'react-on-rails';

import Users from '../components/Users/Users';
import ProjectTeams from "../components/ProjectTeams/ProjectTeams";
import CourseNavBar from "../components/CourseNavBar/CourseNavBar";
import StudentActivity from "../components/ActivityDashboard/Student/StudentActivity";

import CourseGithubReposIndex from "../components/Course/GithubRepos/CourseGithubReposIndex";
import CourseGithubReposProjectRepos from "../components/Course/GithubRepos/CourseGithubReposProjectRepos";
import CourseGithubRepo from "../components/Course/GithubRepos/CourseGithubRepo";

import JobLauncher from "../components/Jobs/JobLauncher";
import JobLog from "../components/Jobs/JobLog";

import SchoolsIndex from "../components/Schools/SchoolsIndex";
import HomePage from "../components/home/HomePage";

import ExternalReposPage from "../components/Course/GithubRepos/ExternalRepos/ExternalReposPage";

import "../styles.css"

ReactOnRails.register({
  Users,
  ProjectTeams,
  CourseNavBar,
  StudentActivity,
  CourseGithubReposIndex,
  CourseGithubReposProjectRepos,
  CourseGithubRepo,
  JobLauncher,
  JobLog,
  SchoolsIndex,
  HomePage,
  ExternalReposPage,
});

import ReactOnRails from 'react-on-rails';

import Users from '../components/Users/Users';
import ProjectTeams from "../components/ProjectTeams/ProjectTeams";
import OrgTeams from "../components/OrgTeams/OrgTeams";
import CourseNavBar from "../components/CourseNavBar/CourseNavBar";
import StudentActivity from "../components/ActivityDashboard/Student/StudentActivity";
import "../styles.css"

ReactOnRails.register({
  Users,
  ProjectTeams,
  CourseNavBar,
  StudentActivity,
  OrgTeams
});

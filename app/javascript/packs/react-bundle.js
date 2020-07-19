import ReactOnRails from 'react-on-rails';

import Users from '../components/Users/Users';
import ProjectTeams from "../components/ProjectTeams/ProjectTeams";
import CourseNavBar from "../components/CourseNavBar/CourseNavBar";
import StudentActivity from "../components/ActivityDashboard/Student/StudentActivity";
import JobLauncher from "../components/Jobs/JobLauncher";
import JobLog from "../components/Jobs/JobLog";


import "../styles.css"

ReactOnRails.register({
  Users,
  ProjectTeams,
  CourseNavBar,
  StudentActivity,
  JobLauncher,
  JobLog
});

import ReactOnRails from 'react-on-rails';

import Users from '../bundles/Users/components/Users';
import ProjectTeams from "../bundles/ProjectTeams/components/ProjectTeams";
import CourseNavBar from "../bundles/CourseNavBar/components/CourseNavBar";

ReactOnRails.register({
  Users,
  ProjectTeams,
  CourseNavBar
});

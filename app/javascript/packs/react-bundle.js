import ReactOnRails from 'react-on-rails';

import Users from '../bundles/Users/components/Users';
import TeamsDashboard from "../bundles/ProjectTeams/components/TeamsDashboard";
import NewProjectTeam from "../bundles/ProjectTeams/components/Forms/NewProjectTeam"

ReactOnRails.register({
  Users,
  TeamsDashboard,
  NewProjectTeam
});

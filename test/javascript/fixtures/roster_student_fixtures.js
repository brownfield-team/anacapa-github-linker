const rosterStudentFixtures = {
    oneRosterStudent: 
        {
            first_name: "Test", 
            last_name: "Name", 
            perm: "12345678", 
            email: "test@test.org", 
            enrolled: true, 
            section: "4pm", 
            is_ta: true, 
            org_membership_type: "non-member", 
            org_teams: "teams123", 
            slack_user: "SlackUserName"
        },
    oneRosterStudentEnrolledFalse: 
        {
            first_name: "Test", 
            last_name: "Name", 
            perm: "12345678", 
            email: "test@test.org", 
            enrolled: false, 
            section: "4pm", 
            is_ta: false, 
            org_membership_type: "non-member", 
            org_teams: "teams123", 
            slack_user: "SlackUserName"
        }
      
    }
export default rosterStudentFixtures;

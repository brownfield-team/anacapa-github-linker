class ProjectTeamModel {
    constructor(course_id) {
        this.id = 0;
        this.name = "";
        this.meeting_time = "";
        this.project = "";
        this.course_id = course_id;
        this.org_team_id = 0;
        this.qa_url = "";
        this.production_url = "";
        this.team_chat_url = "";
        this.repo_url = "";
        this.milestones_url = "";
        this.project_board_url = "";
    }
}

export default ProjectTeamModel;
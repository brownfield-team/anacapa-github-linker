const courseRoute = (courseId) => `/api/courses/${courseId}`;
const courseProjectTeamsRoute = (courseId) => `${courseRoute(courseId)}/project_teams`
const courseOrgTeamsRoute = (courseId) => `${courseRoute(courseId)}/org_teams`

export const studentRoute = (courseId, studentId) => `${courseRoute(courseId)}/roster_students/${studentId}`
export const projectTeamsRoute = (courseId) => `${courseProjectTeamsRoute(courseId)}.json`
export const projectTeamRoute = (courseId, projectTeamId) => `${courseProjectTeamsRoute(courseId)}/${projectTeamId}`
export const orgTeamsRoute = (courseId) => `${courseOrgTeamsRoute(courseId)}.json`;
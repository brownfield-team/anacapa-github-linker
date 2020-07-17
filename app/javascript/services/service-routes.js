const courseRoute = (courseId) => `/api/courses/${courseId}`;
const courseProjectTeamsRoute = (courseId) => `${courseRoute(courseId)}/project_teams`
const courseOrgTeamsRoute = (courseId) => `${courseRoute(courseId)}/org_teams`
const courseStudentsRoute = (courseId) => `${courseRoute(courseId)}/roster_students`

export const projectTeamsRoute = (courseId) => `${courseProjectTeamsRoute(courseId)}`
export const projectTeamRoute = (courseId, projectTeamId) => `${courseProjectTeamsRoute(courseId)}/${projectTeamId}`
export const orgTeamsRoute = (courseId) => `${courseOrgTeamsRoute(courseId)}`;

export const studentsRoute = (courseId) => `${courseStudentsRoute(courseId)}`
export const studentRoute = (courseId, rosterStudentId) => `${courseStudentsRoute(courseId)}/${rosterStudentId}`
export const studentActivityRoute = (courseId, rosterStudentId) => `${studentRoute(courseId, rosterStudentId)}/activity`

export const studentUiRoute = (courseId, studentId) => `/courses/${courseId}/roster_students/${studentId}`


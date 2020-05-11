const courseRoute = (courseId) => `/courses/${courseId}`;
const courseProjectTeamsRoute = (courseId) => `${courseRoute(courseId)}/project_teams`
const courseOrgTeamsRoute = (courseId) => `${courseRoute(courseId)}/org_teams`

export const studentRoute = (courseId, studentId) => `${courseRoute(courseId)}/roster_students/${studentId}`
export const projectTeamsRoute = (courseId) => `${courseProjectTeamsRoute(courseId)}.json`
export const unaddedTeamsRoute = (courseId) => `${courseOrgTeamsRoute(courseId)}/unadded.json`;
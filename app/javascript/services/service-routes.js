export const coursesRoute = `/api/courses/`;
const courseRoute = (courseId) => `/api/courses/${courseId}`;
const courseProjectTeamsRoute = (courseId) => `${courseRoute(courseId)}/project_teams`
const courseOrgTeamsRoute = (courseId) => `${courseRoute(courseId)}/org_teams`
export const courseStudentsRoute = (courseId) => `${courseRoute(courseId)}/roster_students`
const courseGithubReposRoute = (courseId) => `${courseRoute(courseId)}/github_repos`

export const orphanCommitsRoute = (courseId) => `${courseRoute(courseId)}/orphans`
export const orphanNamesRoute = (courseId) => `${courseRoute(courseId)}/orphan_names`
export const orphanEmailsRoute = (courseId) => `${courseRoute(courseId)}/orphan_emails`

export const orphanCommitsByNameRoute = (courseId, name) => `${courseRoute(courseId)}/orphan_commits_by_name?name=${encodeURIComponent(name)}`
export const orphanCommitsByEmailRoute = (courseId, email) => `${courseRoute(courseId)}/orphan_commits_by_email?email=${encodeURIComponent(email)}`

export const graphqlRoute = (courseId) => `${courseRoute(courseId)}/graphql`

export const projectTeamsRoute = (courseId) => `${courseProjectTeamsRoute(courseId)}`
export const projectTeamRoute = (courseId, projectTeamId) => `${courseProjectTeamsRoute(courseId)}/${projectTeamId}`
export const orgTeamsRoute = (courseId) => `${courseOrgTeamsRoute(courseId)}`;
export const orgTeamRoute = (courseId, orgTeamId) => `${courseOrgTeamsRoute(courseId)}/${orgTeamId}`;

export const studentsRoute = (courseId) => `${courseStudentsRoute(courseId)}`
export const studentRoute = (courseId, rosterStudentId) => `${courseStudentsRoute(courseId)}/${rosterStudentId}`
export const studentActivityRoute = (courseId, rosterStudentId) => `${studentRoute(courseId, rosterStudentId)}/activity`

export const studentUiRoute = (courseId, studentId) => `/courses/${courseId}/roster_students/${studentId}`

export const githubReposRoute = (courseId) => `${courseGithubReposRoute(courseId)}`
export const githubRepoRoute = (courseId, githubRepoId) => `${courseGithubReposRoute(courseId)}/${githubRepoId}`

export const schoolsRoute = `/api/schools`;
export const visitorsRoute = "/api/visitors";
export const courseJoinRoute = (courseId) => `/courses/${courseId}/join`


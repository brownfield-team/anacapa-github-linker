const courseTeamsRoute = (courseId) => `/courses/${courseId}/teams`
export const projectTeamsRoute = (courseId) => `${courseTeamsRoute(courseId)}.json`
export const unaddedTeamsRoute = (courseId) => `${courseTeamsRoute(courseId)}/unadded.json`;
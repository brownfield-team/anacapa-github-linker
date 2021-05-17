export default class IssueFragments {
 static all() {
    return `
    fragment issueFields on Issue {
      number
      url
      title
      createdAt
      state
    }
  `
 }
}
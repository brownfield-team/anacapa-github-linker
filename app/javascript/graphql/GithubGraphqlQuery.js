
class GithubGraphqlQuery {

    // Override this if you need a custom accept header
    // for example for API previews.  Otherwise the default
    // is fine.
    static accept() {
        return "";
    }
    
    static query(org_name, repo_name, after_clause) {
        // this query is a placeholder, a kind of 
        // "hello world" for graphql.  Always override this 
        return ( /* GraphQL */ ` 
            query { 
                viewer { 
                  login
                }
            }
      `); /* EndGraphQL */
    }

    // The remainder of the methods can be used in queries
    // like this: ${this.pageInfoFields} (after the main query)
    // Then you can use ...pageInfoFields as a macro for the fields listed inside

    static pageInfoFields() {
        return `
          fragment pageInfoFields on PageInfo {
            startCursor
            hasNextPage
            endCursor
          }
        `
    }

    static actorFields() {
      return `
        fragment actorFields on Actor {
            login
            ... on User {
              databaseId
              email
              name
            }
          }
      `
    }
   
    static issueFields() {
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
   
    static userContentEditFields() {
      return `
        fragment userContentEditFields on UserContentEdit {
          createdAt
          deletedAt
          deletedBy {
            ...actorFields
          }
          editedAt
          editor {
            ...actorFields
          }
          updatedAt
          diff
        }
      `
    }

    static issueTimelineItemsFields() {
      return `
        fragment issueTimelineItemsFields on IssueTimelineItems {
          __typename
          ... on AddedToProjectEvent { ... addedToProjectEventFields }
          ... on MovedColumnsInProjectEvent { ... movedColumnsInProjectEventFields }
        }
      `;
    }

    static addedToProjectEventFields() {
      return `
        fragment addedToProjectEventFields on AddedToProjectEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          project {
            name
            url
          }
          projectColumnName
        }
      `
    }

    static movedColumnsInProjectEventFields() {
      return `
        fragment movedColumnsInProjectEventFields on MovedColumnsInProjectEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          project {
            name
            url
          }
          previousProjectColumnName
          projectColumnName
        }
      `
    }

    // Not a real function; just a template to copy/paste
    // for creating fragments
    static fragmentTemplate() {
      return `
        fragment fragmentName on Type {
         
        }
      `
    }

}

export default GithubGraphqlQuery;
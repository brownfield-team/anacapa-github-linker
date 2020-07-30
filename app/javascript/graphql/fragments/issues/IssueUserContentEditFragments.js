
// https://docs.github.com/en/graphql/reference/objects#usercontentedit

export default class IssueUserContentEditFragments {
    
    static all() {
        return `
           ${this.userContentEditFields()}
           ${this.issueTimelineItemsFields()}
           ${this.addedToProjectEventFields()}
           ${this.movedColumnsInProjectEventFields()}
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
}
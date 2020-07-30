export default class IssueTimelineItemsFragments {
    
    static all() {
        return `
           ${this.issueTimelineItemsFields()}
           ${this.addedToProjectEventFields()}
           ${this.movedColumnsInProjectEventFields()}
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
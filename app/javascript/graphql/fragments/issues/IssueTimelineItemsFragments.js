export default class IssueTimelineItemsFragments {
    
    static all() {
        return `
           ${this.issueTimelineItemsFields()}
           ${this.addedToProjectEventFields()}
           ${this.assignedEventFields()}
           ${this.closedEventFields()}
           ${this.movedColumnsInProjectEventFields()}
        `
    }

    static issueTimelineItemsFields() {
       return `
         fragment issueTimelineItemsFields on IssueTimelineItems {
           __typename
           ... on AddedToProjectEvent { ... addedToProjectEventFields }
           ... on AssignedEvent {... assignedEventFields}
           ... on ClosedEvent {... closedEventFields}
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

     static assignedEventFields() {
      return `
        fragment assignedEventFields on AssignedEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          assignee {
            ... on Actor {
              login
            }
          }
        }
      `
    }

     static closedEventFields() {
      return `
        fragment closedEventFields on ClosedEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
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
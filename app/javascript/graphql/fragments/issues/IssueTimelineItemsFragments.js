export default class IssueTimelineItemsFragments {
    
    static all() {
        return `
           ${this.issueTimelineItemsFields()}
           ${this.addedToProjectEventFields()}
           ${this.assignedEventFields()}
           ${this.closedEventFields()}
           ${this.commentDeletedEventFields()}
           ${this.connectedEventFields()}
           ${this.convertedNoteToIssueEventFields()}
           ${this.crossReferencedEventFields()}
           ${this.demilestonedEventFields()}
           ${this.disconnectedEventFields()}
           ${this.issueCommentEventFields()}
           ${this.labeledEventFields()}
           ${this.milestonedEventFields()}
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
           ... on Comment {... issueCommentEventFields}
           ... on ConnectedEvent {... connectedEventFields}
           ... on CommentDeletedEvent {... commentDeletedEventFields}
           ... on ConvertedNoteToIssueEvent {... convertedNoteToIssueEventFields}
           ... on CrossReferencedEvent {... crossReferencedEventFields}
           ... on DemilestonedEvent {... demilestonedEventFields }
           ... on DisconnectedEvent {... disconnectedEventFields }
           ... on LabeledEvent {... labeledEventFields }
           ... on MilestonedEvent {... milestonedEventFields}
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

    
    static connectedEventFields() {
      return `
      fragment connectedEventFields on ConnectedEvent {
        id
        actor {
          ...actorFields
        }
        createdAt
        source {
          ... on Issue {
            number
          }
        }
        subject {
          ... on PullRequest {
            number
          }
        }
      }
    `
    }


    static crossReferencedEventFields() {
      return `
        fragment crossReferencedEventFields on CrossReferencedEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          target {
            ... on Issue {
              number
            }
            ... on PullRequest {
              number
            }
          }
        }
      `
    }
    
    static convertedNoteToIssueEventFields() {
      return `
        fragment convertedNoteToIssueEventFields on ConvertedNoteToIssueEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          project{
            name
          }
          projectColumnName
        }
      `
    }

    static commentDeletedEventFields() {
      return `
        fragment commentDeletedEventFields on CommentDeletedEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
        }
      `
    }

    static demilestonedEventFields() {
      return `
        fragment demilestonedEventFields on DemilestonedEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          milestoneTitle
        }
      `
    }

    static disconnectedEventFields() {
      return `
        fragment disconnectedEventFields on DisconnectedEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          source {
            ... on Issue {
              number
            }
          }
          subject {
            ... on PullRequest {
              number
            }
          }
        }
      `
    }

    static issueCommentEventFields() {
      return `
        fragment issueCommentEventFields on Comment {
          id
          createdAt
          updatedAt
          author{
            login
            }
        }
      `
    }

    static labeledEventFields() {
      return `
        fragment labeledEventFields on LabeledEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          label{
            name
          }
        }
      `
    }

    static milestonedEventFields() {
      return `
        fragment milestonedEventFields on MilestonedEvent {
          id
          actor {
            ...actorFields
          }
          createdAt
          milestoneTitle
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
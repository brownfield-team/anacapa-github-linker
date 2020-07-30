import GithubGraphqlQuery from './GithubGraphqlQuery';

class IssueTimelineItems extends GithubGraphqlQuery {

    static accept() { 
        return "application/vnd.github.starfox-preview+json"; 
    }
    
    static query(org_name, repo_name, after_clause) {
        return  ( /* GraphQL */ ` 
        query {
            repository(owner: "${org_name}", name: "${repo_name}") {
                issues(first: 50 ${after_clause}) {
                    pageInfo { ...pageInfoFields }
                    totalCount
                    nodes {
                        ... issueFields
                        author { ... actorFields }
                        timelineItems(itemTypes: [ADDED_TO_PROJECT_EVENT, ASSIGNED_EVENT,  CLOSED_EVENT, MOVED_COLUMNS_IN_PROJECT_EVENT, REMOVED_FROM_PROJECT_EVENT, REOPENED_EVENT], first: 50) {
                            pageInfo { ...pageInfoFields }
                            totalCount
                            nodes { 
                               ...issueTimelineItemsFields
                            }
                        } 
                    }                 
                }
            }
        }         

        ${this.pageInfoFields()}
        ${this.issueFields()}
        ${this.actorFields()}

        ${this.addedToProjectEventFields()}
        ${this.movedColumnsInProjectEventFields()}
        ${this.issueTimelineItemsFields()}


        `); /* EndGraphQL */
    }
}

export default IssueTimelineItems;
import GithubGraphqlQuery from './GithubGraphqlQuery';
import PageInfoFragments from './fragments/PageInfoFragments';
import IssueFragments from './fragments/IssueFragments';
import ActorFragments from './fragments/ActorFragments';
import IssueTimelineItemsFragments from './fragments/issues/IssueTimelineItemsFragments';

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

        ${PageInfoFragments.all()}
        ${IssueFragments.all()}
        ${ActorFragments.all()}
        ${IssueTimelineItemsFragments.all()}

        `); /* EndGraphQL */
    }
    static computeStats (data, databaseId_to_team){
        let statistics = {};
        let errors = {};

        try {
            let issues = data.data.repository.issues;
            let issueNodes = issues.nodes;
            let timelineItemsTotalCountVector =
               issueNodes.map( (n) => n.timelineItems.totalCount);
            let sum = (a,b)=>a+b;
            let timelineItemsCount = 
                timelineItemsTotalCountVector.reduce(sum, 0)
            statistics["totalIssues"] = issues.totalCount;
            statistics["timelineItemsCount"] = timelineItemsCount;
        } catch(e) { 
             errors = {
                 name : e.name,
                 message: e.message
             };
         }

        return {
            statistics: statistics,
            errors: errors
        };
        return {}
    }
}

export default IssueTimelineItems;
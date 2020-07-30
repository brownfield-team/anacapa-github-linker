import GithubGraphqlQuery from './GithubGraphqlQuery';
import PageInfoFragments from './fragments/PageInfoFragments';
import IssueFragments from './fragments/IssueFragments';
import ActorFragments from './fragments/ActorFragments';
import IssueUserContentEditFragments from './fragments/issues/IssueUserContentEditFragments';

class IssueUserEdits extends GithubGraphqlQuery {
    
    static query(org_name, repo_name, after_clause) {
        return  ( /* GraphQL */ ` 
        {
          repository(owner: "${org_name}", name: "${repo_name}") {
            issues(first: 50 ${after_clause} ) {
              pageInfo {
                ...pageInfoFields
              }
              totalCount
              nodes {
                ...issueFields
                author {
                  ...actorFields
                }
                userContentEdits(first: 50) {
                  pageInfo {
                    ...pageInfoFields
                  }
                  totalCount
                  nodes {
                    ... userContentEditFields
                  }
                }
              }
            }
          }
        }

        ${PageInfoFragments.all()}
        ${ActorFragments.all()}
        ${IssueFragments.all()}
        ${IssueUserContentEditFragments.all()}

        `); /* EndGraphQL */
    }
}

export default IssueUserEdits;
import GithubGraphqlQuery from './GithubGraphqlQuery';

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

        ${this.pageInfoFields()}

        

        `); /* EndGraphQL */
    }
}

export default IssueUserEdits;
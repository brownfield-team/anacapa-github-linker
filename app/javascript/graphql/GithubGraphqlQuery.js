
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
    
}

export default GithubGraphqlQuery;
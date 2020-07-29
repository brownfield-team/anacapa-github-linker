
class GraphqlQuery {

    static accept() {
        return "";
    }
    
    static query(org_name, repo_name, after_clause) {
        return ( /* GraphQL */ ` 
            query { 
                viewer { 
                  login
                }
            }
      `); /* EndGraphQL */
    }
}

export default GraphqlQuery;
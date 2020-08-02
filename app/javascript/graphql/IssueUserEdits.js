import GithubGraphqlQuery from './GithubGraphqlQuery';
import PageInfoFragments from './fragments/PageInfoFragments';
import IssueFragments from './fragments/IssueFragments';
import ActorFragments from './fragments/ActorFragments';
import IssueUserContentEditFragments from './fragments/issues/IssueUserContentEditFragments';
import vectorToCounts, {combineCounts} from '../utilities/vectorToCounts';

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

    // given the data returned from this query
    // compute interesting statistics
    
    static computeStats = (data, databaseId_to_team) => {
      
      let statistics = {};
      let errors = {};

      try {
          
          let issues = data.data.repository.issues;
          let issueNodes = issues.nodes;

          let userEditTotalCountVector =
                  issueNodes.map( (n) => n.userContentEdits.totalCount);
          let sum = (a,b)=>a+b;
          let userContentEditCount  = 
              userEditTotalCountVector.reduce(sum, 0)
          
          let issueAuthorsVector = 
              issueNodes.map( (n) => n.author.databaseId );

          let issueAuthorsLoginsVector = 
              issueNodes.map( (n) => n.author.login );
              
          let issueAuthorsLoginsCounts = vectorToCounts(issueAuthorsLoginsVector);

          let issueEditorsVector =  issueNodes.map( (n) => 
                  n.userContentEdits.nodes.map( (e) =>
                      e.editor.databaseId
                  ) 
              ).flat();

          let issueEditorsLoginsVector =  issueNodes.map( (n) => 
              n.userContentEdits.nodes.map( (e) =>
                  e.editor.login
              ) 
          ).flat();    

          let issueEditorsLoginsCounts = vectorToCounts(issueEditorsLoginsVector);

          statistics["totalUserEdits"] = issues.totalCount;

          statistics["issueAuthorsLoginsCounts"] = issueAuthorsLoginsCounts;

          statistics["issueEditorsLoginsCounts"] = issueEditorsLoginsCounts;

          statistics["activityCounts"] = combineCounts(
              statistics["issueAuthorsLoginsCounts"],
              statistics["issueEditorsLoginsCounts"]
          );
      
          let issueAuthorsTeamsVector = issueAuthorsVector.map(
              (databaseId) => databaseId_to_team[databaseId]
          );
          let issueAuthorTeamsCounts = vectorToCounts(issueAuthorsTeamsVector);

          let issueEditorsTeamsVector = issueEditorsVector.map(
              (databaseId) => databaseId_to_team[databaseId]
          );
          let issueEditorsTeamsCounts = vectorToCounts(issueEditorsTeamsVector);

          // statistics["issueAuthorsTeamsVector"] = issueAuthorsTeamsVector;
          statistics["issueAuthorTeamsCounts"] = issueAuthorTeamsCounts;
          statistics["issueEditorsTeamsCounts"] = issueEditorsTeamsCounts;
          statistics["activityTeamsCounts"] = combineCounts(issueAuthorTeamsCounts,issueEditorsTeamsCounts);
     
              
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

export default IssueUserEdits;
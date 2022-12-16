import GithubGraphqlQuery from './GithubGraphqlQuery';
import PageInfoFragments from './fragments/PageInfoFragments';
import IssueFragments from './fragments/IssueFragments';
import ActorFragments from './fragments/ActorFragments';
import IssueTimelineItemsFragments from './fragments/issues/IssueTimelineItemsFragments';
import vectorToCounts, { combineCounts } from '../utilities/vectorToCounts';
import IssueUserContentEditFragments from './fragments/issues/IssueUserContentEditFragments';
class IssueTimelineItems extends GithubGraphqlQuery {

    static accept() {
        return "application/vnd.github.starfox-preview+json";
    }

    static query(org_name, repo_name, after_clause) {
        return ( /* GraphQL */ ` 
        query {
            repository(owner: "${org_name}", name: "${repo_name}") {
                owner { ... actorFields }
                name
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

    static computeIssueTimelineEventsTable(data, databaseId_to_team) {
        let events = [];
        let errors = {};

        try {
            let org = data.data.repository.owner.login;
            let issueNodes = data.data.repository.issues.nodes;

            issueNodes.forEach((n) => {
                let thisNodesTimelineItems = n.timelineItems.nodes;
                let thisNodesEvents = thisNodesTimelineItems.map(
                    (item) => {
                        return {
                            org: org,
                            team: databaseId_to_team[n.author.databaseId],
                            repo: data.data.repository.name,
                            actor: item.actor.login,
                            eventType: item.__typename,
                            createdAt: item.createdAt,
                            assigneeUsername: "TODO",
                            projectName: "TODO",
                            previousProjectColumnName: "TODO",
                            projectColumnName: "TODO"
                        }
                    });
                events = events.concat(thisNodesEvents);
            });
        } catch (e) {
            errors = {
                name: e.name,
                message: e.message
            };
        }

        return {
            events: events,
            errors: errors
        };
    }


    static computeStats(data, databaseId_to_team) {
        let statistics = {};
        let errors = {};

        try {
            let issues = data.data.repository.issues;
            let issueNodes = issues.nodes;
            let timelineItemsTotalCountVector =
                issueNodes.map((n) => n.timelineItems.totalCount);
            let sum = (a, b) => a + b;
            let timelineItemsCount =
                timelineItemsTotalCountVector.reduce(sum, 0)


            let issueTimelineItemsLoginsVector = issueNodes.map((n) =>
                n.timelineItems.nodes.map((timelineItem) => {
                    try {
                        return (timelineItem.actor.login)

                    }
                    catch (e) {
                        console.log(`\nUNKNOWN EVENT TYPE= ${timelineItem.__typename}\n`)
                        return ("NOT AVAILABLE")
                    }

                })
            ).flat();
            let issueTimelineItemsDatabaseIdsVector = issueNodes.map((n) =>
                n.timelineItems.nodes.map((timelineItem) => {
                    try {
                        return (timelineItem.actor.databaseId)

                    }
                    catch (e) {
                        return ("NOT AVAILABLE")
                    }

                })
            ).flat();

            let timelineItemsCounts =
                vectorToCounts(issueTimelineItemsDatabaseIdsVector);

            let issueTimelineItemsTeamsVector = issueTimelineItemsDatabaseIdsVector.map(
                (databaseId) => databaseId_to_team[databaseId]
            );
            let timelineItemsTeamsCount = vectorToCounts(issueTimelineItemsTeamsVector);
            let issueTimelineItemsActorsCounts = vectorToCounts(issueTimelineItemsLoginsVector);
            statistics["totalIssues"] = issues.totalCount;
            statistics["timelineItemsCount"] = timelineItemsCount;
            statistics["timelineItemsCounts"] = timelineItemsCounts;
            statistics["timelineItemsTeamsCount"] = timelineItemsTeamsCount
            statistics["issueTimelineItemsActorsCounts"] = issueTimelineItemsActorsCounts;

        } catch (e) {
            errors = {
                name: e.name,
                message: e.message
            };
        }

        return {
            statistics: statistics,
            errors: errors
        };
    }
}

export default IssueTimelineItems;
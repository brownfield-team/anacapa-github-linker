import GraphqlQuery from './graphql_query';

class GetIssueTimeLineAndUserEdits extends GraphqlQuery {

    static accept() { 
        return "application/vnd.github.starfox-preview+json"; 
    }
    
    static query(org_name, repo_name, after_clause) {
        return  ( /* GraphQL */ ` 
            query {
                repository(owner: "${org_name}", name: "${repo_name}") {
                issues(first: 50 ${after_clause}) {
                    pageInfo {
                        startCursor
                        hasNextPage
                        endCursor
                    }
                    nodes {
                    number
                    url
                    title
                    createdAt
                    state
                    author {
                        login
                        ... on User {
                        databaseId
                        email
                        name
                        }
                    }
                    userContentEdits(first: 50) {
                        pageInfo {
                        startCursor
                        hasNextPage
                        endCursor
                        }
                        nodes {
                        createdAt
                        deletedAt
                        deletedBy {
                            login
                            ... on User {
                            databaseId
                            email
                            name
                            }
                        }
                        editedAt
                        editor {
                            login
                            ... on User {
                            databaseId
                            email
                            name
                            }
                        }
                        updatedAt
                        diff
                        }
                    }
                    timelineItems(itemTypes: [ADDED_TO_PROJECT_EVENT, ASSIGNED_EVENT,  CLOSED_EVENT, MOVED_COLUMNS_IN_PROJECT_EVENT, REMOVED_FROM_PROJECT_EVENT, REOPENED_EVENT], first: 50) {
                        pageInfo {
                        startCursor
                        hasNextPage
                        endCursor
                        }
                        nodes {
                        __typename
                        ... on AddedToProjectEvent {
                            id
                            actor {
                            login
                            ... on User {
                                databaseId
                                email
                                name
                            }
                            }
                            createdAt
                            project {
                                name
                                url
                            }
                            projectColumnName
                        }
                        ... on AssignedEvent {
                            id
                            createdAt
                            actor {
                            login
                            ... on User {
                                databaseId
                                email
                                name
                            }
                            }
                            assignee {
                            ... on User {
                                login
                                databaseId
                                email
                                name
                            }
                            }

                        }
                        ... on ClosedEvent {
                            id
                            actor {
                            login
                            ... on User {
                                databaseId
                                email
                                name
                            }
                            }
                            closer {
                            __typename
                            ... on Commit {
                                url
                                oid
                                message
                            }
                            ... on PullRequest {
                                title
                                url
                            }
                            }
                            createdAt
                            url
                        }
                        ... on MovedColumnsInProjectEvent {
                            id
                            actor {
                            login
                            ... on User {
                                databaseId
                                email
                                name
                            }
                            }
                            createdAt
                            project {
                            name
                            url
                            }
                            previousProjectColumnName
                            projectColumnName
                        }
                        ... on RemovedFromProjectEvent {
                            id
                            actor {
                            login
                            ... on User {
                                databaseId
                                email
                                name
                            }
                            }
                            createdAt
                            project {
                            name
                            url
                            }
                            projectColumnName
                        }
                        }
                    }
                    }
                }
                }
            }
        `); /* EndGraphQL */
    }
}

export default GetIssueTimeLineAndUserEdits;
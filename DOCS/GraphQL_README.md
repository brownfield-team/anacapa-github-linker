# GraphQL for Github

## With CURL

```
curl -H "Authorization: bearer TOKEN-HERE" -X POST -d " \
 { \
   \"query\": \"query { viewer { login }}\" \
 } \
" https://api.github.com/graphql
```

For queries stored in json, use:

curl -H "Authorization: bearer TOKEN-HERE" -X POST -d @file.json https://api.github.com/graphql

The value `TOKEN-HERE` should be replaced with the Machine User token from the .env file.

## Query on Issues

This tells us, among other things, all of the
events for the issue and the event types.

We still don't have per event details.

```
{
  repository(name: "project-s0-t1-budget", owner: "ucsb-cs48-s20") {
    issues(first: 50) {
      pageInfo {
        startCursor
        hasNextPage
        endCursor
      }
      nodes {
        timelineItems(first: 50) {
          nodes {
            __typename
          }
          totalCount
        }
        assignees(first: 50) {
          pageInfo {
            startCursor
            hasNextPage
            endCursor
          }
          totalCount
          nodes {
            id
            login
            name
          }
        }
        closed
        closedAt
        url
        number
        title
        body
        author {
          login
        }
        databaseId
        milestone {
          id
        }
        state
      }
    }
  }
}
```

Here is getting who the issue was assigned to:

```
{
  repository(name: "project-s0-t1-budget", owner: "ucsb-cs48-s20") {
    issues(first: 50) {
      pageInfo {
        startCursor
        hasNextPage
        endCursor
      }
      nodes {
        timelineItems(first: 50) {
          nodes {
            __typename
            ... on AddedToProjectEvent {
              actor {
                login
              }
            }
            ... on AssignedEvent {
              actor {
                login
                __typename
              }
              assignee {
                __typename
                ... on User {
                  login
                }
                ... on Organization {
                  name
                }
              }
              assignable {
                __typename
              }
              createdAt
              id
            }
          }
          totalCount
        }
        assignees(first: 50) {
          pageInfo {
            startCursor
            hasNextPage
            endCursor
          }
          totalCount
          nodes {
            id
            login
            name
          }
        }
        closed
        closedAt
        url
        number
        title
        body
        author {
          login
        }
        databaseId
        milestone {
          id
        }
        state
      }
    }
  }
}
```

Timeline items

```
{
  repository(name: "project-s0-t1-budget", owner: "ucsb-cs48-s20") {
    issues(first: 50) {
      pageInfo {
        startCursor
        hasNextPage
        endCursor
      }
      nodes {
        timelineItems(first: 50) {
          nodes {
            __typename
            ... on AddedToProjectEvent {
              actor {
                login
              }
            }
            ... on AssignedEvent {
              actor {
                login
                __typename
              }
              assignee {
                __typename
                ... on User {
                  login
                }
              }
              assignable {
                __typename
              }
              createdAt
              id
            }
          }
          totalCount
        }
        projectCards(first: 50) {
           pageInfo {
            startCursor
            hasNextPage
            endCursor
          }
          totalCount
          nodes {
            column {
              name
              project {
                name
                url
                number
              }
            url
            name
            }
          }
        }
        assignees(first: 50) {
          pageInfo {
            startCursor
            hasNextPage
            endCursor
          }
          totalCount
          nodes {
            id
            login
            name
          }
        }
        closed
        closedAt
        url
        number
        title
        body
        author {
          login
        }
        databaseId
        milestone {
          id
        }
        state
      }
    }
  }
}

```
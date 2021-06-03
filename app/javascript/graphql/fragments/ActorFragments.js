export default class ActorFragments {
  static all() {
    return `
      fragment actorFields on Actor {
          login
          ... on User {
            databaseId
            email
            name
          }
        }
    `
  }
   
}


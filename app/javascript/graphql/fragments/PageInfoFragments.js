export default class PageInfoFragments {
    static all() {
        return `
          fragment pageInfoFields on PageInfo {
            startCursor
            hasNextPage
            endCursor
          }
        `
    } 
}
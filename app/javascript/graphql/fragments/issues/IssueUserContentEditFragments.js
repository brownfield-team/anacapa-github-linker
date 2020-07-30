
// https://docs.github.com/en/graphql/reference/objects#usercontentedit

export default class IssueUserContentEditFragments {
    
    static all() {
        return `
           ${this.userContentEditFields()}
        `
    }
   
    static userContentEditFields() {
       return `
         fragment userContentEditFields on UserContentEdit {
           createdAt
           deletedAt
           deletedBy {
             ...actorFields
           }
           editedAt
           editor {
             ...actorFields
           }
           updatedAt
           diff
         }
       `
     }
   
    
}
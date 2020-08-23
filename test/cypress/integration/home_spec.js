
describe("Home Page before login", () => {
  describe("Before login", () => {

    beforeEach(() => {
        cy.visit("/");
    });

    it("has a nav bar", () => {
        cy.get("nav.navbar").should("exist");
    });

    it("has a Home button", () => {
        cy.get('a[href="/"]')
        .should('have.text', 'Home')
    });
  }); // before login

  describe("Student login", () => {
    beforeEach(() => { 
      cy.request("/api/testhooks/login_student");
      cy.visit("/");
    });

    it("has a nav bar", () => {
        cy.get("nav.navbar").should("exist");
    });

    it("has a Home button", () => {
        cy.get('a[href="/"]')
        .should('have.text', 'Home')
    });

    it("has a Courses button", () => {
        cy.get('a[href="/courses"]')
        .should('contain.text', 'Courses')
    });
  }); // Student login
  
}); 
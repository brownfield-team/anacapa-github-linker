describe("Home Page student login", () => {

    before(() => {
        cy.appScenario("database_cleaner_start");
    });

    after(() => {
        cy.appScenario("database_cleaner_clean");
    });

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

}); // Home Page
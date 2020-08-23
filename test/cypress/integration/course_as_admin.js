describe("Course as admin", () => {

    before(() => {
        // cy.appScenario("database_cleaner_start");
    });

    after(() => {
        // cy.appScenario("database_cleaner_clean");
    });

    beforeEach(() => { 
        cy.request("/api/testhooks/login_admin");
        cy.visit("/courses/1");
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

    it("has a Users button", () => {
        cy.get('a[href="/users"]')
        .should('contain.text', 'Users')
    });

    it("has an Admin button", () => {
        cy.get('a[href="/admin/dashboard"]')
        .should('contain.text', 'Admin')
    });

    it("has a Students button", () => {
        cy.get('a[href="/courses/1"]')
        .should('contain.text', 'Students')
    });


}); // Home Page
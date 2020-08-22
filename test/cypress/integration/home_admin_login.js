describe("Home Page admin login", () => {


    // before(() => {
    // });

    beforeEach(() => {
        cy.appScenario('admin_login')
        cy.visit("/");
    });

    it("has a nav bar", () => {
        cy.get("nav.navbar").should("exist");
    });

    it("has a Home button", () => {
        cy.get('a[href="/"]')
        .should('have.text', 'Home')
    });


}); // Home Page
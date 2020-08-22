describe("Home Page", () => {

    describe("Before login", () => {

        // before(() => {
        // });

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
    
  }); // Home Page
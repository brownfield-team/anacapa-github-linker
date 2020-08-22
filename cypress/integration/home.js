describe("Home Page", () => {
    before(() => {
      cy.reset();
    });
    beforeEach(() => {
      // runs before each test in the block
  
      cy.loginAsAdmin();
      // the above code is the equivalent of the default cypress command
      // cy.setCookie("AUTH", JSON.stringify(adminUser))
      // you can see this custom command defined in /cypress/support/commands.js
  
      cy.visit("http://localhost:3000");
    });
  
    it("has a nav bar", () => {
      // a nav element with class navbar
      cy.get("nav.navbar").should("exist");
    });
  
    it("has a home page brand button on nav bar", () => {
      cy.get("nav.navbar * a.navbar-brand").should("exist");
    });
  
    it("has a footer element", () => {
      cy.visit("http://localhost:3000");
      cy.get("footer.footer").should("exist");
    });
  });

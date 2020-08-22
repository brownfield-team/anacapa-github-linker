describe("Home Page Admin", () => {
    // before(() => {
      
    // });

    // beforeEach(() => {
      
    // });
  
    it("has a nav bar", () => {
      cy.visit("/");
      cy.get("nav.navbar").should("exist");
    });
  
    
  });
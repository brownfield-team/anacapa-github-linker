// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

import adminUser from "../fixtures/adminUser.json";
import studentUser from "../fixtures/studentUser.json";
import instructorUser from "../fixtures/instructorUser.json";

Cypress.Commands.add("loginAsAdmin", () =>
  cy.setCookie("AUTH", JSON.stringify(adminUser))
);

Cypress.Commands.add("loginAsStudent", () =>
  cy.setCookie("AUTH", JSON.stringify(studentUser))
);

Cypress.Commands.add("loginAsGuest", () =>
  cy.setCookie("AUTH", JSON.stringify(instructorUser))
);

Cypress.Commands.add("reset", () => {
  result = cy.request("http://localhost:3000/api/testhooks/prepare_database");
  console.log(result);
});
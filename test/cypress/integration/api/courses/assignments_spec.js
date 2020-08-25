describe("Api::Courses::Assignments", () => {

    describe("As admin", () => {

        let courseUrl;
        let courseId;
        let apiUrl;

        beforeEach(() => { 
            cy.request("/api/testhooks/login_admin");
            cy.visit("/courses");
            cy.get('table#course_list')
                .find('a')
                .invoke('attr', 'href')
                .then((href) => {
                    courseUrl = href;
                    courseId = href.replace("/courses/","");
                    apiUrl = `/api${courseUrl}/assignments`
                }).then( () => {
                    cy.visit(courseUrl)
                });
        });

        describe("index", () => {
            it("has pa01 from fixture present", () => {
                cy.log(`courseUrl=${courseUrl} courseId=${courseId}`)
                cy.request(apiUrl)
                    .then((response) => {
                        // cy.log(`response=${JSON.stringify(response)}`);
                        // cy.log(`response.body=${JSON.stringify(response.body)}`);
                        expect(response).to.have.property('status', 200);
                        expect(response.body[0]).to.have.property('name', 'pa01');
                    });
            });
        }); 

        describe("show", () => {
            let first_assignment;
            it("calling show on first object returned by index works", () => {
                cy.request(apiUrl)
                    .then((response) => {
                        first_assignment = response.body[0];
                        cy.request(`${apiUrl}/${first_assignment.id}`)
                            .then((response) => {
                                expect(response.body).to.deep.equal(first_assignment);
                            });
                    });
            });
        }); 

        // describe("create", () => {
        //     it("allows an object to be created", () => {
        //         cy.request(apiUrl)
        //             .then((response) => {
        //                 let countBeforeCreate = response.body.length;
        //                 let new_assignment = {
        //                     "assignment": {
        //                        "course_id": courseId,
        //                        "name": "pa99"
        //                     }
        //                 }
        //                 cy.request('POST',apiUrl,JSON.stringify(new_assignment))
        //                     .then((response) => {
        //                         // cy.log(`response=${JSON.stringify(response)}`);
        //                         // cy.log(`response.body=${JSON.stringify(response.body)}`);
        //                     });
        //             });
        //     });
        // }); 

    }); // As admin
}); // Course
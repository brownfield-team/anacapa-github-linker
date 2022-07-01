import { render } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import JoinPage from "../../../../app/javascript/components/Course/JoinPage"
import React from 'react';


describe("JoinPage tests", () => {
  
  test("renders without crashing for empty table any logged in user", () => {

    const course = {
        course_organization : "ucsb-cs156-s22"
    }
    const { getByText } = render(
          <JoinPage course={course} />
    );

    expect(getByText("Your Next Step")).toBeInTheDocument();
  });

});
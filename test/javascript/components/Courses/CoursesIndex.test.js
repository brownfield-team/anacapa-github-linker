import { fireEvent, render, waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import CoursesIndex from "../../../../app/javascript/components/Courses/CoursesIndex"
import React from 'react';
import { QueryClient, QueryClientProvider } from "react-query";
import { MemoryRouter } from "react-router-dom";
import axios from "axios";
import AxiosMockAdapter from "axios-mock-adapter";


describe("CouresIndex tests", () => {
  const queryClient = new QueryClient();
  const axiosMock =new AxiosMockAdapter(axios);

  test("renders without crashing for empty table any logged in user", () => {
    const { getByText } = render(
      <QueryClientProvider client={queryClient}>
        <MemoryRouter>
          <CoursesIndex />
        </MemoryRouter>
      </QueryClientProvider>
    );

    const expectedHeaders = ["School", "Name", "Term", "Hidden", "Course Organization", "Edit", "Delete"];
    expectedHeaders.forEach((headerText) => {
      const header = getByText(headerText);
      expect(header).toBeInTheDocument();
    });
  });

});
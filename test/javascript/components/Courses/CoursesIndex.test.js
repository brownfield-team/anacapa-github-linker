import { fireEvent, render, waitFor, act } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import CoursesIndex from "../../../../app/javascript/components/Courses/CoursesIndex"
import React from 'react';
import { QueryClient, QueryClientProvider } from "react-query";
import { MemoryRouter } from "react-router-dom";
import axios from "axios";
import AxiosMockAdapter from "axios-mock-adapter";


describe("CouresIndex tests", () => {
  const queryClient = new QueryClient();
  const axiosMock = new AxiosMockAdapter(axios);

  test("renders without crashing for empty table any logged in user", () => {
    axiosMock.onGet("/api/courses/").reply(200, []);

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

  test("renders without crashing for non-empty table for admin user", async () => {
    axiosMock.onGet("/api/courses/").reply(200, [
      {
        can_control: true,
        course_organization: "Test-Course-1",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/1/edit",
        hidden: false,
        id: 1,
        name: "test-course-1",
        path: "/courses/1",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "w22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }, 
      {
        can_control: true,
        course_organization: "Test-Course-2",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/2/edit",
        hidden: false,
        id: 2,
        name: "test-course-2",
        path: "/courses/2",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "s22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }]);

    const { getByText, getAllByText } = render(
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

    await waitFor(() => {expect(getByText('test-course-1')).toBeInTheDocument()});
    expect(getByText('w22')).toBeInTheDocument();
    expect(getByText('Test-Course-1')).toBeInTheDocument();
    expect(getByText('test-course-2')).toBeInTheDocument();
    expect(getByText('s22')).toBeInTheDocument();
    expect(getByText('Test-Course-2')).toBeInTheDocument();

    const schoolAbrevs = getAllByText('TEST');
    expect(schoolAbrevs).toHaveLength(2);
    const hideButtons = getAllByText('Hide');
    expect(hideButtons).toHaveLength(2);
    const editButtons = getAllByText('Edit');
    expect(editButtons).toHaveLength(3);
    const deleteButtons = getAllByText('Delete');
    expect(deleteButtons).toHaveLength(3);
  });

  test("renders without crashing for non-empty table for admin user", async () => {
    axiosMock.onGet("/api/courses/").reply(200, [
      {
        can_control: true,
        course_organization: "Test-Course-1",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/1/edit",
        hidden: false,
        id: 1,
        name: "test-course-1",
        path: "/courses/1",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "w22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }, 
      {
        can_control: true,
        course_organization: "Test-Course-2",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/2/edit",
        hidden: false,
        id: 2,
        name: "test-course-2",
        path: "/courses/2",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "s22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }]);

    const { getByText, getAllByText, getByTestId } = render(
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

    await waitFor(() => {expect(getByText('test-course-1')).toBeInTheDocument()});
    expect(getByText('w22')).toBeInTheDocument();
    expect(getByText('Test-Course-1')).toBeInTheDocument();
    expect(getByText('test-course-2')).toBeInTheDocument();
    expect(getByText('s22')).toBeInTheDocument();
    expect(getByText('Test-Course-2')).toBeInTheDocument();

    const schoolAbrevs = getAllByText('TEST');
    expect(schoolAbrevs).toHaveLength(2);
    const hideButtons = getAllByText('Hide');
    expect(hideButtons).toHaveLength(2);
    const editButtons = getAllByText('Edit');
    expect(editButtons).toHaveLength(3);
    const deleteButtons = getAllByText('Delete');
    expect(deleteButtons).toHaveLength(3);
  });

  test("renders without crashing for non-empty table for non-admin user", async () => {
    axiosMock.onGet("/api/courses/").reply(200, [
      {
        can_control: false,
        course_organization: "Test-Course-1",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/1/edit",
        hidden: false,
        id: 1,
        name: "test-course-1",
        path: "/courses/1",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "w22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }, 
      {
        can_control: false,
        course_organization: "Test-Course-2",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/2/edit",
        hidden: false,
        id: 2,
        name: "test-course-2",
        path: "/courses/2",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "s22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }]);

    const { getByText, getAllByText } = render(
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

    await waitFor(() => {expect(getByText('test-course-1')).toBeInTheDocument()});
    expect(getByText('w22')).toBeInTheDocument();
    expect(getByText('Test-Course-1')).toBeInTheDocument();
    expect(getByText('test-course-2')).toBeInTheDocument();
    expect(getByText('s22')).toBeInTheDocument();
    expect(getByText('Test-Course-2')).toBeInTheDocument();

    const hideButtons = getAllByText('Hide');
    expect(hideButtons).toHaveLength(2);
    const editButtons = getAllByText('Edit');
    expect(editButtons).toHaveLength(1);
    const deleteButtons = getAllByText('Delete');
    expect(deleteButtons).toHaveLength(1);
  });

  test("delete button performs correctly when canceled for admin user", async () => {
    axiosMock.onDelete("/courses/1").reply(200);
    axiosMock.onGet("/api/courses/").reply(200, [ 
      {
        can_control: true,
        course_organization: "Test-Course-1",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/1/edit",
        hidden: false,
        id: 1,
        name: "test-course-1",
        path: "/courses/1",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "w22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }]);

    const { getByText, getByTestId, queryByText } = render(
      <QueryClientProvider client={queryClient}>
        <MemoryRouter>
          <CoursesIndex />
        </MemoryRouter>
      </QueryClientProvider>
    );

    await waitFor(() => {expect(getByText('test-course-1')).toBeInTheDocument()});

    window.confirm = jest.fn(() => false);
    fireEvent.click(getByTestId("delete-button-1"));

    axiosMock.onGet("/api/courses/").reply(200, []);

    window.confirm = jest.fn(() => true);
    fireEvent.click(getByTestId("delete-button-1"));

    await waitFor(() => {expect(queryByText('test-course-1')).not.toBeInTheDocument()});
  });

  test("hide button performs correctly for admin user", async () => {
    axiosMock.onPut("/courses/1").reply(200);
    axiosMock.onPut("/courses/2").reply(200);
    axiosMock.onGet("/api/courses/").reply(200, [
      {
        can_control: true,
        course_organization: "Test-Course-1",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/1/edit",
        hidden: false,
        id: 1,
        name: "test-course-1",
        path: "/courses/1",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "w22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }, 
      {
        can_control: true,
        course_organization: "Test-Course-2",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/2/edit",
        hidden: true,
        id: 2,
        name: "test-course-2",
        path: "/courses/2",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "s22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }]);

    const { getByText, getByTestId, getAllByText } = render(
      <QueryClientProvider client={queryClient}>
        <MemoryRouter>
          <CoursesIndex />
        </MemoryRouter>
      </QueryClientProvider>
    );

    await waitFor(() => {expect(getByText('test-course-1')).toBeInTheDocument()});

    axiosMock.onGet("/api/courses/").reply(200, [
      {
        can_control: true,
        course_organization: "Test-Course-1",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/1/edit",
        hidden: true,
        id: 1,
        name: "test-course-1",
        path: "/courses/1",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "w22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }, 
      {
        can_control: true,
        course_organization: "Test-Course-2",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/2/edit",
        hidden: true,
        id: 2,
        name: "test-course-2",
        path: "/courses/2",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "s22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }]);

    fireEvent.click(getByTestId("hidden-button-1"));

    await waitFor(() => {expect(getByText('test-course-1')).toBeInTheDocument()});
    const showButtons = getAllByText('Show');
    expect(showButtons).toHaveLength(2);
    
    axiosMock.onGet("/api/courses/").reply(200, [
      {
        can_control: true,
        course_organization: "Test-Course-1",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/1/edit",
        hidden: true,
        id: 1,
        name: "test-course-1",
        path: "/courses/1",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "w22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }, 
      {
        can_control: true,
        course_organization: "Test-Course-2",
        created_at: "2022-05-10T03:22:04.193Z",
        edit_path: "/courses/2/edit",
        hidden: false,
        id: 2,
        name: "test-course-2",
        path: "/courses/2",
        school: {id: 1, name: 'Test School', abbreviation: 'TEST', created_at: '2022-05-10T03:20:10.256Z', updated_at: '2022-05-10T03:20:10.256Z'},
        term: "s22",
        updated_at: "2022-05-10T03:22:04.193Z",
      }]);

    fireEvent.click(getByTestId("hidden-button-2"));

    await waitFor(() => {expect(getByText('test-course-1')).toBeInTheDocument()});
    const hideButton = getAllByText('Hide');
    expect(hideButton).toHaveLength(1);
    const showButton = getAllByText('Show');
    expect(showButton).toHaveLength(1);

  });

});
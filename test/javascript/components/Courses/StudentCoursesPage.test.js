import { render,waitFor } from "@testing-library/react";
import '@testing-library/jest-dom/extend-expect';
import React from 'react';
import StudentCoursePage from "../../../../app/javascript/components/Courses/StudentCoursePage";
import rosterStudentFixtures from "../../fixtures/roster_student_fixtures";
import userFixtures from "../../fixtures/user_fixtures";
import courseFixtures from "../../fixtures/course_fixtures";

describe("StudentCoursesPage tests", () => {

  test("Has correct Content for true side of conditional expressions", async  () => {
    
    const roster_student = rosterStudentFixtures.oneRosterStudent;
    const user = userFixtures.oneUser;
    const course = courseFixtures.oneCourse;
    const { getByText, getByTestId } = render(
          <StudentCoursePage 
          course={course}
          user={user}
          roster_student={roster_student} />
    );

    const expectedHeaders = ["First Name", "Last Name", "Student Id", "Email", "Enrolled", "Section", "TA", "Slack Id", "Github Id", "Org Status", "Teams"];
    expectedHeaders.forEach((headerText) => {
      const header = getByText(headerText);
      expect(header).toBeInTheDocument();
    });
    await waitFor(() => {expect(getByTestId('StudentCoursesPage-roster_student-enrolled')).toBeInTheDocument()});
    const roster_student_enrolled = getByTestId("StudentCoursesPage-roster_student-enrolled");
    expect(roster_student_enrolled.textContent).toEqual('True');

    const roster_student_ta = getByTestId("StudentCoursesPage-roster_student-ta");
    expect(roster_student_ta.textContent).toEqual('True');

    const course_slack = getByTestId("StudentCoursesPage-course-has-slack");
    expect(course_slack.textContent).toEqual('SlackUserName');
    
  });


  test("Has correct Content for false side of conditional expressions", async  () => {
    
    const roster_student = rosterStudentFixtures.oneRosterStudentEnrolledFalse;
    const user = userFixtures.oneUser;
    const course = courseFixtures.oneCourseWithNoSlackWorkspace;
    const { getByText, getByTestId } = render(
          <StudentCoursePage 
          course={course}
          user={user}
          roster_student={roster_student} />
    );

    const expectedHeaders = ["First Name", "Last Name", "Student Id", "Email", "Enrolled", "Section", "TA", "Slack Id", "Github Id", "Org Status", "Teams"];
    expectedHeaders.forEach((headerText) => {
      const header = getByText(headerText);
      expect(header).toBeInTheDocument();
    });
    await waitFor(() => {expect(getByTestId('StudentCoursesPage-roster_student-enrolled')).toBeInTheDocument()});
    const roster_student_enrolled = getByTestId("StudentCoursesPage-roster_student-enrolled");
    expect(roster_student_enrolled.textContent).toEqual('False');

    const roster_student_ta = getByTestId("StudentCoursesPage-roster_student-ta");
    expect(roster_student_ta.textContent).toEqual('False');

    const course_slack = getByTestId("StudentCoursesPage-course-has-slack");
    expect(course_slack.textContent).toEqual('Unknown');
  });
});
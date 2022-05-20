import { test, expect } from './helpers';

test.describe("when not logged in", () => {
  test("shows a sign in to github button", async ({ page }) => {
    await page.goto("/");
    await expect(page.locator("a:has-text('Sign in')")).toBeVisible();
    await expect(page.locator("button:has-text('Sign in with Github')")).toBeVisible();
  });
});

test.describe("when logged in as an admin", () => {
  test.beforeEach(async ({ loginAsAdmin }) => {
    await loginAsAdmin();
  });

  test("shows the welcome page", async ({ page }) => {
    await page.goto("/");
    await expect(page.locator("text=Welcome Admin")).toBeVisible();
  });
});

import { test as base } from '@playwright/test';

type MyFixtures = {
  loginAsStudent: () => Promise<void>
  loginAsAdmin: () => Promise<void>
};

export const test = base.extend<MyFixtures>({
  loginAsStudent: async ({ page }, use) => {
    await use(async () => {
      await page.request.get("/test_hooks/login_student")
    })
  },
  loginAsAdmin: async ({ page }, use) => {
    await use(async () => {
      await page.request.get("/test_hooks/login_admin")
    })
  }
});

export { expect } from '@playwright/test';
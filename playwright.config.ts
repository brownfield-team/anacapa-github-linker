import { PlaywrightTestConfig } from '@playwright/test';
const config: PlaywrightTestConfig = {
  testDir: "test/playwright",
  webServer: {
    command: "bin/rails server -e test -p 3333",
    port: 3333
  },
  use: {
    baseURL: "http://localhost:3333"
  }
};
export default config;
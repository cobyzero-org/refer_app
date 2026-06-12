import { $, expect, browser } from '@wdio/globals';
import { byText } from 'appium-flutter-finder';

describe('Refer App UI Tests', () => {
    it('should connect and take a screenshot', async () => {
        // 1. Check App Health
        const health = await (browser as any).execute('flutter:checkHealth');
        console.log('App Health Status:', health);
        
        // 2. Wait for Splash Screen to finish
        await browser.pause(5000);
        
        // 3. Take a screenshot to see what is happening
        await browser.saveScreenshot('./screenshot_app.png');
        console.log('Screenshot saved in tests_e2e/screenshot_app.png');
        
        // 4. Just verify we can interact with the app
        // We can wait for any element to confirm the app is rendered
        // For example, any Text widget
    });

    it('should interact with the app', async () => {
        // Example: Find a button by its key (if defined in Flutter code)
        // const loginBtn = findByValueKey('login_button');
        // await $(loginBtn).click();
    });
});

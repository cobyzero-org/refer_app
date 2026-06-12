import type { Options } from '@wdio/types'

export const config: Options.Testrunner = {
    runner: 'local',
    autoCompileOpts: {
        autoCompile: true,
        tsNodeOpts: {
            project: './tsconfig.json',
            transpileOnly: true
        }
    },
    specs: [
        './test/specs/**/*.ts'
    ],
    exclude: [],
    maxInstances: 1,
    capabilities: [
        {
            // iOS Configuration
            platformName: 'iOS',
            'appium:deviceName': 'iPhone 17',
            'appium:platformVersion': '26.3',
            'appium:automationName': 'Flutter',
            'appium:app': '../build/ios/iphonesimulator/Runner.app',
            'appium:newCommandTimeout': 240,
            'appium:flutterSystemScreenshot': true,
        } as any
    ],
    logLevel: 'info',
    bail: 0,
    baseUrl: 'http://localhost',
    waitforTimeout: 10000,
    connectionRetryTimeout: 120000,
    connectionRetryCount: 3,
    services: ['appium'],
    framework: 'mocha',
    reporters: ['spec'],
    mochaOpts: {
        ui: 'bdd',
        timeout: 60000
    },
}

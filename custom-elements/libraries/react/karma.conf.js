var webpack = require('webpack');
var path = require('path');

module.exports = function(config) {
  config.set({
    plugins: [
      'karma-chrome-launcher',
      'karma-firefox-launcher',
      require(path.resolve(__dirname, '../__shared__/karma-plugins/karma-mocha')),
      'karma-sourcemap-loader',
      'karma-webpack',
      require(path.resolve(__dirname, '../__shared__/karma-plugins/karma-custom-html-reporter')),
      require(path.resolve(__dirname, '../__shared__/karma-plugins/karma-custom-json-reporter'))
    ],
    browsers: ['ChromeHeadless', 'FirefoxHeadless'], // run in Chrome and Firefox
    customLaunchers: {
      FirefoxHeadless: {
        base: 'Firefox',
        flags: [ '-headless' ],
        displayName: 'FirefoxHeadless'
      },
    },
    singleRun: true, // set this to false to leave the browser open
    frameworks: ['mocha'], // use the mocha test framework
    files: [
      'tests.webpack.js' // just load this file
    ],
    preprocessors: {
      'tests.webpack.js': ['webpack', 'sourcemap'] // preprocess with webpack and our sourcemap loader
    },
    reporters: ['dots', 'custom-html', 'custom-json'], // report results in these formats
    htmlReporter: {
      outputFile: path.resolve(__dirname, './results/results.html'),
      pageTitle: 'React + Custom Elements',
      groupSuites: true,
      useCompactStyle: true
    },
    jsonResultReporter: {
      outputFile: path.resolve(__dirname, './results/results.json')
    },
    webpack: { // kind of a copy of your webpack config
      mode: 'development',
      // devtool: 'inline-source-map', // just do inline source maps instead of the default
      resolve: {
        modules: [
          path.resolve(__dirname, '../__shared__/webcomponents/src'),
          path.resolve(__dirname, './node_modules')
        ]
      },
      module: {
        rules: [
          {
            test: /\.js$/,
            exclude: /node_modules/,
            use: {
              loader: 'babel-loader'
            }
          }
        ]
      }
    },
    webpackServer: {
      // noInfo: true // please don't spam the console when running in karma!
    }
  });
};
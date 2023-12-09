const path = require("path");
const HtmlWebPackPlugin = require( 'html-webpack-plugin' );
const Dotenv = require("dotenv-webpack");

module.exports = {
  entry: "./src/index.tsx",
  mode: "development",
  devtool: "inline-source-map",
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: "ts-loader",
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"],
  },
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, "dist"),
    publicPath: '/',
  },
  plugins: [
    new HtmlWebPackPlugin({
       template: path.resolve( __dirname, 'public/index.html' ),
       filename: 'index.html',
    }),
    new Dotenv({
      path: './.env', // Path to .env file (this is the default)
      safe: true, // load .env.example (defaults to "false" which does not use dotenv-safe)
    }),
 ]
};

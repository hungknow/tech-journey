const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");
const dependencies = require("./package.json").dependencies;
const { FederatedTypesPlugin } = require('@module-federation/typescript');
const { ModuleFederationPlugin } = require("webpack").container;

const moduleFederationPluginOptions = {
    name: "shell",
    filename: "remoteEntry.js",
    remotes: {
        LeftNav: "leftNavigation@http://localhost:3001/remoteEntry.js",
        TopNav: "topNavigation@http://localhost:3002/remoteEntry.js",
        ItemDetails: "itemDetails@http://localhost:3003/remoteEntry.js"
    },
    // exposes: {},
    shared: [{
        // ...dependencies,
        "@emotion/cache": {
            requiredVersion: ">=11.11.0"
        }},
        {
        "react": {
            singleton: true,
            requiredVersion: dependencies.react
        }},
        {
        "react-dom": {
            singleton: true,
            requiredVersion: dependencies["react-dom"]
        }},
        {
        "@mui/material": {
            singleton: true,
            requiredVersion: dependencies["@mui/material"]
         } },
         {
        "@mui/icons-material": {
            singleton: true,
            requiredVersion: dependencies["@mui/icons-material"] 
        }}],
};

module.exports = {
    entry: "./src/index.ts",
    mode: "development",
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "main.js"
    },
    devServer: {
        port: 3004,
        liveReload: true,
        historyApiFallback: true
    },
    name: "shell",
    resolve: {
        extensions: ['.ts', '.tsx', '.js', '.jsx'],
    },
    module: {
        rules: [
          {
            test: /\.(js|jsx|tsx|ts)$/,
            exclude: /node_modules/,
            use: {
              loader: "babel-loader",
            },
          },
          {
            test: /\.scss$/,
            use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
          },
        ],
    },
    plugins: [
        new ModuleFederationPlugin(moduleFederationPluginOptions),
        new FederatedTypesPlugin({
            federationConfig: moduleFederationPluginOptions
        }),
        new HtmlWebpackPlugin({
            template: "./public/index.html",
            filename: "index.html"
        }),
        new MiniCssExtractPlugin()
    ]
}
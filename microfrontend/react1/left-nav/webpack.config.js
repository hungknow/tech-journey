const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");
const { FederatedTypesPlugin } = require('@module-federation/typescript');
const dependencies = require("./package.json").dependencies;
const { ModuleFederationPlugin } = require("webpack").container;

const moduleFederationPluginOptions = {
    name: "leftNavigation",
    filename: "remoteEntry.js",
    remotes: {},
    exposes: {
        "./LeftNav": "./src/LeftNav"
    },
    shared: {
        ...dependencies,
        "@emotion/memoize": {},
        "@emotion/cache": {
            requiredVersion: ">=11.11.0"
        },
        "react": {
            singleton: true,
            requiredVersion: dependencies.react
        },
        "react-dom": {
            singleton: true,
            requiredVersion: dependencies["react-dom"]
        },
        "@mui/material": {
            singleton: true,
            requiredVersion: dependencies["@mui/material"]
          },
        "@mui/icons-material": {
            singleton: true,
            requiredVersion: dependencies["@mui/icons-material"] 
        }
    }
};

module.exports = {
    entry: "./src/index",
    mode: "development",
    // output: {
    //     path: path.resolve(__dirname, "dist"),
    //     filename: "main.js"
    // },
    resolve: {
        extensions: ['.ts', '.tsx', '.js', '.jsx'],
    },
    devServer: {
        static: {
            directory: path.join(__dirname, 'dist'),
        },
        port: 3001,
        // liveReload: true,
        // historyApiFallback: true
    },
    name: "left-nav",
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
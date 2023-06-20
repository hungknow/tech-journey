const path = require("path");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
    entry: "./js/index",
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "index.js",
    },
    mode: "development",
    module: {
        rules: [{
            test: /\.css$/,
            use: ['style-loader', 'css-loader']
        },{
            test: /\.vue$/,
            use: ['vue-loader'],
        }]    
    },
    resolve: {
        extensions: ['.js'],
    },
    plugins: [
        new CopyWebpackPlugin({
            patterns: ["js/index.html"]
        }),
        new VueLoaderPlugin()
    ],
    experiments: {
        asyncWebAssembly: true
    }
}
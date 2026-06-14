const path = require('path');

module.exports = {
  entry: './src/index',
  mode: 'development',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist'),
  },
  resolve: {
    extensions: [".js"]
  }
};
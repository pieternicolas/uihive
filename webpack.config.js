const path = require('path');
const glob = require("glob");

const entryArray = glob.sync('./src/*/*.js');
const entryObject = entryArray
  .filter(item => item.indexOf('index.js') > -1)
  .reduce((acc, item) => {
    const name = item.replace('/index.js', '').replace('/src', '');
    acc[name] = item;
    return acc;
  }, {});

module.exports = {
  entry: entryObject,
  output: {
    path: path.join(process.cwd(), ''),
    filename: '[name].js',
    library: 'uihive',
    libraryTarget: 'umd'
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        use: 'babel-loader',
        exclude: /node_modules/
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.jsx']
  },
  devServer: {
    port: 3001
  }
};
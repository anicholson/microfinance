module.exports = {
  entry: {
    index: "./src/index.js",
    static: "./src/static.js"
  },

  output: {
    path: './dist',
    filename: '[name].js'
  },

  resolve: {
    modulesDirectories: ['node_modules'],
    extensions: ['', '.js', '.elm']
  },

  module: {
    loaders: [
      {
        test: /.html$/,
        exclude: /node_modules/,
        loader: 'file?name=[name].ecr'
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm'
      },
        {
            test: /\.s[ac]ss$/,
            loader: 'style!css!sass'
        }
    ],

    noParse: /\.elm$/
  },

  devServer: {
    inline: true,
    stats: 'errors-only'
  }
};

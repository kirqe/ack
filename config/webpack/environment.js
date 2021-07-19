const { environment } = require('@rails/webpacker')

// quill resize toolbar icons fix, using with webpack
// https://github.com/quilljs/webpack-example/issues/3#issuecomment-658294912
const fileLoader = environment.loaders.get('file')
fileLoader.exclude = /node_modules[\\/]quill/

const svgLoader = {
  test: /\.svg$/,
  loader: 'raw-loader'
}
  
environment.loaders.prepend('svg', svgLoader)

module.exports = environment

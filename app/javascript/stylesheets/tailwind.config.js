module.exports = {
  purge: [
    "./app/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/javascript/**/*.vue",
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      container: {
        screens: {
         sm: "100%",
         md: "100%",
         lg: "768px",
         xl: "768px"
        }
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}

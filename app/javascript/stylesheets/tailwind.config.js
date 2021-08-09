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
      },
      colors: {        
        "primary": "var(--accent)",
        "primary-light": "var(--accent-light)",
        "primary-lighter": "var(--accent-lighter)",
        "primary-lightest": "var(--accent-lightest)",        
      },
      gridAutoRows: {
        "200": "200px"
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}

const path = require('path');

module.exports = {
  purge: [path.resolve(__dirname, `./**/*.{js,ts,jsx,tsx}`)],
  important: true,
  plugins: [],
};

const path = require('path');

module.exports = {
  content: [path.resolve(__dirname, `./**/*.{js,ts,jsx,tsx}`)],
  important: true,
  plugins: [],
};

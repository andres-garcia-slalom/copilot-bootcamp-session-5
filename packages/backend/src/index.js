const app = require('./app');

const PORT = process.env.PORT || 3001;

// INTENTIONAL ISSUE: Missing error handling for server startup
app.listen(PORT);

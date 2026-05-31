const app = require('./app');

const PORT = process.env.PORT || 3001;

// INTENTIONAL ISSUE: Missing error handling for server startup
// INTENTIONAL LINT VIOLATION (for Step 5-2): console.log should be replaced with proper logging
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

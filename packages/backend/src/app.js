const express = require('express');
const cors = require('cors');

// Initialize express app
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// In-memory data store for TODOs
// INTENTIONAL ISSUE: This should be initialized as an empty array
let todos = null;

// INTENTIONAL ISSUE: Missing counter for ID generation
// let nextId = 1;

// INTENTIONAL LINT VIOLATION (for Step 5-2): Unused variable should be removed or used
const unusedDebugFlag = true;

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// GET /api/todos - Get all todos
// INTENTIONAL ISSUE: This endpoint has a bug - it doesn't handle the case when todos is null
app.get('/api/todos', (req, res) => {
  res.json(todos);
});

// POST /api/todos - Create a new todo
// INTENTIONAL ISSUE: Missing implementation
app.post('/api/todos', (req, res) => {
  // TODO: Implement this endpoint
  // Should validate that title is provided
  // Should generate an ID
  // Should create todo with: { id, title, completed: false, createdAt: timestamp }
  res.status(501).json({ error: 'Not implemented' });
});

// PUT /api/todos/:id - Update a todo
// INTENTIONAL ISSUE: Missing implementation
app.put('/api/todos/:id', (req, res) => {
  // TODO: Implement this endpoint
  // Should find todo by id
  // Should update title if provided
  // Should return 404 if not found
  res.status(501).json({ error: 'Not implemented' });
});

// PATCH /api/todos/:id/toggle - Toggle todo completion status
// INTENTIONAL ISSUE: Has a logical bug
app.patch('/api/todos/:id/toggle', (req, res) => {
  const id = parseInt(req.params.id);
  const todo = todos.find((t) => t.id === id);

  if (!todo) {
    return res.status(404).json({ error: 'Todo not found' });
  }

  // INTENTIONAL BUG: This always sets to true instead of toggling
  todo.completed = true;

  res.json(todo);
});

// DELETE /api/todos/:id - Delete a todo
// INTENTIONAL ISSUE: Missing implementation
app.delete('/api/todos/:id', (req, res) => {
  // TODO: Implement this endpoint
  // Should find and remove todo by id
  // Should return 404 if not found
  res.status(501).json({ error: 'Not implemented' });
});

// INTENTIONAL ISSUE: Missing error handling middleware

module.exports = app;

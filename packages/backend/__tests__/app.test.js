const request = require('supertest');
const app = require('../src/app');

describe('TODO API Tests', () => {
  describe('GET /api/todos', () => {
    test('should return an array of todos', async () => {
      const response = await request(app).get('/api/todos');
      expect(response.status).toBe(200);
      expect(Array.isArray(response.body)).toBe(true);
    });

    test('should return empty array initially', async () => {
      const response = await request(app).get('/api/todos');
      expect(response.body).toEqual([]);
    });
  });

  describe('POST /api/todos', () => {
    test('should create a new todo with title', async () => {
      const newTodo = { title: 'Test Todo' };
      const response = await request(app).post('/api/todos').send(newTodo);

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('id');
      expect(response.body).toHaveProperty('title', 'Test Todo');
      expect(response.body).toHaveProperty('completed', false);
      expect(response.body).toHaveProperty('createdAt');
    });

    test('should return 400 when title is missing', async () => {
      const response = await request(app).post('/api/todos').send({});

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error');
    });

    test('should return 400 when title is empty string', async () => {
      const response = await request(app)
        .post('/api/todos')
        .send({ title: '' });

      expect(response.status).toBe(400);
      expect(response.body).toHaveProperty('error');
    });

    test('should auto-increment IDs', async () => {
      const todo1 = await request(app)
        .post('/api/todos')
        .send({ title: 'First Todo' });

      const todo2 = await request(app)
        .post('/api/todos')
        .send({ title: 'Second Todo' });

      expect(todo2.body.id).toBeGreaterThan(todo1.body.id);
    });
  });

  describe('PUT /api/todos/:id', () => {
    test('should update todo title', async () => {
      // First create a todo
      const createResponse = await request(app)
        .post('/api/todos')
        .send({ title: 'Original Title' });

      const todoId = createResponse.body.id;

      // Then update it
      const updateResponse = await request(app)
        .put(`/api/todos/${todoId}`)
        .send({ title: 'Updated Title' });

      expect(updateResponse.status).toBe(200);
      expect(updateResponse.body.title).toBe('Updated Title');
      expect(updateResponse.body.id).toBe(todoId);
    });

    test('should return 404 for non-existent todo', async () => {
      const response = await request(app)
        .put('/api/todos/99999')
        .send({ title: 'Updated Title' });

      expect(response.status).toBe(404);
    });

    test('should not change completed status', async () => {
      // Create and toggle a todo
      const createResponse = await request(app)
        .post('/api/todos')
        .send({ title: 'Test Todo' });

      const todoId = createResponse.body.id;

      await request(app).patch(`/api/todos/${todoId}/toggle`);

      // Update title
      const updateResponse = await request(app)
        .put(`/api/todos/${todoId}`)
        .send({ title: 'New Title' });

      expect(updateResponse.body.completed).toBe(true);
    });
  });

  describe('PATCH /api/todos/:id/toggle', () => {
    test('should toggle todo from incomplete to complete', async () => {
      // Create a todo
      const createResponse = await request(app)
        .post('/api/todos')
        .send({ title: 'Test Todo' });

      const todoId = createResponse.body.id;

      // Toggle it
      const toggleResponse = await request(app).patch(
        `/api/todos/${todoId}/toggle`
      );

      expect(toggleResponse.status).toBe(200);
      expect(toggleResponse.body.completed).toBe(true);
    });

    test('should toggle todo from complete to incomplete', async () => {
      // Create and complete a todo
      const createResponse = await request(app)
        .post('/api/todos')
        .send({ title: 'Test Todo' });

      const todoId = createResponse.body.id;

      // Toggle to complete
      await request(app).patch(`/api/todos/${todoId}/toggle`);

      // Toggle back to incomplete
      const toggleResponse = await request(app).patch(
        `/api/todos/${todoId}/toggle`
      );

      expect(toggleResponse.status).toBe(200);
      expect(toggleResponse.body.completed).toBe(false);
    });

    test('should return 404 for non-existent todo', async () => {
      const response = await request(app).patch('/api/todos/99999/toggle');

      expect(response.status).toBe(404);
    });
  });

  describe('DELETE /api/todos/:id', () => {
    test('should delete a todo', async () => {
      // Create a todo
      const createResponse = await request(app)
        .post('/api/todos')
        .send({ title: 'Test Todo' });

      const todoId = createResponse.body.id;

      // Delete it
      const deleteResponse = await request(app).delete(`/api/todos/${todoId}`);

      expect(deleteResponse.status).toBe(200);

      // Verify it's gone
      const getResponse = await request(app).get('/api/todos');
      const todoExists = getResponse.body.some((t) => t.id === todoId);
      expect(todoExists).toBe(false);
    });

    test('should return 404 for non-existent todo', async () => {
      const response = await request(app).delete('/api/todos/99999');

      expect(response.status).toBe(404);
    });
  });

  describe('Integration Tests', () => {
    test('should handle full CRUD lifecycle', async () => {
      // Create
      const createRes = await request(app)
        .post('/api/todos')
        .send({ title: 'Lifecycle Test' });
      const todoId = createRes.body.id;
      expect(createRes.status).toBe(201);

      // Read
      const getRes = await request(app).get('/api/todos');
      expect(getRes.body.some((t) => t.id === todoId)).toBe(true);

      // Update
      const updateRes = await request(app)
        .put(`/api/todos/${todoId}`)
        .send({ title: 'Updated Lifecycle' });
      expect(updateRes.status).toBe(200);
      expect(updateRes.body.title).toBe('Updated Lifecycle');

      // Toggle
      const toggleRes = await request(app).patch(`/api/todos/${todoId}/toggle`);
      expect(toggleRes.body.completed).toBe(true);

      // Delete
      const deleteRes = await request(app).delete(`/api/todos/${todoId}`);
      expect(deleteRes.status).toBe(200);

      // Verify deletion
      const finalGetRes = await request(app).get('/api/todos');
      expect(finalGetRes.body.some((t) => t.id === todoId)).toBe(false);
    });
  });
});

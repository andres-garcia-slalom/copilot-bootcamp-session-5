import React, { useState } from 'react';
import {
  Container,
  Box,
  Typography,
  TextField,
  Button,
  Card,
  CardContent,
  List,
  ListItem,
  Checkbox,
  IconButton,
  Paper,
  CircularProgress,
  Chip,
  Stack,
  Alert,
} from '@mui/material';
import {
  Delete as DeleteIcon,
  Edit as EditIcon,
  Add as AddIcon,
  Save as SaveIcon,
  Cancel as CancelIcon,
} from '@mui/icons-material';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import './App.css';

// Use relative API URL for better environment flexibility
const API_URL = '/api/todos';

// React Query hook for fetching todos with error handling
const useTodos = () => {
  return useQuery({
    queryKey: ['todos'],
    queryFn: async () => {
      const response = await fetch(API_URL);
      if (!response.ok) {
        throw new Error('Failed to fetch todos');
      }
      const data = await response.json();
      return data;
    },
  });
};

function App() {
  const [newTodoTitle, setNewTodoTitle] = useState('');
  const [editingId, setEditingId] = useState(null);
  const [editingTitle, setEditingTitle] = useState('');
  const queryClient = useQueryClient();

  // Fetch todos using React Query
  const { data: todos = [], isLoading, error } = useTodos();

  // Mutation for adding a new todo
  const addTodoMutation = useMutation({
    mutationFn: async (title) => {
      const response = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title }),
      });
      if (!response.ok) {
        throw new Error('Failed to create todo');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] });
      setNewTodoTitle('');
    },
  });

  // Mutation for toggling todo completion
  const toggleTodoMutation = useMutation({
    mutationFn: async (id) => {
      const response = await fetch(`${API_URL}/${id}/toggle`, {
        method: 'PATCH',
      });
      if (!response.ok) {
        throw new Error('Failed to toggle todo');
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] });
    },
  });

  // Mutation for deleting a todo
  const deleteTodoMutation = useMutation({
    mutationFn: async (id) => {
      const response = await fetch(`${API_URL}/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) {
        throw new Error('Failed to delete todo');
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] });
    },
  });

  // Mutation for updating a todo
  const updateTodoMutation = useMutation({
    mutationFn: async ({ id, title }) => {
      const response = await fetch(`${API_URL}/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title }),
      });
      if (!response.ok) {
        throw new Error('Failed to update todo');
      }
      return response.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] });
      setEditingId(null);
      setEditingTitle('');
    },
  });

  const handleAddTodo = (e) => {
    e.preventDefault();
    if (newTodoTitle.trim()) {
      addTodoMutation.mutate(newTodoTitle);
    }
  };

  const handleToggleTodo = (id) => {
    toggleTodoMutation.mutate(id);
  };

  const handleDeleteTodo = (id) => {
    deleteTodoMutation.mutate(id);
  };

  const handleStartEdit = (id, currentTitle) => {
    setEditingId(id);
    setEditingTitle(currentTitle);
  };

  const handleCancelEdit = () => {
    setEditingId(null);
    setEditingTitle('');
  };

  const handleSaveEdit = (id) => {
    if (editingTitle.trim()) {
      updateTodoMutation.mutate({ id, title: editingTitle });
    }
  };

  // Calculate stats from todos array
  const incompleteTodos = todos.filter((todo) => !todo.completed).length;
  const completedTodos = todos.filter((todo) => todo.completed).length;

  return (
    <Box
      sx={{
        minHeight: '100vh',
        bgcolor: 'background.default',
        py: 4,
      }}
    >
      <Container maxWidth="md">
        <Paper
          elevation={0}
          sx={{
            p: 4,
            borderRadius: 3,
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            color: 'white',
            mb: 4,
          }}
        >
          <Typography variant="h4" component="h1" gutterBottom>
            TODO App
          </Typography>
          <Typography variant="body1" sx={{ opacity: 0.9 }}>
            Session 5: Agentic Development
          </Typography>
        </Paper>

        <Card sx={{ mb: 3 }}>
          <CardContent>
            <Box
              component="form"
              onSubmit={handleAddTodo}
              sx={{ display: 'flex', gap: 2 }}
            >
              <TextField
                fullWidth
                value={newTodoTitle}
                onChange={(e) => setNewTodoTitle(e.target.value)}
                placeholder="What needs to be done?"
                variant="outlined"
                size="medium"
              />
              <Button
                type="submit"
                variant="contained"
                startIcon={<AddIcon />}
                sx={{ minWidth: 120 }}
              >
                Add
              </Button>
            </Box>
          </CardContent>
        </Card>

        {/* Error handling */}
        {error && (
          <Alert severity="error" sx={{ mb: 3 }}>
            Error loading todos. Please check your connection and try again.
          </Alert>
        )}

        {isLoading && (
          <Box sx={{ display: 'flex', justifyContent: 'center', my: 4 }}>
            <CircularProgress />
          </Box>
        )}

        {/* Empty state message */}
        {!isLoading && !error && todos.length === 0 && (
          <Card>
            <CardContent>
              <Typography
                variant="body1"
                color="text.secondary"
                align="center"
                sx={{ py: 4 }}
              >
                No todos yet. Add one above to get started!
              </Typography>
            </CardContent>
          </Card>
        )}

        {/* Todo list */}
        {!isLoading && !error && todos.length > 0 && (
          <Card>
            <List sx={{ p: 0 }}>
              {todos.map((todo, index) => (
                <ListItem
                  key={todo.id}
                  sx={{
                    borderBottom: index < todos.length - 1 ? 1 : 0,
                    borderColor: 'divider',
                    '&:hover': {
                      bgcolor: 'action.hover',
                    },
                  }}
                >
                  <Checkbox
                    checked={todo.completed}
                    onChange={() => handleToggleTodo(todo.id)}
                    sx={{ mr: 2 }}
                  />
                  {editingId === todo.id ? (
                    <>
                      <TextField
                        value={editingTitle}
                        onChange={(e) => setEditingTitle(e.target.value)}
                        size="small"
                        sx={{ flex: 1, mr: 2 }}
                        autoFocus
                      />
                      <Stack direction="row" spacing={1}>
                        <IconButton
                          size="small"
                          color="primary"
                          onClick={() => handleSaveEdit(todo.id)}
                          aria-label="save"
                        >
                          <SaveIcon />
                        </IconButton>
                        <IconButton
                          size="small"
                          onClick={handleCancelEdit}
                          aria-label="cancel"
                        >
                          <CancelIcon />
                        </IconButton>
                      </Stack>
                    </>
                  ) : (
                    <>
                      <Typography
                        sx={{
                          flex: 1,
                          textDecoration: todo.completed ? 'line-through' : 'none',
                          color: todo.completed ? 'text.secondary' : 'text.primary',
                        }}
                      >
                        {todo.title}
                      </Typography>
                      <Stack direction="row" spacing={1}>
                        <IconButton
                          size="small"
                          color="primary"
                          onClick={() => handleStartEdit(todo.id, todo.title)}
                          aria-label="edit"
                        >
                          <EditIcon />
                        </IconButton>
                        <IconButton
                          size="small"
                          color="error"
                          onClick={() => handleDeleteTodo(todo.id)}
                          aria-label="delete"
                        >
                          <DeleteIcon />
                        </IconButton>
                      </Stack>
                    </>
                  )}
                </ListItem>
              ))}
            </List>
          </Card>
        )}

        {/* Stats with correct calculations */}
        <Box sx={{ mt: 3, display: 'flex', justifyContent: 'center', gap: 2 }}>
          <Chip label={`${incompleteTodos} items left`} color="primary" />
          <Chip label={`${completedTodos} completed`} color="success" />
        </Box>
      </Container>
    </Box>
  );
}

export default App;

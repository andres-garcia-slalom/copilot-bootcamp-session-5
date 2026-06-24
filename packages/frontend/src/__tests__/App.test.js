import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import App from '../App';

// Create a test query client
const createTestQueryClient = () =>
  new QueryClient({
    defaultOptions: {
      queries: {
        retry: false,
      },
    },
  });

// Mock fetch for tests
global.fetch = jest.fn();

// Helper to render App with React Query provider
const renderApp = (todos = []) => {
  const testQueryClient = createTestQueryClient();
  global.fetch.mockResolvedValueOnce({
    ok: true,
    json: async () => todos,
  });

  return render(
    <QueryClientProvider client={testQueryClient}>
      <App />
    </QueryClientProvider>
  );
};

describe('App Component', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('renders TODO App heading', async () => {
    renderApp();
    const headingElement = await screen.findByText(/TODO App/i);
    expect(headingElement).toBeInTheDocument();
  });

  test('displays empty state message when no todos', async () => {
    renderApp([]);
    await waitFor(() => {
      expect(screen.queryByRole('progressbar')).not.toBeInTheDocument();
    });
    expect(screen.getByText(/no todos yet/i)).toBeInTheDocument();
  });

  test('calculates and displays correct stats for incomplete items', async () => {
    const todos = [
      { id: 1, title: 'Todo 1', completed: false },
      { id: 2, title: 'Todo 2', completed: false },
      { id: 3, title: 'Todo 3', completed: true },
    ];
    renderApp(todos);

    await waitFor(() => {
      expect(screen.getByText(/2 items left/i)).toBeInTheDocument();
    });
  });

  test('calculates and displays correct stats for completed items', async () => {
    const todos = [
      { id: 1, title: 'Todo 1', completed: false },
      { id: 2, title: 'Todo 2', completed: true },
      { id: 3, title: 'Todo 3', completed: true },
    ];
    renderApp(todos);

    await waitFor(() => {
      expect(screen.getByText(/2 completed/i)).toBeInTheDocument();
    });
  });

  test('delete button calls DELETE API endpoint', async () => {
    const todos = [{ id: 1, title: 'Test Todo', completed: false }];
    renderApp(todos);

    await waitFor(() => {
      expect(screen.getByText('Test Todo')).toBeInTheDocument();
    });

    // Mock the delete API call
    global.fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({}),
    });

    // Mock the refetch after delete
    global.fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => [],
    });

    const deleteButton = screen.getByRole('button', { name: /delete/i });
    await userEvent.click(deleteButton);

    await waitFor(() => {
      expect(global.fetch).toHaveBeenCalledWith(
        expect.stringContaining('/api/todos/1'),
        expect.objectContaining({ method: 'DELETE' })
      );
    });
  });

  test('uses relative API URL instead of hardcoded localhost', async () => {
    renderApp([]);

    await waitFor(() => {
      const fetchCalls = global.fetch.mock.calls;
      const firstCall = fetchCalls[0];
      expect(firstCall[0]).toMatch(/^\/api\/todos$/);
    });
  });

  test('displays error message when API fails', async () => {
    const testQueryClient = createTestQueryClient();
    global.fetch.mockRejectedValueOnce(new Error('Network error'));

    render(
      <QueryClientProvider client={testQueryClient}>
        <App />
      </QueryClientProvider>
    );

    await waitFor(() => {
      expect(screen.getByText(/error loading todos/i)).toBeInTheDocument();
    });
  });

  test('edit button opens edit mode', async () => {
    const todos = [{ id: 1, title: 'Test Todo', completed: false }];
    renderApp(todos);

    await waitFor(() => {
      expect(screen.getByText('Test Todo')).toBeInTheDocument();
    });

    const editButton = screen.getByRole('button', { name: /edit/i });
    await userEvent.click(editButton);

    // Should show a text field for editing
    expect(screen.getByDisplayValue('Test Todo')).toBeInTheDocument();
  });

  test('edit functionality saves changes via PUT endpoint', async () => {
    const todos = [{ id: 1, title: 'Original Title', completed: false }];
    renderApp(todos);

    await waitFor(() => {
      expect(screen.getByText('Original Title')).toBeInTheDocument();
    });

    const editButton = screen.getByRole('button', { name: /edit/i });
    await userEvent.click(editButton);

    const input = screen.getByDisplayValue('Original Title');
    await userEvent.clear(input);
    await userEvent.type(input, 'Updated Title');

    // Mock the PUT API call
    global.fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => ({ id: 1, title: 'Updated Title', completed: false }),
    });

    // Mock the refetch after update
    global.fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => [{ id: 1, title: 'Updated Title', completed: false }],
    });

    const saveButton = screen.getByRole('button', { name: /save/i });
    await userEvent.click(saveButton);

    await waitFor(() => {
      expect(global.fetch).toHaveBeenCalledWith(
        expect.stringContaining('/api/todos/1'),
        expect.objectContaining({
          method: 'PUT',
          body: expect.stringContaining('Updated Title'),
        })
      );
    });
  });
});

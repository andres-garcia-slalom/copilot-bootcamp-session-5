# Agentic Development Workflow Patterns

## Overview

**Agentic Development** refers to working with AI coding assistants as collaborative agents in iterative, feedback-driven development cycles. This document outlines key workflow patterns you'll practice in Session 5.

## Core Principles

1. **Iterative Problem Solving**: Break large problems into small, verifiable steps
2. **Continuous Validation**: Test after every change to maintain confidence
3. **Feedback-Driven**: Let tests, compilers, and runtime errors guide your next action
4. **Incremental Progress**: Small, working steps beat large, broken changes
5. **Human-in-the-Loop**: You remain the decision-maker; AI is your tool

---

## Pattern 1: Test-Driven Development (TDD) Cycle

### The Red-Green-Refactor Loop

```
1. RED    → Write or run test (fails)
2. GREEN  → Write minimal code to pass
3. REFACTOR → Improve code quality
4. REPEAT → Move to next test
```

### Workflow with AI

1. **Understand the Test**

   - Read the failing test carefully
   - Ask Copilot: "Explain what this test expects"
   - Identify the specific requirement

2. **Implement Minimally**

   - Ask Copilot: "Implement just enough to make this test pass"
   - Avoid over-engineering
   - Focus on the immediate requirement

3. **Verify**

   ```bash
   npm test -- --testNamePattern="specific test name"
   ```

4. **Refactor if Needed**

   - Ask Copilot: "How can I improve this code?"
   - Ensure tests still pass after refactoring

5. **Move to Next Test**
   - Commit working code
   - Tackle next failing test

### Example Conversation with Copilot

```
You: "I have a failing test for POST /api/todos. Show me the test."
Copilot: [Shows test code]

You: "This test expects a 201 status and a todo object with id, title,
completed, and createdAt. Implement the POST endpoint to pass this test."
Copilot: [Provides implementation]

You: "Run the test to verify it passes."
[Run: npm test -- --testNamePattern="should create a new todo"]

You: "It passes! Now let's handle the validation test that checks for
missing title."
```

---

## Pattern 2: Compilation/Lint Error Resolution Loop

### The Error-Fix-Verify Cycle

```
1. RUN LINT → Identify errors
2. ANALYZE  → Understand each error
3. FIX      → Correct one error at a time
4. VERIFY   → Re-run to confirm fix
5. REPEAT   → Until clean
```

### Workflow with AI

1. **Run Linter**

   ```bash
   npm run lint
   ```

2. **Triage Errors**

   - Copy error messages to Copilot
   - Ask: "Explain these ESLint errors and suggest fixes"

3. **Fix Systematically**

   - Fix one category at a time (e.g., all unused vars first)
   - Ask Copilot: "Fix all unused variable errors in this file"

4. **Verify Each Fix**

   ```bash
   npm run lint
   ```

5. **Commit When Clean**
   - Don't move forward with lint errors
   - Clean code is a prerequisite for the next step

### Example ESLint Workflow

```
Terminal Output:
  3:7  error  'unusedVar' is assigned but never used  no-unused-vars
  12:9 warning  Unexpected console statement          no-console

You: "I have these ESLint errors. Help me fix them appropriately."

Copilot: [Suggests removing unused variable or using it appropriately]
         [Suggests replacing console.log with proper logging]

You: "Apply these fixes."
[Copilot edits code]

You: "Run lint again to verify."
```

---

## Pattern 3: Implementation Planning and Execution

### The Plan-Build-Test-Fix Cycle

```
1. PLAN    → Break feature into steps
2. BUILD   → Implement one step
3. TEST    → Verify step works
4. FIX     → Debug issues
5. REPEAT  → Next step
```

### Workflow with AI

1. **Create Implementation Plan**

   ```
   You: "I need to implement the DELETE /api/todos/:id endpoint.
   Create a step-by-step implementation plan."

   Copilot:
   1. Parse ID from request params
   2. Find todo in array
   3. Return 404 if not found
   4. Remove todo from array
   5. Return success response
   6. Add error handling
   ```

2. **Implement Step-by-Step**

   ```
   You: "Implement step 1 and 2: parse ID and find todo."
   [Copilot provides code]

   You: "Add a console.log to verify this works, then test manually."
   [Test with curl or Postman]

   You: "Good! Now implement step 3: handle not found case."
   ```

3. **Test Each Step**

   - Manual testing with API client
   - Unit tests
   - Integration tests

4. **Iterate Based on Feedback**

   ```
   Terminal: Error: Cannot read property 'id' of undefined

   You: "I'm getting this error. What's wrong?"
   Copilot: [Diagnoses null check issue]

   You: "Fix this null check issue."
   ```

### Benefits of This Approach

- ✅ Smaller changes are easier to debug
- ✅ Each step can be tested independently
- ✅ Clear progress markers
- ✅ Easy to roll back if needed
- ✅ Builds understanding incrementally

---

## Pattern 4: Integration Testing and Debugging

### The Run-Observe-Fix-Rerun Cycle

```
1. RUN APP     → Start application
2. OBSERVE     → Test functionality manually
3. IDENTIFY    → Find bugs or issues
4. FIX         → Correct specific problem
5. RERUN       → Verify fix works
6. REPEAT      → Until fully functional
```

### Workflow with AI

1. **Start Application**

   ```bash
   npm run start
   ```

2. **Test User Flows**

   - Create a todo
   - Toggle completion
   - Edit todo
   - Delete todo
   - Check edge cases

3. **Document Issues**

   ```
   You: "When I click Delete, nothing happens. Here's the relevant code:
   [paste handleDeleteTodo function]

   What's wrong?"

   Copilot: "The function logs to console but doesn't actually call the API..."
   ```

4. **Fix and Retest**

   ```
   You: "Implement the actual DELETE API call."
   [Copilot provides implementation]

   You: "Now test again by clicking delete in the UI."
   [Verify fix works]
   ```

5. **Test Integration Points**
   - Does frontend properly handle backend errors?
   - Are loading states shown?
   - Does data persist across page refreshes? (if applicable)

---

## Pattern 5: Systematic Debugging

### The Isolate-Reproduce-Fix Cycle

```
1. ISOLATE     → Narrow down problem location
2. REPRODUCE   → Create minimal test case
3. HYPOTHESIZE → Form theory about cause
4. TEST        → Verify hypothesis
5. FIX         → Implement solution
6. VALIDATE    → Confirm fix works
```

### Workflow with AI

1. **Describe the Problem Clearly**

   ```
   You: "The toggle function always sets completed to true,
   even for completed todos. Here's the code:
   [paste toggle function]"
   ```

2. **Ask for Analysis**

   ```
   You: "Analyze this code and identify why it doesn't toggle properly."

   Copilot: "The bug is on line 8: todo.completed = true
   This should be: todo.completed = !todo.completed"
   ```

3. **Implement Fix**

   ```
   You: "Apply this fix."
   ```

4. **Create Test to Prevent Regression**
   ```
   You: "Write a test that verifies toggle works both ways."
   ```

---

## Best Practices for AI-Assisted Workflows

### DO ✅

- **Be Specific**: "Fix the toggle bug in line 45" vs "Fix my code"
- **Provide Context**: Share relevant code, error messages, test output
- **Ask for Explanation**: "Why does this test fail?" before "Fix this test"
- **Verify Each Step**: Run tests/app after each change
- **Commit Frequently**: Save working states
- **Break Down Problems**: Tackle one issue at a time

### DON'T ❌

- **Don't Accept Blindly**: Understand what AI suggests
- **Don't Skip Testing**: Never commit untested code
- **Don't Batch Changes**: Multiple changes = harder debugging
- **Don't Ignore Errors**: Each error is valuable feedback
- **Don't Rush**: Slow and steady wins the race

---

## Practice Exercises

Use these prompts with Copilot to practice each pattern:

### TDD Exercise

```
"Show me all failing tests in app.test.js. Let's fix them one by one,
starting with the simplest."
```

### Lint Exercise

```
"Run ESLint on src/app.js and explain each error. Then fix them
systematically, verifying after each fix."
```

### Implementation Exercise

```
"I need to implement the edit todo feature. Create a detailed plan,
then let's build it step-by-step, testing as we go."
```

### Integration Exercise

```
"Start the app and test creating, editing, and deleting todos.
Document any issues you find, then fix them one at a time."
```

### Debug Exercise

```
"The stats at the bottom always show 0. Help me debug this by analyzing
the relevant code and proposing a fix."
```

---

## Measuring Success

You're mastering agentic workflows when:

- ✅ You naturally break problems into small steps
- ✅ You run tests frequently and automatically
- ✅ You understand error messages and use them to guide fixes
- ✅ You can explain each change you make
- ✅ You commit working code regularly
- ✅ You catch bugs early through continuous testing
- ✅ You collaborate effectively with AI by providing good context

---

## Remember

> "The goal isn't to get AI to write all your code. The goal is to develop
> a reliable, repeatable workflow where AI helps you move faster while
> maintaining quality and understanding."

Good luck, and happy iterating! 🚀

# Patterns Discovered

A catalog of recurring patterns, solutions, and anti-patterns found in this codebase. Add entries as you discover them.

---

## Pattern Template

```
## Pattern: <short descriptive name>
**Context**: <where/when this pattern applies>
**Problem**: <what goes wrong without this pattern>
**Solution**: <what to do instead>
**Example**:
// code example here
**Related Files**: <list of files where this pattern appears>
**Discovered**: YYYY-MM-DD
```

---

## Pattern: Service Initialization — Empty Array vs Null
**Context**: Express backend service layer; any function that returns a list of resources
**Problem**: Returning `null` (or leaving a variable uninitialized) instead of an empty array `[]` causes downstream consumers to fail when they attempt to iterate (e.g., `.map()`, `.filter()`, `.forEach()`). This surfaces as runtime `TypeError: Cannot read properties of null` errors that are hard to trace back to the initialization site.
**Solution**: Always initialize list-returning variables to `[]`, not `null` or `undefined`. Guard all service return values that represent collections with an empty array default.

**Example**:
```js
// ❌ Anti-pattern — causes TypeError if consumers iterate before data loads
let todos = null;

// ✅ Correct — safe to iterate immediately
let todos = [];

// ✅ Also correct — safe default in a service function
async function getTodos() {
  try {
    const result = await db.query('SELECT * FROM todos');
    return result.rows ?? [];
  } catch (err) {
    console.error(err);
    return []; // always return an array, never null
  }
}
```

**Related Files**: `packages/backend/src/app.js`, `packages/backend/__tests__/app.test.js`
**Discovered**: 2026-06-24

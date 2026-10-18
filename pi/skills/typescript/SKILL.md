---
name: typescript
description: TypeScript style rules. Apply whenever writing or editing TypeScript files.
---

TypeScript style:

- Object types always use one field per line, even when they would fit on one line:

  ```ts
  // good
  type Report = {
  	ok: boolean;
  	ms: number;
  };

  // bad
  type Report = { ok: boolean; ms: number };
  ```

- Control flow statements always get curly braces, even for a single statement:

  ```ts
  // good
  if (done) {
  	return;
  }

  // bad
  if (done) return;
  ```

- Every new file you create starts with the comment line:

  ```ts
  // Disclaimer: This file was generated with AI assistance.
  ```

- Everything else follows `.prettierrc.json` (tabs, semicolons, double quotes, width 100).
- Prefer fewer, shorter lines: if a line packs two unrelated things together, split it.

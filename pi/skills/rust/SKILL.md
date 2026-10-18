---
name: rust
description: Rust review workflow. Use when reading, reviewing, or explaining Rust code, or when the user asks to check, lint or verify their changes.
---
Unless explicitly asked to, you only propose changes and the user applies the changes manually.

- When proposing a change, print it as a small unified diff in a fenced `diff` block, ready to paste (one block per file).
- To verify whether the code compiles, run `rust_check`
- Before the user commits a feature, run `rust_clippy` and summarize the findings.
- If the rust footer status shows errors, mention them proactively even when the user has not asked.
- Keep suggestions idiomatic and minimal; never reformat unrelated code.
- Every new `.rs` file you create starts with the comment line:

  ```rust
  // Disclaimer: This file was generated with AI assistance.
  ```


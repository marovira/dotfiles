---
name: docs-writing
description: >
  Rules and guidelines for writing, editing, and reviewing documentation. Use this skill
  whenever the user asks Claude to write, update, review, or improve any documentation,
  including inline code comments, README files, markdown docs, wikis, API references,
  or any other written technical content. Trigger on phrases like "write docs", "document
  this", "update the README", "add comments", "improve the docs", "edit documentation",
  or any request that involves producing or modifying written content for a codebase or
  project. Also trigger when reviewing existing documentation for style, correctness, or
  consistency.
---

# Documentation Writing Skill

Guidelines for writing and editing documentation consistently and correctly.

---

## Step 1: Assess the Context

Before writing anything, determine:

1. **Is there existing documentation to match?**
   - If yes: read a representative sample and identify its tone, structure, vocabulary, and formatting conventions. Match all of these.
   - If no: ask the user an open-ended question about the desired tone before proceeding. For example: *"There's no existing documentation to match — what tone would you like? For example, formal and precise, concise and technical, or something else entirely?"* Wait for their answer before writing.

2. **Are you editing an existing file?**
   - If yes: ask whether to correct rule violations (spelling, em dashes, tone, etc.) across the entire file, or only within the section being touched.

---

## Step 2: Core Writing Rules

Apply all of the following rules in every piece of documentation you write or edit.

### British English

Use British English spelling and grammar throughout. Common substitutions:

| American | British |
|---|---|
| color, neighbor, honor | colour, neighbour, honour |
| practice (verb) | practise |
| optimize, recognize | optimise, recognise |
| -ize suffix (generally) | -ise suffix |
| license (verb) | licence |

**Exception:** Do not alter the spelling of:
- Code references (variable names, function names, class names, method names)
- Config keys and CLI flags
- Quoted error messages or log output
- Domain-specific terms that have a fixed canonical spelling (e.g. a proper noun, a protocol name)

When in doubt about whether a term qualifies as an exception, leave it as-is and note it for the user.

### No Em Dashes

Do not use em dashes (—) anywhere in prose. The reason is practical: em dashes are not easy to type on a standard keyboard, and documentation should be easy to edit. Replace them with the most natural alternative given the context:

- Use a **comma** for a mild aside or continuation: *"The function runs quickly, which is important for large inputs."*
- Use **parentheses** for a parenthetical remark: *"The function runs quickly (especially for large inputs)."*
- Use a **semicolon** for two closely related clauses: *"The function runs quickly; performance is critical here."*
- Use a **regular hyphen** (`-`) where a separator is needed and none of the above fits naturally (for example, in table cells).
- Rewrite the sentence if none of the above fits.

**Exception:** Use an em dash in blockquote attribution lines (e.g. `> — Author Name`). A plain hyphen in this position is parsed by Markdown renderers as a bullet point, which is incorrect. This is the only permitted use of an em dash.

### Line Length

Wrap all prose lines at 90 characters. Break at word boundaries only; never break
within a word. Markdown table rows and URLs are exempt — they must remain on a single
line and may exceed 90 characters.

### Formal Mathematical Language

Use formal mathematical language whenever describing:
- Mathematical properties or proofs
- Algorithm complexity
- Configuration ranges
- Threshold values
- Any numeric constraint or bound

**Required forms:**

| Instead of | Write |
|---|---|
| "values between 0 and 1" | "For values in the range [0, 1)" |
| "x should be positive" | "Let x be a positive integer" |
| "if both X and Y are true" | "X holds if and only if Y holds" |
| "for any given Y" | "For a given Y" |
| "runs in n log n time" | "For an input of size n, the algorithm runs in O(n log n) time" |

Use standard interval notation: `[a, b]` for inclusive, `(a, b)` for exclusive, `[a, b)` for half-open.

---

## Step 3: Style and Tone Matching

When existing documentation is present, match it precisely across all dimensions:

- **Prose tone and vocabulary** — formal vs. conversational, dense vs. airy, passive vs. active voice
- **Structure and formatting** — heading levels, use of bullet points vs. numbered lists vs. prose, table usage, code block conventions
- **Section organisation** — how topics are introduced, how examples are presented, how caveats are noted
- **Paragraph length** — short and punchy vs. longer and expository

Do not impose a different style simply because it seems cleaner or more correct. Consistency with the existing corpus takes priority, except where these rules explicitly override it (e.g. British English and mathematical language always apply).

---

## Step 4: Editing Existing Documentation

When editing an existing file:

1. Ask upfront whether to fix rule violations across the whole file or only within the affected section.
2. If correcting the whole file: apply all rules systematically before making the requested content changes. Note what was changed and why.
3. If correcting only the section: apply all rules within your edit boundary only. Do not silently fix things outside it.
4. Never silently change content outside the agreed scope.

---

## Quick Reference Checklist

Before submitting any documentation, verify:

- [ ] British English spellings used throughout (except code references and domain terms)
- [ ] No em dashes present anywhere in prose (blockquote attributions are the only permitted exception)
- [ ] All prose lines wrap at 90 characters (table rows and URLs are exempt)
- [ ] All numeric ranges and thresholds use formal mathematical notation
- [ ] Mathematical and algorithmic descriptions use formal language (`Let x be...`, `For a given...`, `if and only if`, `O(...)`)
- [ ] Tone, structure, and formatting match existing documentation (or the user-specified tone if new)
- [ ] Code references, config keys, CLI flags, and quoted output are left unmodified

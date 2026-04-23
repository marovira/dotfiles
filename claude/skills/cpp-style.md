---
name: cpp-style
description: >
  C++ coding style and workflow guide. Use this skill whenever writing, editing,
  or reviewing C++ code. Triggers include: creating new .cpp or .hpp files,
  adding classes or functions, refactoring existing C++ code, reviewing code for
  style, or any task involving C++ in this project. Always consult this skill
  before producing any C++ code — do not rely on general C++ conventions alone.
---

# C++ Style Guide

This skill defines the coding standards, style rules, and tooling workflow for
all C++ code in this project. Follow every rule here unless the user explicitly
overrides it for a specific task.

---

## Tooling Workflow

The project uses two mandatory tools. Always run both after writing or modifying
any C++ file:

1. **Format** with `clang-format`:
   ```bash
   clang-format -i <file>
   ```

2. **Lint** with `clang-tidy`:
   ```bash
   clang-tidy <file>
   ```

Assume that `.clang-format` and `.clang-tidy` configuration files exist at the
project root. Do not pass custom flags — let the project config drive both tools.

**Target standard: C++20** unless the user specifies otherwise.

---

## File Naming & Structure

- All file names use `snake_case`
- Source files: `.cpp` extension
- Header files: `.hpp` extension
- Examples: `widget_factory.cpp`, `render_pipeline.hpp`

### Header Guard

Always use `#pragma once`. Never use `#ifndef` include guards.

```cpp
#pragma once

// header content
```

---

## Naming Conventions

| Entity | Convention | Example |
|---|---|---|
| Classes, structs, enums, type aliases, template type params | `PascalCase` | `RenderPipeline`, `VertexBuffer` |
| Functions, variables, function arguments, global variables, enum values | `snake_case` | `compute_normals()`, `vertex_count` |
| Macros | `SCREAMING_SNAKE_CASE` | `MAX_BUFFER_SIZE` |
| Private member variables | `m_` prefix + `snake_case` | `m_vertex_count` |

The `m_` prefix is the **only** permitted variable prefix. Do not use `s_`, `g_`,
`p_`, or any other prefix.

The `m_` prefix applies **only** to private data members of classes. Structs are
plain data holders and do not use `m_`.

```cpp
// Correct
class RenderPipeline {
public:
    int vertex_count() const { return m_vertex_count; }
private:
    int m_vertex_count{0};
};

// Correct — struct, no prefix
struct Vertex {
    float x{0.0f};
    float y{0.0f};
    float z{0.0f};
};
```

---

## Const Style

This project uses a **deliberate split** — do not "fix" either rule or apply one
style everywhere:

- **Function arguments**: const-on-the-right (east const)
  ```cpp
  void process(Widget const& w, int const count);
  ```

- **Variable declarations**: const-on-the-left (west const)
  ```cpp
  const int max_count{100};
  const std::string name{"pipeline"};
  ```

The rationale: function arguments frequently involve references and pointers,
where east const reads more naturally (`T const*` vs `const T*`). Local variable
declarations are simpler and read more naturally with west const.

---

## Braced Initialisation

Prefer braced initialisation for all variable declarations:

```cpp
// Preferred
int count{0};
std::string name{"hello"};
MyStruct s{1, 2, 3};

// Avoid
int count = 0;
std::string name = "hello";
```

**Exception**: Do not use braced initialisation when it would invoke an
`std::initializer_list` constructor unintentionally, changing the meaning of the
expression:

```cpp
// Dangerous — calls initializer_list ctor, gives a 1-element vector
std::vector<int> v{3};

// Correct — gives a 3-element vector
std::vector<int> v(3);
```

In general: use braced init everywhere it is unambiguous; fall back to
parentheses when braces would change the semantics.

---

## `auto`

Use `auto` in the following situations:

1. **Type is explicit on the right-hand side:**
   ```cpp
   auto x = static_cast<int>(some_float);
   auto ptr = std::make_unique<RenderPipeline>();
   ```

2. **Type is easily inferred from the right-hand side** (from template arguments
   or the function name itself):
   ```cpp
   auto result = compute_bounding_box(vertices);  // return type obvious from name
   auto it = vertex_map.find(key);
   ```

3. **Type is verbose, hard to write, or uses lazy evaluation:**
   ```cpp
   auto it = some_map.begin();          // iterator
   auto fn = [](int x) { return x*2; }; // lambda
   auto expr = mat_a * mat_b + mat_c;   // Eigen lazy expression
   ```

4. **Template functions**, where the type cannot be expressed concretely, or
   **return types** where the return type depends on a template argument and
   cannot be expressed explicitly:
   ```cpp
   template<typename T>
   auto transform(T const& val) -> decltype(val.compute()) { ... }
   ```

Do not use `auto` merely to avoid typing a known, short type.

---

## Pointers & Memory

- **Prefer references** over pointers wherever possible.
- **Always use smart pointers.** Never use raw `new` or `delete`.
- Prefer `std::unique_ptr` to express ownership. Use `std::shared_ptr` only when
  shared ownership is genuinely required.
- Always construct smart pointers with `std::make_unique` / `std::make_shared`.

```cpp
// Correct
auto pipeline = std::make_unique<RenderPipeline>();
auto shared = std::make_shared<TextureCache>();

// Never
RenderPipeline* pipeline = new RenderPipeline();
delete pipeline;
```

---

## Header Includes

Headers are divided into three groups, separated by a blank line, in this order:

1. **Local** — project headers, using `"quotes"`
2. **Third-party** — external libraries, using `<angle brackets>`
3. **STL** — standard library, using `<angle brackets>`

Adhere to *include what you use*: include every header you directly depend on,
and do not rely on transitive includes.

```cpp
#include "renderer/render_pipeline.hpp"
#include "utils/math_helpers.hpp"

#include <glm/glm.hpp>
#include <spdlog/spdlog.h>

#include <cstdint>
#include <memory>
#include <vector>
```

---

## Quick Reference Checklist

Before finalising any C++ file, verify:

- [ ] File name is `snake_case` with `.cpp` / `.hpp` extension
- [ ] Header files begin with `#pragma once`
- [ ] All types are `PascalCase`, all functions/variables are `snake_case`
- [ ] Private class members have `m_` prefix; struct members do not
- [ ] Function arguments use east const (`T const&`); variable declarations use west const (`const T`)
- [ ] Braced initialisation used where unambiguous
- [ ] No raw `new`/`delete`; smart pointers constructed with `make_unique`/`make_shared`
- [ ] `auto` used only in the permitted cases
- [ ] Includes are in three groups: local → third-party → STL
- [ ] `clang-format` has been run
- [ ] `clang-tidy` has been run

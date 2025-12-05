# Spike 01: Elixir Basics - Deep Summary

**Date**: 2024-12-04
**Branch**: spike/01-basics
**Files Created**: `spikes/01-basics/hello.exs`

---

## Part 1: Mental Model Evolution

### Starting Point: The C-Style Mental Model

The conversation began with a simple warning from Elixir:

```
warning: variable "x" is unused
```

This arose from code that rebinds a variable:

```elixir
x = 1
x = 2
```

The initial question revealed a C-style mental model:

> "Is x correlated with a space in memory? So that the initial x=1 reserves a place in memory for both the name of the variable x and the value 1?"

This question assumes variables **are** memory locations - that `x` is an address, and `x = 1` puts the value 1 at that address.

### The Incorrect Model (C-Style)

```
x = 1    →  x is a memory ADDRESS. Value 1 lives at that address.
x = 2    →  Overwrite the value at that address with 2.
```

In this model:
- Variables are containers
- Assignment mutates the container's contents
- The variable "x" persists as a fixed memory location

### The Correct Model (Elixir/Functional)

```
x = 1    →  x is a NAME bound to value 1. Value 1 exists somewhere in memory.
x = 2    →  x is now a NAME bound to value 2. Value 1 still exists (until garbage collected).
```

In this model:
- Variables are bindings (associations between names and values)
- "Assignment" creates new bindings, doesn't mutate
- The name "x" can be rebound to point at different values
- Old values aren't overwritten - they become orphaned and eventually garbage collected

### The Intermediate Incorrect Model

A second mental model emerged mid-conversation:

> "We can imagine that a byte that the BEAM knows how to identify as type:integer with value 1 was placed on the BEAM heap, and then the compiler placed in its symbol table a 'name' reference to that part of the heap, and the binding was that association in the symbol table..."

This model correctly grasped:
- Values live on the BEAM heap
- There's an association between names and values

But incorrectly assumed:
- The symbol table exists at runtime
- The symbol table contains pointers to heap memory
- Bindings are runtime data structures

### The Final Correct Model: Two Separate Phases

**Compile time and runtime are separate worlds.**

#### Compile Time (Symbol Table Exists Here)

```
Source code → Compiler → BEAM bytecode
                ↓
         Symbol table (temporary)
         - tracks: "x is bound at line 22"
         - tracks: "x is rebound at line 23 before being read"
         - emits warning
         - then THROWN AWAY
```

The symbol table is a **compiler's scratch pad** for static analysis. It:
- Tracks which variable names are bound
- Detects unused bindings (warns about them)
- Does NOT exist at runtime
- Does NOT contain pointers to heap memory

#### Runtime (BEAM Heap Exists Here)

```
BEAM bytecode → BEAM VM → execution
                  ↓
            Values on heap
            Registers (x0, x1, x2...)
            NO variable names
            NO symbol table
```

At runtime:
- Variable names don't exist
- They've been compiled into numbered registers
- Instructions reference registers, not names

#### How Variables Become Registers

Source code:
```elixir
x = 1
y = x
x = 2
IO.puts(y)
```

Compiles to something like:
```
move 1, {x, 0}           # put value 1 in register x0
move {x, 0}, {x, 1}      # copy x0 to x1 (this is "y")
move 2, {x, 0}           # put value 2 in x0 (rebinding)
call IO.puts with {x, 1}
```

No "x" or "y" strings - just numbered registers (x0, x1, etc.).

You can verify this by disassembling a module:
```elixir
defmodule Example do
  def test do
    x = 1
    y = x
    x = 2
    y
  end
end

:erts_debug.df(Example)  # Creates Example.dis file
```

---

## Part 2: The Warning Explained

When Elixir shows:

```
warning: variable "x" is unused (there is a variable with the same name in the context,
use the pin operator (^) to match on it or prefix this variable with underscore if it
is not meant to be used)
```

It's saying: "The first binding of x (to value 1) was never read before x was rebound to 2."

The compiler detected this through **static analysis** - walking through the source code and tracking which bindings are read vs shadowed.

### The Warning Offers Two Options

These are NOT ways to access the old binding. They express different programmer intents:

---

## Part 3: Underscore Prefix (`_variable`)

### What It Does

Tells the compiler: "I know this binding won't be used. Don't warn me."

```elixir
x = 1
_x = 2    # No warning - underscore signals intentional discard
```

### It Does NOT:
- Access the old binding
- Change runtime behavior
- Preserve anything

It's purely a **naming convention** that silences warnings.

### When You'll Use It (Very Common)

**Destructuring when you only need some values:**
```elixir
# Only care about status, not the contents
{:ok, _result} = File.read("file.txt")

# Only care about the head of a list
[first | _rest] = [1, 2, 3, 4, 5]

# Ignore a function argument
def handle_click(_event, state), do: state
```

**You'll write `_` or `_something` many times per file.** It's idiomatic Elixir.

---

## Part 4: Pin Operator (`^variable`)

### What It Does

Changes `=` from "bind" to "assert match":

```elixir
x = 1
x = 2     # Rebinds x to 2
^x = 2    # Asserts: "the right side must equal x's current value"
```

### Demonstration

```elixir
x = 1
^x = 1    # Works - 1 matches 1
^x = 2    # CRASHES - MatchError, 1 does not match 2
```

### Why It Exists

In Elixir, `=` does double duty:
1. **Binding**: `x = 1` creates a binding
2. **Pattern matching**: `{a, b} = {1, 2}` destructures

The pin operator disambiguates:
```elixir
x = 1
{x, y} = {2, 3}    # x is REBOUND to 2
{^x, y} = {2, 3}   # x must MATCH 2 (crashes if x isn't 2)
```

### When You'll Use It (Common in Pattern Matching)

**Case statements matching against a known value:**
```elixir
expected_id = 42

case user do
  %{id: ^expected_id} -> "Found the right user"
  _ -> "Not the one we're looking for"
end
```

**Function heads:**
```elixir
def process(%{type: ^expected_type}, state) do
  # Only matches if type equals expected_type
end
```

**Less frequent than `_`, but common in non-trivial codebases.**

---

## Part 5: BEAM Memory Model (Simplified)

### Small Integers: Immediates

For small integers, BEAM uses a trick - the value is stored directly in what would normally be a pointer:

```
┌─────────────────────────┐
│ tag bits │ value bits   │  ← All in one machine word
└─────────────────────────┘
```

No heap allocation needed.

### Larger Values: Heap Allocated

```
┌─────────────────────────┐
│ tag bits │ heap pointer │  → points to data on BEAM heap
└─────────────────────────┘
```

### Key Point

You never think about this in Elixir. There are:
- No pointers to manipulate
- No malloc/free
- No memory addresses to reason about

The BEAM handles it all. This abstraction enables BEAM's fault tolerance and concurrency guarantees.

---

## Part 6: Basic Elixir Syntax Covered

### Types
```elixir
integer = 42        # Arbitrary precision (no overflow)
float = 3.14        # 64-bit double precision
string = "hello"    # UTF-8 encoded, double quotes only
atom = :ok          # Named constant, like Ruby symbols
boolean = true      # Actually atoms :true and :false
```

### String Interpolation
```elixir
name = "world"
IO.puts("Hello, #{name}!")  # #{} embeds any expression
```

### Division
```elixir
5 / 3       # 1.666... (ALWAYS returns float)
div(5, 3)   # 1 (integer division)
rem(5, 3)   # 2 (remainder/modulo)
```

---

## Key Takeaways

1. **Variables are bindings, not containers** - rebinding creates new associations, doesn't mutate

2. **Compile time ≠ runtime** - symbol table is for the compiler's analysis, then discarded; runtime has registers and heap, no variable names

3. **`=` does double duty** - binding AND pattern matching; pin operator (`^`) forces match-only

4. **Underscore prefix (`_var`)** - naming convention to silence "unused variable" warnings

5. **BEAM abstracts memory** - no pointers, no addresses, just values; enables fault tolerance

---

## CC Patterns Also Learned This Session

- Determinism vs context cost tradeoff
- Slash command `!`backtick`` syntax injects into Claude's context, not user display
- Adding confirmation instructions to slash commands for user visibility
- Progressive disclosure: link with "read when" triggers

---

## Next Spike

**02-pattern-match**: Deep dive into `=` as pattern matching, destructuring tuples/lists/maps, case statements, function head matching.

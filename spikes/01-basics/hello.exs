# Spike 01: Elixir Basics
# Run with: elixir spikes/01-basics/hello.exs
# Or explore interactively: iex

# --- Output ---
IO.puts("Hello, Elixir!")

# --- Basic Types ---
integer = 42
float = 3.14
string = "hello"
atom = :ok
boolean = true

IO.puts("Integer: #{integer}")
IO.puts("Float: #{float}")
IO.puts("String: #{string}")
IO.puts("Atom: #{atom}")
IO.puts("Boolean: #{boolean}")

# --- Immutability ---
x = 1
x = 2  # This isn't mutation - it's rebinding
IO.puts("x is now: #{x}")

# --- Basic Operators ---
IO.puts("5 + 3 = #{5 + 3}")
IO.puts("5 - 3 = #{5 - 3}")
IO.puts("5 * 3 = #{5 * 3}")
IO.puts("5 / 3 = #{5 / 3}")      # Always returns float
IO.puts("div(5, 3) = #{div(5, 3)}")  # Integer division
IO.puts("rem(5, 3) = #{rem(5, 3)}")  # Remainder

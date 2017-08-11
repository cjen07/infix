# Infix

## insert a line to a given function in compile-time

```elixir
  use Infix

  def foo1() do
    IO.puts "a"
    IO.puts "b"
    IO.puts "d"
    :ok
  end

  def foo2() do
    IO.puts "a"
    IO.puts "b"
    IO.puts "c"
    IO.puts "d"
    :ok
  end

  def foo3() do
    # same as foo2
    :foo1 |||3> 'IO.puts "c"'
  end
```

## trace a given variable in a given function and module

```elixir
  defmodule X do
    def y(h) do
      a = 1
      b = 2
      c = h
      c = :math.pow(c, 2)
      a + b + c
    end
  end

  defmodule Y do
    def x(h) do
      a = 1
      b = 2
      c = h
      c = :math.pow(c, 2)
      a + b + c
    end

    def y(h) do
      a = 1
      b = 2
      c = h
      c = :math.pow(c, 2)
      a + b + c
    end

    def z(h) do
      a = 1
      b = 2
      c = h
      c = :math.pow(c, 2)
      a + b + c
    end
  end

  defmodule Z do
    def y(h) do
      a = 1
      b = 2
      c = h
      c = :math.pow(c, 2)
      a + b + c
    end
  end
```

```elixir
  defmodule Test do

    def run(h) do
      Trace.setup(:Y, :y, :c)
      IO.inspect Y.y(h) 
      IO.inspect Trace.pry(:Y, :y, :c)
      :ok
    end
    # Test.run(5)
    # => 28.0
    # => [5, 25.0]
    # => :ok
  end
```

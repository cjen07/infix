defmodule Q do
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
  
end
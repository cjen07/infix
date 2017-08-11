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
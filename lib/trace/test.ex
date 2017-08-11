defmodule Test do

  def run(h) do
    Trace.setup(:Y, :y, :c)
    IO.inspect Y.y(h)
    IO.inspect Trace.pry(:Y, :y, :c)
    :ok
  end
  
end
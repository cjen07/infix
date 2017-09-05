defmodule Move2 do

  def f(n, x) do
    k = n + x
    Enum.drop(0..x, 1)
    |> Enum.reduce({k, [{k, n}]}, fn x, {y, l} -> 
      z = k - x
      {z, [{z, y} | l]}
    end)
    |> elem(1)
  end

  def g(s, n, x) do
    l = f(n, x)
    case x == 0 do
      true -> s
      false ->
        cond do
          s == %{} -> Map.new(l)
          true ->
            Enum.reduce(l, {s, []}, fn {a, b}, {s, l} -> 
              case Map.get(s, b) do
                nil -> {s, [{a, b} | l]}
                c -> 
                  case c == a do
                    true -> {Map.delete(s, b), l}
                    false -> {Map.delete(s, b), [{a, c} | l]}
                  end
              end
            end)
            |> (fn {x, y} -> Map.merge(x, Map.new(y)) end).()  
        end
    end
  end

  def start(n) do
    l = 1..n
    s = Map.new()
    case Agent.start_link(fn -> {l, s} end, name: __MODULE__) do
      {:ok, _} -> 
        :ok
      _ ->
        Agent.update(__MODULE__, fn _ -> {l, s} end)
    end
  end

  def move(n, x) do
    Agent.update(__MODULE__, fn {l, s} ->
      {l, g(s, n, x)} 
    end)
  end

  def show() do
    Agent.get(__MODULE__, fn x -> x end)
    |> (fn {l, s} ->
        Enum.map(l, fn y -> 
          case Map.get(s, y) do
            nil -> y
            z -> z
          end
        end) 
    end).()
  end
end
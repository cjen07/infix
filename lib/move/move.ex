defmodule Move do

  def f(k, n, x) do
    cond do
      x > 0 ->
        cond do
          k < n -> k
          k > n + x -> k
          k == n -> k + x
          true -> k - 1
        end
      x < 0 ->
        cond do
          k > n -> k
          k < n + x -> k
          k == n -> k + x
          true -> k + 1
        end
      true ->
        k
    end
  end

  def init(n) do
    Enum.map(1..n, fn x -> {x, x} end)
  end

  def start(n) do
    l = init(n)
    case Agent.start_link(fn -> {l, []} end, name: __MODULE__) do
      {:ok, _} -> 
        :ok
      _ ->
        Agent.update(__MODULE__, fn _ -> {l, []} end)
    end
  end

  def move(n, k) do
    Agent.update(__MODULE__, fn {l, as} -> {l, [{n, k} | as]} end)
  end

  def save() do
    Agent.update(__MODULE__, fn {l, as} -> 
      Enum.reverse(as)
      |> Enum.reduce(l, fn {n, x}, acc -> 
        Enum.map(acc, fn {k, v} -> {f(k, n, x) , v} end)
      end)
      |> Enum.sort(fn x, y -> elem(x, 0) < elem(y, 0) end)
      |> (fn x -> {x, []} end).()
    end)
  end

  def back() do
    Agent.update(__MODULE__, fn {l, as} -> {l, Enum.drop(as, 1)} end)
  end

  def show() do
    Agent.get(__MODULE__, fn x -> x end)
    |> (fn {l, as} ->
      Enum.reverse(as)
      |> Enum.reduce(l, fn {n, x}, acc -> 
        Enum.map(acc, fn {k, v} -> {f(k, n, x) , v} end)
      end)
    end).()
    |> Enum.sort(fn x, y -> elem(x, 0) < elem(y, 0) end)
    |> Enum.map(fn x -> elem(x, 1) end)
  end
end
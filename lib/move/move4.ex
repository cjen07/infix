defmodule Move4 do

  # in iex:
  # import Move4
  # start 10
  # move 3, 4
  # move 5, -3
  # show

  def get(pid) do
    x = Agent.get(pid, fn x -> x end)
    Agent.stop(pid)
    x    
  end

  def init(a, b) do
    name = :"#{b}"
    case Agent.start_link(fn -> {a, b} end, name: name) do
      {:ok, pid} -> 
        pid
      {:error, {:already_started, pid}} ->
        Agent.update(name, fn _ -> {a, b} end)
        pid
    end
  end

  def set(a, b) do
    name = :"#{a}"
    case Agent.start_link(fn -> {a, b} end, name: name) do
      {:ok, pid} -> 
        [pid]
      _ ->
        Agent.update(name, fn {a, _} -> {a, b} end)
        []
    end
  end

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
          s == [] -> l
          true ->
            l = Enum.map(l, fn {a, b} -> init(a, b) end)
            s = Enum.flat_map(s, fn {a, b} -> set(a, b) end)
            Enum.map(s ++ l, fn x -> get(x) end)
        end
    end
  end

  def start(m) do
    case Agent.start_link(fn -> {m, []} end, name: __MODULE__) do
      {:ok, _} -> 
        :ok
      _ ->
        Agent.update(__MODULE__, fn _ -> {m, []} end)
    end
  end

  def move(n, x) do
    Agent.update(__MODULE__, fn {m, s} ->
      {m, g(s, n, x)} 
    end)
  end

  def show() do
    Agent.get(__MODULE__, fn x -> x end)
    |> (fn {m, s} ->
        l = Enum.map(1..m, fn x -> init(x, x) end)
        Enum.each(s, fn {a, b} -> set(a, b) end)
        Enum.map(l, fn x -> elem(get(x), 1) end) 
    end).()
  end
end
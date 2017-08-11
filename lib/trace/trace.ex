defmodule Trace do

  def search(f, t) do
    apply(Trace, :"#{t}_wrapper", [f]) |> :os.cmd()
  end

  def f_wrapper(f) do
    'ag "def[ ]*' ++ String.to_charlist("#{f}") ++ '\\(" lib/'
  end

  def m_wrapper(m) do
    'ag "defmodule[ ]*' ++ String.to_charlist("#{m}") ++ '[ ]*do" lib/'
  end

  def start_agent(name) do
    case Agent.start_link(fn -> [] end, name: name) do
      {:ok, _} -> 
        :ok
      _ ->
        Agent.update(name, fn _ -> [] end)
    end
  end

  def max_line(ast) do
    Macro.prewalk(ast, -1, fn x, acc -> 
      case x do
        {_, [line: l], _} ->
          {x, max(l, acc)}
        _ ->
          {x, acc}
      end
    end)
    |> elem(1)
  end

  def pry(m, f, v) do
    name = :"#{m}_#{f}_#{v}"
    Agent.get(name, fn x -> x end)
    |> Enum.reverse()
  end

  def setup(m, f, v) do
    Code.compiler_options(ignore_module_conflict: true)
    name = :"#{m}_#{f}_#{v}"
    :ok = start_agent(name)
    m1 = 
      search(m, :m)
      |> to_string()
      |> String.split(":")
      |> Enum.at(0)
    if m1 == "" do
      throw("module not found")
    end
    # is there a way to assign a variable within the pipe operator
    file = File.read!(m1)
    file
    |> Code.string_to_quoted()
    |> elem(1)
    |> Macro.prewalk({:s1, []}, fn x, {s, t} ->
      case s do
        :s0 ->
          {x, {:s0, t}}
        :s1 ->
          case x do
            {:defmodule, _, _} ->
              {x, {:t0, t}}
            _ ->
              {x, {:s1, t}}
          end
        :t0 ->
          {x, {:t1, t}}
        :t1 ->
          case x do
            ^m -> 
              {x, {:s2, t}}
            _ -> 
              {x, {:s1, t}}
          end
        :s2 ->
          case x do
            {:def, _, _} -> 
              f1 =
                elem(x, 2)
                |> Enum.at(0)
                |> elem(0)
              case f1 do
                ^f -> 
                  {x, {:s3, t}}
                _ ->
                  {x, {:s2, t}}
              end
            {:defmodule, _, _} ->
              {x, {:s0, t}}
            _ ->
              {x, {:s2, t}}
          end
        :s3 ->
          case x do
            {:=, _, _} ->
              v1 =
                elem(x, 2)
                |> Enum.at(0)
                |> elem(0)
              case v1 do
                ^v -> 
                  {x, {:s3, [max_line(x) | t]}}
                _ ->
                  {x, {:s3, t}}
              end
            {:def, _, _} -> 
              f1 =
                elem(x, 2)
                |> Enum.at(0)
                |> elem(0)
              case f1 do
                ^f -> 
                  {x, {:s3, t}}
                _ ->
                  {x, {:s2, t}}
              end
            {:defmodule, _, _} ->
              {x, {:s0, t}}
            _ ->
              {x, {:s3, t}}
          end
      end
    end)
    |> elem(1)
    |> elem(1)
    |> Enum.reduce(file, fn l, acc -> 
      String.split(acc, "\n")
      |> List.update_at(l-1, fn x -> 
        x <> "\n    :ok = Agent.update(:#{name}, fn x -> [#{v} | x] end)"
      end)
      |> Enum.join("\n")
    end)
    |> Code.compile_string()
    :ok
  end

end
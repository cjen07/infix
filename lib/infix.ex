defmodule Infix do

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [{:|||, 2}]
    end
  end

  defmacro left ||| right do
    [p, d] = elem(right, 2)
    quote bind_quoted: [f: left, p: p, d: d] do
      file =
        __MODULE__
        |> to_string()
        |> String.split(".")
        |> Enum.at(-1)
        # better module-to-filename mechanism
        |> String.downcase()
        |> (&("lib/" <> &1 <> ".ex")).() 
        |> File.read!()
      {l0, l1} = 
        file
        |> Code.string_to_quoted()
        |> elem(1)
        |> Macro.prewalk({:s1, {0, 0}}, fn x, {s, t} ->
          case s do
            :s0 ->
              {x, {:s0, t}}
            :s1 ->
              case x do
                {:def, _, _} ->
                  {x, {:s2, t}}
                _ ->
                  {x, {:s1, t}}
              end
            :s2 ->
              case x do
                {^f, [line: l], _} ->
                  {x, {:s3, {l, 0}}}
                _ ->
                  {x, {:s1, t}}
              end
            :s3 ->
              case x do
                {:def, [line: l], _} ->
                  {x, {:s0, t}}
                {_, [line: l], _} ->
                  {e1, e2} = t
                  {x, {:s3, {e1, max(e2, l)}}}
                _ ->
                  {x, {:s3, t}}
              end
          end
        end)
        |> elem(1)
        |> elem(1)
      String.split(file, "\n")
      |> Enum.take(l1)
      |> Enum.drop(l0)
      |> Enum.split(p-1)
      |> (fn {x, y} -> x ++ [d] ++ y end).()
      |> Enum.join("\n")
      |> Code.compile_string()
      :ok
    end
  end
  
end

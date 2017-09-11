# this is very complex!

# defmodule Move3 do
#   def get(pid) do
#     Agent.get(pid, fn x -> x end)
#   end

#   def init(i) do
#     name = :"#{i}"
#     case Agent.start_link(fn -> :nothing end, name: name) do
#       {:ok, pid} -> 
#         pid
#       {:error, {:already_started, pid}} ->
#         Agent.update(name, fn x -> x end)
#         pid
#     end
#   end

#   def set(i, value) do
#     name = :"#{i}"
#     Agent.update(name, fn _ -> value end)
#   end

#   def f(n, x, m) do
#     n1 = n + x
#     cond do
#       n1 > m || n1 < 0 ->
#         IO.puts "out_of_bound"
#         []
#       true ->
#         cond do
#           x > 0 ->
#             [{{n, n1-1}, 1}, {n1, n}]
#           x < 0 ->
#             [{n1, n}, {{n1+1, n}, -1}]
#           true ->
#             []    
#         end
#     end
#   end

#   def g(s, n, x, m) do
#     l = f(n, x, m)
#     case x == 0 do
#       true -> s
#       false ->
#         cond do
#           s == [] -> l
#           true -> merge(s, l)
#         end
#     end
#   end

#   def match(x, [h | s], l) do
#     do_match(x, h, s, l)
#   end

#   def do_match(nil, h, s, l) do
#     {[h | s], l}
#   end

#   def do_match({k, v}, nil, [], l) do
#     case k do
#       {a, b}
#     end
#     {[], [init(x) | l]}
#   end

#   def merge(s, l) do
#     Enum.reduce(l, {s, []}, fn x, {s, l} -> 
#       case s do
#         [] ->
#           [x | l]
#         _ -> 
#           match(x, s, l)
#           # [h | t] = s;
#           # match(h, x)
#           Enum.reduce_while(s, {x, l}}, fn {k1, v1}, {{k2, v2}, l} -> 
#             case k1 do
#               {a1, b1} -> 
#                 case k2 do
#                   {a2, b2} ->
#                     :ok
#                   _ ->
#                     :ok
#                 end
#               _ ->
#                 case k2 do
#                   {a2, b2} ->
#                     :ok
#                   _ ->
#                     cond do
#                       k2 < k1 -> 
#                         {:halt, {}}
#                     end
#                     :ok
#                 end
#             end
#           end)
#       end
#     end)
#     |> Enum.reverse()
#   end

#   def start(m) do
#     case Agent.start_link(fn -> {m, []} end, name: __MODULE__) do
#       {:ok, _} -> 
#         :ok
#       _ ->
#         Agent.update(__MODULE__, fn _ -> {m, []} end)
#     end
#   end

#   def move(n, x) do
#     Agent.update(__MODULE__, fn {m, s} -> {m, g(s, n, x, m)} end)
#   end

#   def show() do
#     Agent.get(__MODULE__, fn x -> x end)
#     |> (fn {m, s} ->
#         case s do
#           [{k, v} | t] -> 
#             init = i(k, v, 1, [])
#             Enum.reduce(t, init, fn {k, v}, {i, l} -> 
#               i(k, v, i, l)
#             end)
#             |> (fn {i, l} -> 
#               case i > m do
#                 true -> l
#                 false -> [h(m..i) | l]
#               end
#             end).()
#             |> List.flatten()
#             |> Enum.reverse()
#             |> Enum.take(m)
#           _ -> 
#             h(1..m)
#         end
#     end).()
#   end

#   def h(r) do
#     Enum.map(r, fn x -> x end)
#   end

#   def i(k, v, i, l) do
#     case k do
#       {a, b} -> {a, b, Enum.map(b..a, fn x -> x + v end)}
#       _ -> {k, k, [v]}
#     end
#     |> (fn {a, b, l1} -> 
#       cond do
#         a > i -> [[l1, h(a-1..i)] | l]
#         true -> [l1 | l]
#       end
#       |> (fn x -> {b + 1, x} end).()
#     end).()
#   end 
# end
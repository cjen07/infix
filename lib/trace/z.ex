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
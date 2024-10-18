defmodule Secrets do
  def secret_add(secret) do
    fn add -> add + secret end
  end

  def secret_subtract(secret) do
    fn subtract -> subtract - secret end
  end

  def secret_multiply(secret) do
    fn multiply -> multiply * secret end
  end

  def secret_divide(secret) do
    fn divide -> div(divide, secret) end
  end

  def secret_and(secret) do
    fn fand -> Bitwise.band(fand, secret) end
  end

  def secret_xor(secret) do
    fn fxor -> Bitwise.bxor(fxor, secret) end
  end

  def secret_combine(secret_function1, secret_function2) do
    # what  pipe does is get the result of an expression and pass the result ahead
    # e.g the result of secret_function1 with x as argument go to secret
    fn x -> secret_function1.(x) |> secret_function2.() end
  end
end

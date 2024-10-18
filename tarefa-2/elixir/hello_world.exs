defmodule HelloWorld do
  @doc """
  Create a function with arity 0 and simply returns "Hello, World!"
  """
  @spec hello :: String.t()
  def hello do
    "Hello, World!"
  end
end

# print the function return in console
IO.puts(HelloWorld.hello())


defmodule Constants do
  @moduledoc """
  Copyright © Stephen Pallen AKA smpallen99
  """

  defmacro __using__(_opts) do
    quote do
      import Constants
    end
  end

  defmacro constant(name, value) do
    quote do
      defmacro unquote(name), do: unquote(value)
    end
  end

  defmacro define(name, value) do
    quote do
      constant(unquote(name), unquote(value))
    end
  end
end

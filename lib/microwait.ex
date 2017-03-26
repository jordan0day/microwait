defmodule Microwait do
  require Logger

  @doc """
  Wait for *at least* the specified number of microseconds. When running on a
  single-core computer such as a Raspberry Pi Zero, you may wish to pass an
  optional second parameter of `yield: true` which *may* improve performance.

  Examples:
  iex> {duration, :ok} = :timer.tc(Microwait, :wait_micros, [500])
  iex> duration >= 500
  true

  iex> {duration, :ok} = :timer.tc(Microwait, :wait_micros, [837, [yield: true]])
  iex> duration >= 837
  true
  """
  @spec wait_micros(non_neg_integer(), [yield: boolean()] | []) :: :ok
  def wait_micros(amount, opts \\ []) do
    now = System.monotonic_time(:microseconds)

    case Keyword.get(opts, :yield, nil) do
      true  -> wait_with_yield(now, amount)
      _     -> wait_no_yield(now, amount)
    end
  end

  @spec wait_with_yield(non_neg_integer(), non_neg_integer()) :: :ok
  defp wait_with_yield(start, amount) do
    now = System.monotonic_time(:microseconds)

    if now - start >= amount do
      :ok
    else
      :erlang.yield()
      wait_with_yield(start, amount)
    end
  end

  @spec wait_no_yield(non_neg_integer(), non_neg_integer()) :: :ok
  defp wait_no_yield(start, amount) do
    now = System.monotonic_time(:microseconds)

    if now - start >= amount do
      :ok
    else
      wait_no_yield(start, amount)
    end
  end
end

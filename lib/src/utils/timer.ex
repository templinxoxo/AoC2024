defmodule Aoc.Utils.Timer do
  def time(fun, opts \\ []) do
    interval = Keyword.get(opts, :interval, :seconds)
    label = Keyword.get(opts, :label, "Function")

    {time, result} = :timer.tc(fn -> fun.() end, interval)

    IO.puts("#{label} run in #{time}[#{interval}]")

    result
  end
end

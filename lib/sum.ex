defmodule ParallelSum.Sum do
  @moduledoc """
    各プロセスに実行させるためのsum関数(再帰とEnum.sum())
  """

  @doc """
    Task function: 再帰関数によって合計値を算出する関数
  """
  def recurcive_sum(lst) when is_list(lst) do
    _recurcive_sum(lst, 0)
  end
  defp _recurcive_sum([], acc), do: acc
  defp _recurcive_sum([head | tail], acc) do
    _recurcive_sum(tail, acc + head)
  end

  @doc """
    Task function: BIMのsumによって合計値を算出するwrap関数
  """
  def sum([]), do: 0
  def sum(lst) when is_list(lst) do
    Enum.sum(lst)
  end
end

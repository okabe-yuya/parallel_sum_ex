defmodule ParallelSum.DataCreater do
  @moduledoc """
    N個のランダム値を要素に持つ配列を作成するための関数群
  """

  @doc """
    ランダム値を生成するためのErlang関数をwrapする関数
  """
  def create_random_num() do
    # 上限値を取得 -> 毎回取得するのは負荷になるのでその内改善
    limit = ParallelSum.Config.random_limit_num()
    :random.uniform(limit)
  end

  @doc """
    N個のランダム要素を持つ配列を作成する関数。neg値が来た場合に:errorを返す
  """
  def create_N_size_list(n) when n > 0 do
    Enum.map(1..n, fn _ -> create_random_num() end)
  end
  def create_N_size_list(), do: :error
end

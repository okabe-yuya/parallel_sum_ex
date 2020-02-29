defmodule ParallelSum.Config do
  @moduledoc """
    定数群。設定値など
  """
  # ランダム値生成時の上限値(パフォーマンチ安定化のため)
  def random_limit_num(), do: 1000
  # 1プロセス値にいくつの要素を持つチャンクを与えるかの最大値(測定のため値は控えめに)
  def each_chunk_list_size_limit(), do: 100
end

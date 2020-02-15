defmodule ParallelSum.Scheduler do
  @moduledoc """
    データのチャンク分割とプロセスの起動の一連のスケジューリングを実行するための関数
    他プロセスによるタスク実行はmessage passingでやると手間なのでTaskに任せる
  """

  @doc """
    configに設定された1chunkが扱える最大要素数を元に立ち上げるべきプロセスの総数を算出する
    processs_num = 配列の要素数 / １チャンク辺りの扱える要素の最大値
  """
  def calc_total_process(data_size) do
    each_chunk_size_max = ParallelSum.Config.each_chunk_list_size_limit()
    div(data_size, each_chunk_size_max)
  end

  @doc """
    N個の要素を持つ配列を指定数毎にチャンク分割するための関数
  """
  def list_spliter(lst) when length(lst) > 0 do
    lst |> Enum.chunk_every(ParallelSum.Config.each_chunk_list_size_limit())
  end
  def list_spliter(_), do: :error

  @doc """
    分割されたデータと算出された立ち上げるプロセス数を元にTask moduleを起動して再帰関数によって集計処理を実行
    各プロセスが算出した合計値がリストになって返ってくる
  """
  def start_task(_, lst, _) when length(lst) == 0, do: :error
  def start_task(_, _, 0), do: :error
  def start_task("", _, _), do: :error

  def start_task("recursive", splited_lst, process_num) do
    # プロセスを起動し、チャンクを割り当て
    Enum.map(1..process_num, fn index ->
      Task.async(fn -> ParallelSum.Sum.recurcive_sum(Enum.at(splited_lst, index-1)) end)
    end)
    |> Enum.map(fn task -> Task.await(task) end)
  end

  def start_task("enum", splited_lst, process_num) do
    # プロセスを起動し、チャンクを割り当て
    Enum.map(1..process_num, fn index ->
      Task.async(fn -> ParallelSum.Sum.sum(Enum.at(splited_lst, index-1)) end)
    end)
    |> Enum.map(fn task -> Task.await(task) end)
  end
end

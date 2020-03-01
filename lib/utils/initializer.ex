defmodule ParallelSum.Utils.Initializer do
  @moduledoc """
    プロセスを事前に立ち上げてベンチマークを行う際のデータとプロセス周りの準備を担当する関数群
  """

  @doc """
    指定されたデータサイズを元にチャンクを作成。
    {指定数, チャンク分割したデータ}
  """
  def create_chunk(datasize) do
    splited_lst =
      ParallelSum.DataCreater.create_N_size_list(datasize)
      |> ParallelSum.Scheduler.list_spliter()
    {datasize, splited_lst}
  end

  @doc """
    作成されたチャンク情報を元に待機するプロセスを立ち上げるprivate関数
  """
  # def create_init_process_for_arg_sum({datasize, splited_lst}) do
  #   # 必要なプロセス数を算出
  #   process_num = ParallelSum.Scheduler.calc_total_process(datasize)
  #   # 待機状態になるタスクをTaskモジュールで立ち上げて[]%Task{}を返す
  #   d = Enum.map(1..process_num, fn index ->
  #     Task.async(fn -> ParallelSum.Sum.waiting_sum(Enum.at(splited_lst, index-1)) end)
  #   end)
  #   IO.inspect(d)
  #   d
  # end

  def create_init_process_for_arg_sum({datasize, splited_lst}) do
    # 必要なプロセス数を算出
    process_num = ParallelSum.Scheduler.calc_total_process(datasize)
    # 待機状態になるプロセスを立ち上げてPIDのid群を返す
    pids = Enum.map(1..process_num, fn index ->
      spawn(fn -> ParallelSum.Sum.waiting_sum(Enum.at(splited_lst, index-1)) end)
    end)
    {process_num, pids}
  end
end

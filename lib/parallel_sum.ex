defmodule ParallelSum do
  @moduledoc """
    メインモジュール。他モジュールにて抽象化した関数群をpipeline化する
  """

  @doc """
    並行処理によって合計値を算出するpipeline関数
  """
  def parallel_exec(_, ""), do: :error
  def parallel_exec([], _), do: :error
  def parallel_exec(data_size, mode)  do
    # ランダム値を要素に持つリストを分割したチャンクデータを作成
    dataset =
      ParallelSum.DataCreater.create_N_size_list(data_size)
      |> ParallelSum.Scheduler.list_spliter()

    # 立ち上げるプロセス数を算出
    process_num = ParallelSum.Scheduler.calc_total_process(data_size)

    # プロセスを立ち上げて並行和を算出
    parallel_sum = ParallelSum.Scheduler.start_task(mode, dataset, process_num)
    Enum.sum(parallel_sum)
  end


  @doc """
    逐次処理によって1つのプロセスによって合計値を算出するpipeline関数
  """
  def serial_exec(_, ""), do: :error
  def serial_exec([], _), do: :error
  def serial_exec(data_size, mode) when data_size > 0 do
    # データ作成
    dataset = ParallelSum.DataCreater.create_N_size_list(data_size)

    # 実行するリダクション関数
    _serial_exec(mode).(dataset)
  end

  # 算出方法を切り替えるためのカリー化した無名関数を返すhelper function
  defp _serial_exec("recursive") do
    fn lst -> ParallelSum.Sum.recurcive_sum(lst) end
  end
  defp _serial_exec("enum") do
    fn lst -> ParallelSum.Sum.sum(lst) end
  end
  defp _serial_exec(_), do: :error

  # TODO: 逐次処理と並行処理を順次実行して経過時間を測定する関数の実装
  # def compere()
end

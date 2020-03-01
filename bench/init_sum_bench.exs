defmodule ParallelSum.InitBench do
  @moduledoc """
    ベンチマークの測定前にすでにプロセスを立ち上げた状態で測定を行う
    外部モジュール'benchfella'を用いて計測を行うためのモジュール
  """
  alias ParallelSum.Utils.Initializer, as: Init
  use Benchfella
  @recursive :recursive
  @enum :enum

  # datasetの用意
  @dataset_100 Init.create_chunk(100)
  @dataset_1000 Init.create_chunk(1000)
  @dataset_10000 Init.create_chunk(10000)
  @dataset_100000 Init.create_chunk(100000)

  # プロセスの事前立ち上げ
  @process_100 Init.create_init_process_for_arg_sum(@dataset_100)
  @process_1000 Init.create_init_process_for_arg_sum(@dataset_1000)
  @process_10000 Init.create_init_process_for_arg_sum(@dataset_10000)
  @process_100000 Init.create_init_process_for_arg_sum(@dataset_100000)

  # data size 100 -------------------------------------------
  ## recursive
  bench "parallel: recursive 100" do
    bench_helper(@process_100, @recursive)
  end

  ## enum
  bench "parallel: enum 100" do
    bench_helper(@process_100, @enum)
  end

  # data size 1000 -------------------------------------------
  ## recursive
  bench "parallel: recursive 1000" do
    bench_helper(@process_1000, @recursive)
  end

  ## enum
  bench "parallel: enum 1000" do
    bench_helper(@process_1000, @enum)
  end

  # data size 10000 -------------------------------------------
  ## recursive
  bench "parallel: recursive 10000" do
    bench_helper(@process_10000, @recursive)
  end

  ## enum
  bench "parallel: enum 10000" do
    bench_helper(@process_10000, @enum)
  end

  # data size 100000 -------------------------------------------
  ## recursive
  bench "parallel: recursive 100000" do
    bench_helper(@process_100000, @recursive)
  end

  ## enum
  bench "parallel: enum 100000" do
    bench_helper(@process_100000, @enum)
  end

  # 共通処理を関数化
  def bench_helper(process_info, type_atom) do
    {process_num, calc_processes} = process_info
    # 受信用のプロセスを起動
    # receiver = spawn(ParallelSum.Sum, :receiver, [process_num, self()])
    self_pid = self()
    receiver = spawn(fn -> ParallelSum.Sum.receiver(process_num, self_pid) end)

    # それぞれのプロセスに算出開始のメッセージを送信
    Enum.each(calc_processes, fn pid ->
      send(pid, {type_atom, receiver})
    end)

    # 算出値を受信して合計
    receive do
      {:ok, sum} -> Enum.sum(sum)
    end
  end
end

defmodule ParallelSum.Bench do
  @moduledoc """
    実行時間などを外部モジュール'benchfella'を用いて計測を行うためのモジュール
  """
  use Benchfella
  @recursive "recursive"
  @enum "enum"
  @dataset_100 ParallelSum.DataCreater.create_N_size_list(100)
  @dataset_1000 ParallelSum.DataCreater.create_N_size_list(1000)
  @dataset_10000 ParallelSum.DataCreater.create_N_size_list(10000)
  @dataset_100000 ParallelSum.DataCreater.create_N_size_list(100000)

  # data size 100 -------------------------------------------
  ## recursive
  bench "parallel: recursive 100" do
    ParallelSum.bench_parallel_exec(@dataset_100, @recursive)
  end

  bench "serial: recursive 100" do
    ParallelSum.bench_serial_exec(@dataset_100, @recursive)
  end

  ## enum
  bench "parallel: enum 100" do
    ParallelSum.bench_parallel_exec(@dataset_100, @enum)
  end

  bench "serial: enum 100" do
    ParallelSum.bench_serial_exec(@dataset_100, @enum)
  end

  # data size 1000 -------------------------------------------
  ## recursive
  bench "parallel: recursive 1000" do
    ParallelSum.bench_parallel_exec(@dataset_1000, @recursive)
  end

  bench "serial: recursive 1000" do
    ParallelSum.bench_serial_exec(@dataset_1000, @recursive)
  end

  ## enum
  bench "parallel: enum 1000" do
    ParallelSum.bench_parallel_exec(@dataset_1000, @enum)
  end

  bench "serial: enum 1000" do
    ParallelSum.bench_serial_exec(@dataset_1000, @enum)
  end

  # data size 10000 -------------------------------------------
  ## recursive
  bench "parallel: recursive 10000" do
    ParallelSum.bench_parallel_exec(@dataset_10000, @recursive)
  end

  bench "serial: recursive 10000" do
    ParallelSum.bench_serial_exec(@dataset_10000, @recursive)
  end

  ## enum
  bench "parallel: enum 10000" do
    ParallelSum.bench_parallel_exec(@dataset_10000, @enum)
  end

  bench "serial: enum 10000" do
    ParallelSum.bench_serial_exec(@dataset_10000, @enum)
  end

  # data size 100000 -------------------------------------------
  ## recursive
  bench "parallel: recursive 100000" do
    ParallelSum.bench_parallel_exec(@dataset_100000, @recursive)
  end

  bench "serial: recursive 100000" do
    ParallelSum.bench_serial_exec(@dataset_100000, @recursive)
  end

  ## enum
  bench "parallel: enum 100000" do
    ParallelSum.bench_parallel_exec(@dataset_100000, @enum)
  end

  bench "serial: enum 100000" do
    ParallelSum.bench_serial_exec(@dataset_100000, @enum)
  end
end

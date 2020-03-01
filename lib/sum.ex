defmodule ParallelSum.Sum do
  @moduledoc """
    各プロセスに実行させるためのsum関数(再帰とEnum.sum())
  """
  require Logger

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

  @doc """
    コマンドメッセージを受信するまで算出処理を行わないwrap関数
    チャンクはpassing messageによって受け取る
  """
  def waiting_sum() do
    receive do
      {:recursive, lst} -> recurcive_sum(lst)
      {:enum, lst} -> sum(lst)
        # 指定時間以上経過した場合にプロセスを停止して終了
    after 1000 * ParallelSum.Config.waiting_limit_time_for_process() ->
      Logger.warn("[waiting_sum] time over. so kill process")
    end
  end

  @doc """
    コマンドメッセージを受信するまで算出処理を行わないwrap関数
    チャンクはプロセス起動時に引数で受け取る
  """
  def waiting_sum(lst) when is_list(lst) do
    receive do
      {:recursive, pid} ->
        sum = recurcive_sum(lst)
        send(pid, {:ok, sum})
        # プロセスが停止するとベンチが行えなくなるため再帰
        waiting_sum(lst)
      {:enum, pid} ->
        sum = sum(lst)
        send(pid, {:ok, sum})
        # プロセスが停止するとベンチが行えなくなるため再帰
        waiting_sum(lst)
        # 指定時間以上経過した場合にプロセスを停止して終了
    after 1000 * ParallelSum.Config.waiting_limit_time_for_process() ->
      Logger.warn("[waiting_sum] time over. so kill process")
      exit(:time_over)
    end
  end

  @doc """
    生成したプロセスによって算出した合計値を再帰関数のアキュムレーターに記録
  """
  def receiver(process_num, pid) do
    sum = _receiver(process_num, [])
    send(pid, {:ok, sum})
  end
  defp _receiver(0, accum), do: accum
  defp _receiver(process_num, accum) do
    receive do
      {:ok, sum} -> _receiver(process_num-1, [sum] ++ accum)
    # 指定時間以上経過した場合にプロセスを停止して終了
    after 1000 * ParallelSum.Config.waiting_limit_time_for_process() ->
      Logger.warn("[receiver] time over. so kill process")
    end
  end
end

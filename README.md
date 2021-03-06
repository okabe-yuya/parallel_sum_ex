並行和: ParallelSum
===

## 並行和とは
- N個の要素を持つ配列を用意
- M個の間隔でチャンクに分割
- 分割したチャンクをそれぞれのスレッド、もしくはプロセスの専属データとする
- それぞれのスレッド、もしくはプロセスにて合計値(sum)を算出
- メインのスレッド、もしくはプロセスにて各合計値を合計

```elixir
# dataset
[1,2,3,4,5,6,7,8,9,10]

# split to chunk
[
  [1,2],
  [3,4],
  [5,6],
  [7,8],
  [9,10]
]

# reduction by each thread or process
[
  [1+2],
  [3+4],
  [5+6],
  [7+8],
  [9+10],
]

# total each chunk
[3 + 7 + 11 + 15 + 19] -> 55
```



## 暗黙の個人的な仕様について
- 「並行コンピューティング技法」で学習した「並列和」の実装をOpenMP? OpenMLからElixirの実装に書き換える
- データを分割する並行化を採用して、データのサイズによって自動でスケールするようにする
- データはN個の要素を持つ配列を採用。要素はint型のランダム生成値

## 目標
- 1.スケール可能な並列和の並行アルゴリズムの実装と動作の確認
- 2.データを10^N(N=1~....10^10ぐらいまで。スペックと相談)個程度、用意して逐次処理のパフォーマンスを追い越すデータ数を確認 -> グラフ化
- 3.ボトルネックの改善。再度、グラフ化
- 4.並行化の恩恵を感じて脳汁を出す

## Usage
前提: Elixirがinstall済み

> $ iex -S mix

```
N -> 配列の要素数
mode -> sumの集計方法(recurcive -> 再帰処理, enum -> Enum.sum())
```

### 並行和(複数プロセスによる算出)
> iex> ParallelSum.parallel_exec(N, mode)

### 逐次和(単一プロセスによる算出)
> iex> ParallelSum.serial_exec(N, mode)

## 参考文献
- [並行コンピューティング技法]()
- [random / Erlang Official Documents](http://erlang.org/doc/man/random.html)
- [Task / Elixir Official Documentes](https://hexdocs.pm/elixir/Task.html#content)
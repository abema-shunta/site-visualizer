# nodeの定義。ここを増やすと楽しい。
nodes = [
  {
    id: 0
    label: 'nodeA'
  }
  {
    id: 1
    label: 'nodeB'
  }
  {
    id: 2
    label: 'nodeC'
  }
  {
    id: 3
    label: 'nodeD'
  }
  {
    id: 4
    label: 'nodeE'
  }
  {
    id: 5
    label: 'nodeF'
  }
]
# node同士の紐付け設定。実用の際は、ここをどう作るかが難しいのかも。
links = [
  {
    source: 0
    target: 1
  }
  {
    source: 0
    target: 2
  }
  {
    source: 1
    target: 3
  }
  {
    source: 1
    target: 3
  }
  {
    source: 2
    target: 1
  }
  {
    source: 2
    target: 3
  }
  {
    source: 3
    target: 4
  }
  {
    source: 4
    target: 5
  }
  {
    source: 5
    target: 3
  }
]
# forceLayout自体の設定はここ。ここをいじると楽しい。

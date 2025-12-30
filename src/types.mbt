///|
#alias(T)
pub(all) enum Tree[V] {
  Empty
  Node(left~ : Tree[V], right~ : Tree[V], size~ : Int, min~ : V, max~ : V)
}

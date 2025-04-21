///| Create an empty tree
pub fn empty[N]() -> Tree[N] {
  Empty
}

///| Create a tree with a single element
pub fn singleton[N](x : N) -> Tree[N] {
  make_node(x, x, Empty, Empty)
}

///| Create a tree with a single interval
pub fn interval[N](min : N, max : N) -> Tree[N] {
  make_node(min, max, Empty, Empty)
}

///| Converts an array of elements into a tree
pub fn of[N : BoundedEnum](array : Array[N]) -> Tree[N] {
  array.fold(init=Empty, fn { tree, x => union(tree, singleton(x)) })
}

///| Converts an array view into a tree
pub fn of_view[N : BoundedEnum](view : ArrayView[N]) -> Tree[N] {
  view.fold(init=Empty, fn { tree, x => union(tree, singleton(x)) })
}

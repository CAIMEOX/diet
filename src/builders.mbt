///| Create an empty tree
pub fn[N] empty() -> Tree[N] {
  Empty
}

///| Create a tree with a single element
pub fn[N] singleton(x : N) -> Tree[N] {
  make_node(x, x, Empty, Empty)
}

///| Create a tree with a single interval
pub fn[N] interval(min : N, max : N) -> Tree[N] {
  make_node(min, max, Empty, Empty)
}

///| Converts an array of elements into a tree
pub fn[N : BoundedEnum] of(array : Array[N]) -> Tree[N] {
  array.fold(init=Empty, fn(tree, x) { tree.union(singleton(x)) })
}

///| Converts an array view into a tree
pub fn[N : BoundedEnum] of_view(view : ArrayView[N]) -> Tree[N] {
  view.fold(init=Empty, fn(tree, x) { tree.union(singleton(x)) })
}

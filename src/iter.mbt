///|
/// Create a new iterator over intervals
pub fn[N] Tree::iter_intervals(self : Tree[N]) -> Iterator[(N, N)] {
  match self {
    Empty => Iterator::empty()
    Node(left~, right~, min~, max~, ..) =>
      left
      .iter_intervals()
      .concat(Iterator::singleton((min, max)))
      .concat(right.iter_intervals())
  }
}

///|
/// Create a new iterator over the elements represent by the tree
pub fn[N : BoundedEnum] Tree::iter(self : Tree[N]) -> Iterator[N] {
  self
  .iter_intervals()
  .flat_map(fn(interval) {
    let (min, max) = interval
    let mut curr = min
    let mut done = false
    Iterator::new(fn() {
      if done {
        None
      } else {
        let res = curr
        if curr == max {
          done = true
        } else {
          curr = N::succ(curr)
        }
        Some(res)
      }
    })
  })
}

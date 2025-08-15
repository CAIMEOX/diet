///| Returns a tree containing all elements greater than or equal to x.
pub fn[N : BoundedEnum] slice_from(self : Tree[N], x : N) -> Tree[N] {
  match self {
    Empty => Empty
    Node(..) as t =>
      if x < t.min {
        balance(t.min, t.max, t.left.slice_from(x), t.right)
      } else if x > t.max {
        t.right.slice_from(x)
      } else {
        balance(x, t.max, Empty, t.right)
      }
  }
}

///| Returns a tree containing all elements less than or equal to x.
pub fn[N : BoundedEnum] slice_until(self : Tree[N], x : N) -> Tree[N] {
  match self {
    Empty => Empty
    Node(..) as t =>
      if x > t.max {
        balance(t.min, t.max, t.left, t.right.slice_until(x))
      } else if x < t.min {
        t.left.slice_until(x)
      } else {
        balance(t.min, x, t.left, Empty)
      }
  }
}

///| Returns a tree containing all elements strictly less than x.
pub fn[N : BoundedEnum] slice_before(self : Tree[N], x : N) -> Tree[N] {
  if x == N::lower_bound() {
    Empty
  } else {
    self.slice_until(N::pred(x))
  }
}

///| Returns a tree containing all elements strictly greater than x.
pub fn[N : BoundedEnum] slice_after(self : Tree[N], x : N) -> Tree[N] {
  if x == N::upper_bound() {
    Empty
  } else {
    self.slice_from(N::succ(x))
  }
}

///| Returns a tree containing all elements within the specified range.
pub fn[N : BoundedEnum] slice(self : Tree[N], min? : N, max? : N) -> Tree[N] {
  match (min, max) {
    (None, None) => panic()
    (Some(min), None) => self.slice_from(min)
    (None, Some(max)) => self.slice_until(max)
    (Some(min), Some(max)) => self.slice_from(min).slice_until(max)
  }
}

///| Checks if a tree is empty.
pub fn[N] is_empty(self : Tree[N]) -> Bool {
  match self {
    Empty => true
    Node(..) => false
  }
}

///| Determines if a discrete interval encoding tree contains a specific value.
pub fn[N : BoundedEnum] contains(self : Tree[N], x : N) -> Bool {
  match self {
    Empty => false
    Node(..) as t =>
      if x < t.min {
        t.left.contains(x)
      } else if x > t.max {
        t.right.contains(x)
      } else {
        true
      }
  }
}

///| Computes the union of two discrete interval encoding trees.
pub fn[N : BoundedEnum] union(self : Tree[N], t2 : Tree[N]) -> Tree[N] {
  match (self, t2) {
    (Empty, Empty) => Empty
    (Empty, Node(..) as t) | (Node(..) as t, Empty) => t
    (Node(..) as t1, Node(..) as t2) => {
      let (t1, t2) = if t1.size >= t2.size { (t1, t2) } else { (t2, t1) }
      union_aux(t1, t2)
    }
  }
}

///| Helper function for computing the union of two non-empty trees.
fn[N : BoundedEnum] union_aux(t1 : Tree[N], t2 : Tree[N]) -> Tree[N] {
  guard t1 is (Node(..) as t1)
  guard t2 is (Node(..) as t2)
  let l1 = t1.left
  let r1 = t1.right
  let l2 = t2.slice_before(t1.min)
  let r2 = t2.slice_after(t1.max)
  let (min, l) = if t1.min == N::lower_bound() {
    (t1.min, Empty)
  } else {
    let l = union(l1, l2)
    match l {
      Empty => (t1.min, Empty)
      Node(_) => {
        let ((min, max), l3) = split_rightmost(l)
        if max < N::upper_bound() && N::succ(max) == t1.min {
          (min, l3)
        } else {
          (t1.min, l)
        }
      }
    }
  }
  let (max, r) = if t1.max == N::upper_bound() {
    (t1.max, Empty)
  } else {
    let r = union(r1, r2)
    match r {
      Empty => (t1.max, Empty)
      Node(_) => {
        let ((min, max), r3) = split_leftmost(r)
        if min > N::lower_bound() && N::pred(min) == t1.max {
          (max, r3)
        } else {
          (t1.max, r)
        }
      }
    }
  }
  balance(min, max, l, r)
}

///| Computes the intersection of two discrete interval encoding trees.
pub fn[N : BoundedEnum] intersection(self : Tree[N], t2 : Tree[N]) -> Tree[N] {
  match (self, t2) {
    (Empty, _) | (_, Empty) => Empty
    (Node(..) as t1, Node(..) as t2) => {
      let (t1, t2) = if t1.size >= t2.size { (t1, t2) } else { (t2, t1) }
      intersection_aux(t1, t2)
    }
  }
}

///| Helper function for computing the intersection of two non-empty trees.
fn[N : BoundedEnum] intersection_aux(t1 : Tree[N], t2 : Tree[N]) -> Tree[N] {
  guard t1 is (Node(..) as t1)
  guard t2 is (Node(..) as t2)
  let l1 = t1.left
  let r1 = t1.right
  let l2 = t2.slice_before(t1.min)
  let r2 = t2.slice_after(t1.max)
  let l = intersection(l1, l2)
  let r = intersection(r1, r2)
  let m = t2.slice(min=t1.min, max=t1.max)
  concat(concat(l, m), r)
}

///| Computes the complement of a discrete interval encoding tree.
pub fn[N : BoundedEnum] complement(self : Tree[N]) -> Tree[N] {
  complement_aux(N::lower_bound(), N::upper_bound(), self)
}

///| Helper function for computing the complement of a tree within a range.
fn[N : BoundedEnum] complement_aux(min : N, max : N, t : Tree[N]) -> Tree[N] {
  match t {
    Empty => interval(min, max)
    Node(..) as t => {
      let l = if t.min == N::lower_bound() {
        Empty
      } else {
        complement_aux(min, N::pred(t.min), t.left)
      }
      let r = if t.max == N::upper_bound() {
        Empty
      } else {
        complement_aux(N::succ(t.max), max, t.right)
      }
      concat(l, r)
    }
  }
}

///| Computes the difference between two discrete interval encoding trees.
pub fn[N : BoundedEnum] difference(t1 : Tree[N], t2 : Tree[N]) -> Tree[N] {
  t1.intersection(t2.complement())
}

///| Adds a single value to a discrete interval encoding tree.
pub fn[N : BoundedEnum] add(self : Tree[N], n : N) -> Tree[N] {
  guard not(self.is_empty()) else { make_node(n, n, Empty, Empty) }
  guard self is (Node(min=v1, max=v2, left=s0, right=s1, ..) as s)
  if v1 != N::lower_bound() && n < N::pred(v1) {
    make_node(v1, v2, s0.add(n), s1)
  } else if v2 != N::upper_bound() && n > N::succ(v2) {
    make_node(v1, v2, s0, s1.add(n))
  } else if N::succ(n) == v1 {
    guard not(s0.is_empty()) else { make_node(n, v2, s0, s1) }
    let ((u1, u2), s0_prime) = split_rightmost(s0)
    if u2 != N::upper_bound() && N::succ(u2) == n {
      make_node(u1, v2, s0_prime, s1)
    } else {
      make_node(n, v2, s0, s1)
    }
  } else if N::succ(v2) == n {
    guard not(s1.is_empty()) else { make_node(v1, n, s0, s1) }
    let ((u1, u2), s1_prime) = split_leftmost(s1)
    if n != N::upper_bound() && N::succ(n) == u1 {
      make_node(v1, u2, s0, s1_prime)
    } else {
      make_node(v1, n, s0, s1)
    }
  } else {
    s
  }
}

///| Removes a single value from a discrete interval encoding tree.
pub fn[N : BoundedEnum] remove(self : Tree[N], n : N) -> Tree[N] {
  match self {
    Empty => Empty
    Node(min=v1, max=v2, left=s1, right=s2, ..) =>
      if n < v1 {
        make_node(v1, v2, s1.remove(n), s2)
      } else if n == v1 {
        if v1 == v2 {
          concat(s1, s2)
        } else {
          make_node(N::succ(v1), v2, s1, s2)
        }
      } else if n > v1 && n < v2 {
        let left_part = make_node(v1, N::pred(n), s1, Empty)
        let right_part = make_node(N::succ(n), v2, Empty, s2)
        concat(left_part, right_part)
      } else if n == v2 {
        make_node(v1, N::pred(v2), s1, s2)
      } else {
        make_node(v1, v2, s1, s2.remove(n))
      }
  }
}

///| Checks if one discrete interval encoding tree is a subset of another.
pub fn[N : BoundedEnum] is_subset(s1 : Tree[N], s2 : Tree[N]) -> Bool {
  match (s1, s2) {
    (Empty, _) => true
    (_, Empty) => false
    (Node(..) as s1, Node(min=v1, max=v2, left=l2, right=r2, ..)) => {
      let l1 = s1.slice_before(v1)
      let r1 = s1.slice_after(v2)
      is_subset(l1, l2) && is_subset(r1, r2)
    }
  }
}

///| Applies a function to each interval in the tree and accumulates the results.
pub fn[N : BoundedEnum, A] fold_ranges(
  self : Tree[N],
  init~ : A,
  f : (A, N, N) -> A,
) -> A {
  self.iter_intervals().fold(init~, fn { acc, (min, max) => f(acc, min, max) })
}

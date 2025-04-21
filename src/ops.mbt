///|
pub fn is_empty[N](self : Tree[N]) -> Bool {
  match self {
    Empty => true
    Node(..) => false
  }
}

///|
pub fn contains[N : BoundedEnum](self : Tree[N], x : N) -> Bool {
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

///|
pub fn union[N : BoundedEnum](self : Tree[N], t2 : Tree[N]) -> Tree[N] {
  match (self, t2) {
    (Empty, Empty) => Empty
    (Empty, Node(..) as t) | (Node(..) as t, Empty) => t
    (Node(..) as t1, Node(..) as t2) => {
      let (t1, t2) = if t1.size >= t2.size { (t1, t2) } else { (t2, t1) }
      union_aux(t1, t2)
    }
  }
}

///|
fn union_aux[N : BoundedEnum](t1 : Tree[N], t2 : Tree[N]) -> Tree[N] {
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

///|
pub fn intersection[N : BoundedEnum](self : Tree[N], t2 : Tree[N]) -> Tree[N] {
  match (self, t2) {
    (Empty, _) | (_, Empty) => Empty
    (Node(..) as t1, Node(..) as t2) => {
      let (t1, t2) = if t1.size >= t2.size { (t1, t2) } else { (t2, t1) }
      intersection_aux(t1, t2)
    }
  }
}

///|
fn intersection_aux[N : BoundedEnum](t1 : Tree[N], t2 : Tree[N]) -> Tree[N] {
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

///|
pub fn complement[N : BoundedEnum](self : Tree[N]) -> Tree[N] {
  complement_aux(N::lower_bound(), N::upper_bound(), self)
}

///|
fn complement_aux[N : BoundedEnum](min : N, max : N, t : Tree[N]) -> Tree[N] {
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

///|
pub fn difference[N : BoundedEnum](t1 : Tree[N], t2 : Tree[N]) -> Tree[N] {
  t1.intersection(t2.complement())
}

///|
pub fn add[N : BoundedEnum](self : Tree[N], n : N) -> Tree[N] {
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

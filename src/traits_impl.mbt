///|
pub impl[N] Default for Tree[N] with default() {
  Empty
}

///|
pub impl[N : Eq] Eq for Tree[N] with equal(self : Tree[N], other : Tree[N]) {
  let it1 = self.iter_intervals()
  let it2 = other.iter_intervals()
  loop (it1.next(), it2.next()) {
    (None, None) => true
    (Some(a), Some(b)) =>
      if a == b {
        continue (it1.next(), it2.next())
      } else {
        false
      }
    _ => false
  }
}

///|
pub impl[N : Compare] Compare for Tree[N] with compare(
  self : Tree[N],
  other : Tree[N],
) {
  let it1 = self.iter_intervals()
  let it2 = other.iter_intervals()
  loop (it1.next(), it2.next()) {
    (None, None) => 0
    (Some(a), Some(b)) => {
      let cmp = a.compare(b)
      if cmp == 0 {
        continue (it1.next(), it2.next())
      } else {
        cmp
      }
    }
    (Some(_), None) => 1
    (None, Some(_)) => -1
  }
}

///|
pub impl[N : Hash] Hash for Tree[N] with hash_combine(self, hasher) {
  for interval in self.iter_intervals() {
    interval.hash_combine(hasher)
  }
}

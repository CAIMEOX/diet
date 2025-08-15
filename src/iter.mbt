///| Create a new iterator over intervals
pub fn[N] iter_intervals(self : Tree[N]) -> Iter[(N, N)] {
  Iter::new(fn(yield_) {
    match self {
      Empty => IterContinue
      Node(..) as t => {
        guard iter_intervals(t.left).run(yield_) is IterContinue else {
          return IterEnd
        }
        guard yield_((t.min, t.max)) is IterContinue else { return IterEnd }
        guard iter_intervals(t.right).run(yield_) is IterContinue else {
          return IterEnd
        }
        IterContinue
      }
    }
  })
}

///| Create a new iterator over the elements represent by the tree
pub fn[N : BoundedEnum] iter(self : Tree[N]) -> Iter[N] {
  self
  .iter_intervals()
  .flat_map(fn {
    (min, max) =>
      Iter::new(fn(yield_) {
        for x = min; x <= max; x = N::succ(x) {
          guard yield_(x) is IterContinue else { return IterEnd }
        }
        IterContinue
      })
  })
}

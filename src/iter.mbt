///| Create a new iterator over intervals
pub fn[N] iter_intervals(self : Tree[N]) -> Iter[(N, N)] {
  Iter::new(fn(yield_) {
    match self {
      Empty => IterContinue
      Node(..) as t => {
        guard t.left.iter_intervals().run(yield_) is IterContinue else {
          return IterEnd
        }
        guard yield_((t.min, t.max)) is IterContinue else { return IterEnd }
        guard t.right.iter_intervals().run(yield_) is IterContinue else {
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
  .flat_map(fn(interval) {
    let (min, max) = interval
    Iter::new(fn(yield_) {
      for x = min; x <= max; x = N::succ(x) {
        guard yield_(x) is IterContinue else { return IterEnd }
      }
      IterContinue
    })
  })
}

///|
pub impl BoundedEnum for Char with pred(self) {
  (self.to_int() - 1).unsafe_to_char()
}

///|
pub impl BoundedEnum for Char with succ(self) {
  (self.to_int() + 1).unsafe_to_char()
}

///|
pub impl BoundedEnum for Char with lower_bound() {
  Int::unsafe_to_char(0)
}

///|
pub impl BoundedEnum for Char with upper_bound() {
  Int::unsafe_to_char(0x10ffff)
}

///|
pub impl BoundedEnum for Int with pred(self) {
  self - 1
}

///|
pub impl BoundedEnum for Int with succ(self) {
  self + 1
}

///|
pub impl BoundedEnum for Int with lower_bound() {
  @int.min_value
}

///|
pub impl BoundedEnum for Int with upper_bound() {
  @int.max_value
}

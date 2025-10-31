///|
test "empty" {
  let empty : @diet.T[Char] = @diet.empty()
  inspect(empty.iter().to_array(), content="[]")
}

///|
test "singleton" {
  let singleton : @diet.T[Char] = @diet.singleton('a')
  inspect(singleton.iter().to_array(), content="['a']")
}

///|
test "interval" {
  let interval : @diet.T[Char] = @diet.interval('0', '9')
  inspect(
    interval.iter().to_array(),
    content="['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']",
  )
}

///|
test "slice with min" {
  let a : @diet.T[Char] = @diet.interval('0', '9')
  let slice : @diet.T[Char] = a.slice(min='3')
  inspect(
    slice.iter().to_array(),
    content="['3', '4', '5', '6', '7', '8', '9']",
  )
}

///|
test "slice with max" {
  let a : @diet.T[Char] = @diet.interval('0', '9')
  let slice : @diet.T[Char] = a.slice(max='3')
  inspect(slice.iter().to_array(), content="['0', '1', '2', '3']")
}

///|
test "slice with min and max" {
  let a : @diet.T[Char] = @diet.interval('0', '9')
  let slice : @diet.T[Char] = a.slice(min='3', max='6')
  inspect(slice.iter().to_array(), content="['3', '4', '5', '6']")
}

///|
test "union adjacent" {
  let a : @diet.T[Char] = @diet.interval('0', '4')
  let b : @diet.T[Char] = @diet.interval('5', '9')
  let union : @diet.T[Char] = a.union(b)
  inspect(
    union.iter().to_array(),
    content="['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']",
  )
}

///|
test "union overlapping" {
  let a : @diet.T[Char] = @diet.interval('0', '5')
  let b : @diet.T[Char] = @diet.interval('4', '9')
  let union : @diet.T[Char] = a.union(b)
  inspect(
    union.iter().to_array(),
    content="['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']",
  )
}

///|
test "union disjoint" {
  let a : @diet.T[Char] = @diet.interval('0', '4')
  let b : @diet.T[Char] = @diet.interval('6', '9')
  let union : @diet.T[Char] = a.union(b)
  inspect(
    union.iter().to_array(),
    content="['0', '1', '2', '3', '4', '6', '7', '8', '9']",
  )
}

///|
test "union containing" {
  let a : @diet.T[Char] = @diet.interval('0', '9')
  let b : @diet.T[Char] = @diet.interval('3', '6')
  let union : @diet.T[Char] = a.union(b)
  inspect(
    union.iter().to_array(),
    content="['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']",
  )
}

///|
test "intersection adjacent" {
  let a : @diet.T[Char] = @diet.interval('0', '4')
  let b : @diet.T[Char] = @diet.interval('4', '9')
  let intersection : @diet.T[Char] = a.intersection(b)
  inspect(intersection.iter().to_array(), content="['4']")
}

///|
test "intersection overlapping" {
  let a : @diet.T[Char] = @diet.interval('0', '5')
  let b : @diet.T[Char] = @diet.interval('4', '9')
  let intersection : @diet.T[Char] = a.intersection(b)
  inspect(intersection.iter().to_array(), content="['4', '5']")
}

///|
test "intersection disjoint" {
  let a : @diet.T[Char] = @diet.interval('0', '4')
  let b : @diet.T[Char] = @diet.interval('6', '9')
  let intersection : @diet.T[Char] = a.intersection(b)
  inspect(intersection.iter().to_array(), content="[]")
}

///|
test "intersection containing" {
  let a : @diet.T[Char] = @diet.interval('0', '9')
  let b : @diet.T[Char] = @diet.interval('3', '6')
  let intersection : @diet.T[Char] = a.intersection(b)
  inspect(intersection.iter().to_array(), content="['3', '4', '5', '6']")
}

///|
test "complement empty" {
  let empty : @diet.T[Char] = @diet.empty()
  let complement : @diet.T[Char] = empty.complement()
  inspect(
    complement.iter_intervals().to_array(),
    content="[('\\u{00}', '\\u{10ffff}')]",
  )
}

///|
test "complement single interval" {
  let a : @diet.T[Char] = @diet.interval('0', '9')
  let complement : @diet.T[Char] = a.complement()
  inspect(
    complement.iter_intervals().to_array(),
    content="[('\\u{00}', '/'), (':', '\\u{10ffff}')]",
  )
}

///|
test "complement multiple intervals" {
  let a : @diet.T[Char] = @diet.interval('0', '4').union(
    @diet.interval('6', '9'),
  )
  let complement : @diet.T[Char] = a.complement()
  inspect(
    complement.iter_intervals().to_array(),
    content="[('\\u{00}', '/'), ('5', '5'), (':', '\\u{10ffff}')]",
  )
}

///|
test "difference" {
  let a : @diet.T[Char] = @diet.interval('0', '9')
  let b : @diet.T[Char] = @diet.interval('3', '6')
  let difference : @diet.T[Char] = @diet.difference(a, b)
  inspect(
    difference.iter().to_array(),
    content="['0', '1', '2', '7', '8', '9']",
  )
}

///|
test "add" {
  let a : @diet.T[Int] = @diet.empty()
  let b = a.add(1)
  let c = b.add(10)
  let x = @diet.interval(4, 8)
  let y = c.union(x)
  let z = y.add(5)
  inspect(c.iter().to_array(), content="[1, 10]")
  inspect(y.iter().to_array(), content="[1, 4, 5, 6, 7, 8, 10]")
  inspect(z.iter().to_array(), content="[1, 4, 5, 6, 7, 8, 10]")
}

///|
test "until empty" {
  let empty : @diet.T[Char] = @diet.empty()
  let result : @diet.T[Char] = empty.slice_until('5')
  inspect(result.iter().to_array(), content="[]")
}

///|
test "until - value not in tree" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_until('0') // '0' comes before 'a'
  inspect(result.iter().to_array(), content="[]")
}

///|
test "until - value in interval" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_until('c')
  inspect(result.iter().to_array(), content="['a', 'b', 'c']")
}

///|
test "until - value equal to max" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_until('e')
  inspect(result.iter().to_array(), content="['a', 'b', 'c', 'd', 'e']")
}

///|
test "until - value after interval" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_until('z')
  inspect(result.iter().to_array(), content="['a', 'b', 'c', 'd', 'e']")
}

///|
test "until - multiple intervals" {
  let a : @diet.T[Char] = @diet.interval('a', 'c').union(
    @diet.interval('g', 'i'),
  )
  let result1 : @diet.T[Char] = a.slice_until('b')
  let result2 : @diet.T[Char] = a.slice_until('d')
  let result3 : @diet.T[Char] = a.slice_until('h')
  inspect(result1.iter().to_array(), content="['a', 'b']")
  inspect(result2.iter().to_array(), content="['a', 'b', 'c']")
  inspect(result3.iter().to_array(), content="['a', 'b', 'c', 'g', 'h']")
}

///|
test "until - with integers" {
  let a : @diet.T[Int] = @diet.interval(1, 5).union(@diet.interval(10, 15))
  let result : @diet.T[Int] = a.slice_until(12)
  inspect(result.iter().to_array(), content="[1, 2, 3, 4, 5, 10, 11, 12]")
}

///|
test "from empty" {
  let empty : @diet.T[Char] = @diet.empty()
  let result : @diet.T[Char] = empty.slice_from('5')
  inspect(result.iter().to_array(), content="[]")
}

///|
test "from - value not in tree" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_from('z') // 'z' comes after 'e'
  inspect(result.iter().to_array(), content="[]")
}

///|
test "from - value in interval" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_from('c')
  inspect(result.iter().to_array(), content="['c', 'd', 'e']")
}

///|
test "from - value equal to min" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_from('a')
  inspect(result.iter().to_array(), content="['a', 'b', 'c', 'd', 'e']")
}

///|
test "from - value before interval" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.slice_from('0')
  inspect(result.iter().to_array(), content="['a', 'b', 'c', 'd', 'e']")
}

///|
test "from - multiple intervals" {
  let a : @diet.T[Char] = @diet.interval('a', 'c').union(
    @diet.interval('g', 'i'),
  )
  let result1 : @diet.T[Char] = a.slice_from('b')
  let result2 : @diet.T[Char] = a.slice_from('d')
  let result3 : @diet.T[Char] = a.slice_from('h')
  inspect(result1.iter().to_array(), content="['b', 'c', 'g', 'h', 'i']")
  inspect(result2.iter().to_array(), content="['g', 'h', 'i']")
  inspect(result3.iter().to_array(), content="['h', 'i']")
}

///|
test "from - with integers" {
  let a : @diet.T[Int] = @diet.interval(1, 5).union(@diet.interval(10, 15))
  let result : @diet.T[Int] = a.slice_from(3)
  inspect(result.iter().to_array(), content="[3, 4, 5, 10, 11, 12, 13, 14, 15]")
}

///|
test "from and until combined" {
  let a : @diet.T[Char] = @diet.interval('a', 'z')
  let from_m : @diet.T[Char] = a.slice_from('m')
  let until_t : @diet.T[Char] = from_m.slice_until('t')

  // Should contain characters from 'm' to 't'
  inspect(
    until_t.iter().to_array(),
    content="['m', 'n', 'o', 'p', 'q', 'r', 's', 't']",
  )
}

///|
test "remove from empty" {
  let empty : @diet.T[Char] = @diet.empty()
  let result : @diet.T[Char] = empty.remove('5')
  inspect(result.iter().to_array(), content="[]")
}

///|
test "remove - value not in tree" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.remove('z') // 'z' not in tree
  inspect(result.iter().to_array(), content="['a', 'b', 'c', 'd', 'e']")
}

///|
test "remove - singleton" {
  let a : @diet.T[Char] = @diet.singleton('a')
  let result : @diet.T[Char] = a.remove('a')
  inspect(result.iter().to_array(), content="[]")
}

///|
test "remove - from start of interval" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.remove('a')
  inspect(result.iter().to_array(), content="['b', 'c', 'd', 'e']")
}

///|
test "remove - from end of interval" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.remove('e')
  inspect(result.iter().to_array(), content="['a', 'b', 'c', 'd']")
}

///|
test "remove - from middle of interval" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result : @diet.T[Char] = a.remove('c')
  inspect(
    result.iter_intervals().to_array(),
    content="[('a', 'b'), ('d', 'e')]",
  )
  inspect(result.iter().to_array(), content="['a', 'b', 'd', 'e']")
}

///|
test "remove - multiple elements" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result1 : @diet.T[Char] = a.remove('b')
  let result2 : @diet.T[Char] = result1.remove('d')
  inspect(
    result2.iter_intervals().to_array(),
    content="[('a', 'a'), ('c', 'c'), ('e', 'e')]",
  )
  inspect(result2.iter().to_array(), content="['a', 'c', 'e']")
}

///|
test "remove - from multiple intervals" {
  let a : @diet.T[Char] = @diet.interval('a', 'c').union(
    @diet.interval('g', 'i'),
  )
  let result1 : @diet.T[Char] = a.remove('a')
  let result2 : @diet.T[Char] = a.remove('h')
  inspect(result1.iter().to_array(), content="['b', 'c', 'g', 'h', 'i']")
  inspect(result2.iter().to_array(), content="['a', 'b', 'c', 'g', 'i']")
}

///|
test "remove - with integers" {
  let a : @diet.T[Int] = @diet.interval(1, 5)
  let result1 : @diet.T[Int] = a.remove(1)
  let result2 : @diet.T[Int] = a.remove(3)
  let result3 : @diet.T[Int] = a.remove(5)
  inspect(result1.iter().to_array(), content="[2, 3, 4, 5]")
  inspect(result2.iter_intervals().to_array(), content="[(1, 2), (4, 5)]")
  inspect(result3.iter().to_array(), content="[1, 2, 3, 4]")
}

///|
test "remove - add and remove same element" {
  let a : @diet.T[Int] = @diet.empty()
  let with_added : @diet.T[Int] = a.add(10)
  let with_removed : @diet.T[Int] = with_added.remove(10)
  inspect(with_added.iter().to_array(), content="[10]")
  inspect(with_removed.iter().to_array(), content="[]")
}

///|
test "subset - empty sets" {
  let empty : @diet.T[Char] = @diet.empty()
  let result1 = @diet.is_subset(empty, empty)
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let result2 = @diet.is_subset(empty, a)
  let result3 = @diet.is_subset(a, empty)
  inspect(result1, content="true") // Empty is subset of empty
  inspect(result2, content="true") // Empty is subset of any set
  inspect(result3, content="false") // Non-empty is not subset of empty
}

///|
test "subset - equal sets" {
  let a : @diet.T[Char] = @diet.interval('a', 'e')
  let b : @diet.T[Char] = @diet.interval('a', 'e')
  let result = @diet.is_subset(a, b)
  inspect(result, content="true") // A set is a subset of itself
}

///|
test "subset - proper subset" {
  let a : @diet.T[Char] = @diet.interval('b', 'd')
  let b : @diet.T[Char] = @diet.interval('a', 'e')
  let result = @diet.is_subset(a, b)
  inspect(result, content="true") // Smaller interval is subset of larger
}

///|
test "subset - not a subset" {
  let a : @diet.T[Char] = @diet.interval('a', 'f')
  let b : @diet.T[Char] = @diet.interval('b', 'e')
  let result = @diet.is_subset(a, b)
  inspect(result, content="false") // a-f is not a subset of b-e
}

///|
test "subset - overlapping" {
  let a : @diet.T[Char] = @diet.interval('a', 'c')
  let b : @diet.T[Char] = @diet.interval('b', 'e')
  let result = @diet.is_subset(a, b)
  inspect(result, content="false") // a-c is not a subset of b-e
}

///|
test "subset - disjoint" {
  let a : @diet.T[Char] = @diet.interval('a', 'c')
  let b : @diet.T[Char] = @diet.interval('d', 'f')
  let result = @diet.is_subset(a, b)
  inspect(result, content="false") // Disjoint sets
}

///|
test "subset - multiple intervals" {
  let a : @diet.T[Char] = @diet.interval('b', 'c')
  let b : @diet.T[Char] = @diet.interval('a', 'd').union(
    @diet.interval('g', 'i'),
  )
  let c : @diet.T[Char] = @diet.interval('b', 'c').union(
    @diet.interval('h', 'i'),
  )
  let result1 = @diet.is_subset(a, b)
  let result2 = @diet.is_subset(c, b)
  inspect(result1, content="true") // b-c is subset of a-d,g-i
  inspect(result2, content="true") // b-c,h-i is subset of a-d,g-i
}

///|
test "subset - complex relationship" {
  let a : @diet.T[Char] = @diet.interval('b', 'c').union(
    @diet.interval('f', 'g'),
  )
  let b : @diet.T[Char] = @diet.interval('a', 'd').union(
    @diet.interval('f', 'h'),
  )
  let result = @diet.is_subset(a, b)
  inspect(result, content="true") // b-c,f-g is subset of a-d,f-h
}

///|
test "subset - with integers" {
  let a : @diet.T[Int] = @diet.interval(2, 4).union(@diet.interval(10, 11))
  let b : @diet.T[Int] = @diet.interval(1, 5).union(@diet.interval(8, 12))
  let result = @diet.is_subset(a, b)
  inspect(result, content="true") // 2-4,10-11 is subset of 1-5,8-12
}

///|
test "fold - empty tree" {
  let empty : @diet.T[Int] = @diet.empty()

  // Sum of interval lengths (should be 0)
  let count = empty
    .iter_intervals()
    .fold(init=0, fn(acc, mm) {
      let (min, max) = mm
      acc + max - min + 1
    })
  inspect(count, content="0")
}

///|
test "fold - singleton tree" {
  let singleton : @diet.T[Int] = @diet.singleton('x')

  // Sum of interval lengths (should be 1)
  let count = singleton.fold_ranges(init=0, fn(acc, min, max) {
    acc + (max - min + 1)
  })
  inspect(count, content="1")
}

///|
test "fold - single interval" {
  let interval : @diet.T[Int] = @diet.interval(1, 4)

  // Sum of interval lengths
  let count = interval.fold_ranges(init=0, fn(acc, min, max) {
    acc + (max - min) + 1
  })

  // Collecting intervals as strings
  let intervals = interval.fold_ranges(init="", fn(acc, min, max) {
    if acc == "" {
      "\{min}-\{max}"
    } else {
      acc + ", \{min}-\{max}"
    }
  })
  inspect(count, content="4")
  inspect(intervals, content="1-4")
}

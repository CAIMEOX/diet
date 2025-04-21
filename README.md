# DIET: Discrete Interval Encoding Trees for MoonBit

The **DIET (Discrete Interval Encoding Tree)** library provides an efficient set representation for continuous ranges of values. This data structure is particularly useful when you need to represent large sets of sequential data while maintaining memory efficiency.

## Overview

A DIET represents sets as intervals rather than individual elements. For example, instead of storing `[1, 2, 3, 4, 5]` as five separate values, it stores them as a single interval `(1, 5)`. This approach provides significant memory savings when working with large, dense sets of ordered data.

## Usage Examples

- Creating a DIET:

```moonbit
// Create an empty set
let empty = @diet.empty()

// Create a set with a single element
let singleton = @diet.singleton('a')

// Create a set with an interval
let digits = @diet.interval('0', '9')

// Create from an array
let letters = @diet.of(['a', 'b', 'c', 'd', 'e'])
```

- Set operations:

```moonbit
// Union of two sets
let combined = @diet.union(set1, set2)

// Intersection of two sets
let common = @diet.intersection(set1, set2)

// Difference between sets
let difference = @diet.difference(set1, set2)

// Complement of a set
let complement = @diet.complement(set)
```

- Element Operations:

```moonbit
// Add an element
let with_element = set.add(5)

// Remove an element
let without_element = set.remove(5)

// Check if an element exists
let exists = set.contains(5)
```

More other operations are available, including checking if a set is empty, getting the size of a set, and iterating over elements. Check the mooncakes DIET documentation for a complete list of methods.

### Supported Types

The library includes built-in support for:

- `Char` - for character ranges
- `Int` - for integer ranges
You can extend support to custom types by implementing the `BoundedEnum` trait.

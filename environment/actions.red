Red [
	Title:   "Red base environment definitions"
	Author:  "Nenad Rakocevic"
	File: 	 %boot.red
	Tabs:	 4
	Rights:  "Copyright (C) 2011-2013 Nenad Rakocevic. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/dockimbel/Red/blob/master/BSL-License.txt
	}
]

;; Warning: do not define any function of any kind before MAKE definition

make: make action! [[									;--	this one works!	;-)
		"Returns a new value made from a spec for that value's type"
		type	 [any-type!] "The datatype or a prototype value"
		spec	 [any-type!] "The specification	of the new value"
		return:  [any-type!] "Returns the specified datatype"
	]
	#get-definition ACT_MAKE
]

random: make action! [[
		"Returns a random value of the same datatype; or shuffles series"
		value   [any-type!] "Maximum value of result (modified when series)"
		/seed   "Restart or randomize"
		/secure "TBD: Returns a cryptographically secure random number"
		/only	"Pick a random value from a series"
		return:	[any-type!]
	]
	#get-definition ACT_RANDOM
]

reflect: make action! [[
		"Returns internal details about a value via reflection"
		value	[any-type!]
		field 	[word!] "spec, body, words, etc. Each datatype defines its own reflectors"
	]
	#get-definition ACT_REFLECT
]

to: make action! [[
		"Converts to a specified datatype"
		type	[any-type!] "The datatype or example value"
		spec	[any-type!] "The attributes of the new value"
	]
	#get-definition ACT_TO
]

form: make action! [[
		"Returns a user-friendly string representation of a value"
		value	  [any-type!]
		/part "Limit the length of the result"
			limit [integer!]
		return:	  [string!]
	]
	#get-definition ACT_FORM
]

mold: make action! [[
		"Returns a source format string representation of a value"
		value	  [any-type!]
		/only "Exclude outer brackets if value is a block"
		/all  "TBD: Return value in loadable format"
		/flat "TBD: Exclude all indentation"
		/part "Limit the length of the result"
			limit [integer!]
		return:	  [string!]
	]
	#get-definition ACT_MOLD
]

;-- Scalar actions --

absolute: make action! [[
		"Returns the non-negative value"
		value	 [number!]
		return:  [number!]
	]
	#get-definition ACT_ABSOLUTE
]

add: make action! [[
		"Returns the sum of the two values"
		value1	 [number! char!]
		value2	 [number! char!]
		return:  [number! char!]
	]
	#get-definition ACT_ADD
]

divide: make action! [[
		"Returns the quotient of two values"
		value1	 [number! char!] "The dividend (numerator)"
		value2	 [number! char!] "The divisor (denominator)"
		return:  [number! char!]
	]
	#get-definition ACT_DIVIDE
]

multiply: make action! [[
		"Returns the product of two values"
		value1	 [number! char!]
		value2	 [number! char!]
		return:  [number! char!]
	]
	#get-definition ACT_MULTIPLY
]

negate: make action! [[
		"Returns the opposite (additive inverse) value"
		number 	 [number! bitset!]
		return:  [number! bitset!]
	]
	#get-definition ACT_NEGATE
]

power: make action! [[
		"Returns a number raised to a given power (exponent)"
		number	 [number!] "Base value"
		exponent [number!] "The power (index) to raise the base value by"
		return:	 [number!]
	]
	#get-definition ACT_POWER
]

remainder: make action! [[
		"Returns what is left over when one value is divided by another"
		value1 	 [number! char!]
		value2 	 [number! char!]
		return:  [number! char!]
	]
	#get-definition ACT_REMAINDER
]

modulo: func [
	"Compute a nonnegative remainder of A divided by B"
	a		[number!]
	b		[number!]
	return: [number!]
	/local r
][
	b: absolute b
    all [0 > r: a % b r: r + b]
    a: absolute a
    either all [a + r = (a + b) 0 < r + r - b] [r - b] [r]
]

round: make action! [[
		"Returns the nearest integer. Halves round up (away from zero) by default"
		n		[number!]
		/to		"Return the nearest multiple of the scale parameter"
		scale	[number!] "Must be a non-zero value"
		/even		"Halves round toward even results"
		/down		"Round toward zero, ignoring discarded digits. (truncate)"
		/half-down	"Halves round toward zero"
		/floor		"Round in negative direction"
		/ceiling	"Round in positive direction"
		/half-ceiling "Halves round in positive direction"
	]
	#get-definition ACT_ROUND
]

subtract: make action! [[
		"Returns the difference between two values"
		value1	 [number! char!]
		value2	 [number! char!]
		return:  [number! char!]
	]
	#get-definition ACT_SUBTRACT
]

even?: make action! [[
		"Returns true if the number is evenly divisible by 2"
		number 	 [number! char!]
		return:  [number! char!]
	]
	#get-definition ACT_EVEN?
]

odd?: make action! [[
		"Returns true if the number has a remainder of 1 when divided by 2"
		number 	 [number! char!]
		return:  [number! char!]
	]
	#get-definition ACT_ODD?
]

;-- Bitwise actions --

and~: make action! [[
		"Returns the first value ANDed with the second"
		value1	[logic! integer! char! bitset! typeset!]
		value2	[logic! integer! char! bitset! typeset!]
		return:	[logic! integer! char! bitset! typeset!]
	]
	#get-definition ACT_AND~
]

complement: make action! [[
		"Returns the opposite (complementing) value of the input value"
		value	[logic! integer! bitset! typeset!]
		return: [logic! integer! bitset! typeset!]
	]
	#get-definition ACT_COMPLEMENT
]

or~: make action! [[
		"Returns the first value ORed with the second"
		value1	[logic! integer! char! bitset! typeset!]
		value2	[logic! integer! char! bitset! typeset!]
		return:	[logic! integer! char! bitset! typeset!]
	]
	#get-definition ACT_OR~
]

xor~: make action! [[
		"Returns the first value exclusive ORed with the second"
		value1	[logic! integer! char! bitset! typeset!]
		value2	[logic! integer! char! bitset! typeset!]
		return:	[logic! integer! char! bitset! typeset!]
	]
	#get-definition ACT_XOR~
]

;-- Series actions --

append: make action! [[
		"Inserts value(s) at series tail; returns series head"
		series	   [series! bitset!]
		value	   [any-type!]
		/part "Limit the number of values inserted"
			length [number! series!]
		/only "Insert block types as single values (overrides /part)"
		/dup  "Duplicate the inserted values"
			count  [number!]
		return:    [series! bitset!]
	]
	#get-definition ACT_APPEND
]

at: make action! [[
		"Returns a series at a given index"
		series	 [series!]
		index 	 [integer!]
		return:  [series!]
	]
	#get-definition ACT_AT
]

back: make action! [[
		"Returns a series at the previous index"
		series	 [series!]
		return:  [series!]
	]
	#get-definition ACT_BACK
]

;change

clear: make action! [[
		"Removes series values from current index to tail; returns new tail"
		series	 [series! bitset!]
		return:  [series! bitset!]
	]
	#get-definition ACT_CLEAR
]

copy: make action! [[
		"Returns a copy of a non-scalar value"
		value	 [series! any-object! bitset!]
		/part	 "Limit the length of the result"
			length [number! series!]
		/deep	 "Copy nested values"
		/types	 "Copy only specific types of non-scalar values"
			kind [datatype!]
		return:  [series! any-object! bitset!]
	]
	#get-definition ACT_COPY
]

find: make action! [[
		"Returns the series where a value is found, or NONE"
		series	 [series! bitset! any-object! none!]
		value 	 [any-type!]
		/part "Limit the length of the search"
			length [number! series!]
		/only "Treat a series search value as a single value"
		/case "Perform a case-sensitive search"
		/any  "TBD: Use * and ? wildcards in string searches"
		/with "TBD: Use custom wildcards in place of * and ?"
			wild [string!]
		/skip "Treat the series as fixed size records"
			size [integer!]
		/last "Find the last occurrence of value, from the tail"
		/reverse "Find the last occurrence of value, from the current index"
		/tail "Return the tail of the match found, rather than the head"
		/match "Match at current index only and return tail of match"
	]
	#get-definition ACT_FIND
]

head: make action! [[
		"Returns a series at its first index"
		series	 [series!]
		return:  [series!]
	]
	#get-definition ACT_HEAD
]

head?: make action! [[
		"Returns true if a series is at its first index"
		series	 [series!]
		return:  [logic!]
	]
	#get-definition ACT_HEAD?
]

index?: make action! [[
		"Returns the current series index, relative to the head"
		series	 [series!]
		return:  [integer!]
	]
	#get-definition ACT_INDEX?
]

insert: make action! [[
		"Inserts value(s) at series index; returns series head"
		series	   [series! bitset!]
		value	   [any-type!]
		/part "Limit the number of values inserted"
			length [number! series!]
		/only "Insert block types as single values (overrides /part)"
		/dup  "Duplicate the inserted values"
			count  [number!]
		return:    [series! bitset!]
	]
	#get-definition ACT_INSERT
]

length?: make action! [[
		"Returns the number of values in the series, from the current index to the tail"
		series	 [series! bitset!]
		return:  [integer!]
	]
	#get-definition ACT_LENGTH?
]


next: make action! [[
		"Returns a series at the next index"
		series	 [series!]
		return:  [series!]
	]
	#get-definition ACT_NEXT
]

pick: make action! [[
		"Returns the series value at a given index"
		series	 [series! bitset!]
		index 	 [integer! logic! char!]
		return:  [any-type!]
	]
	#get-definition ACT_PICK
]

poke: make action! [[
		"Replaces the series value at a given index, and returns the new value"
		series	 [series! bitset!]
		index 	 [integer! char! logic! block!]
		value 	 [any-type!]
		return:  [series! bitset!]
	]
	#get-definition ACT_POKE
]

remove: make action! [[
		"Returns the series at the same index after removing a value"
		series	 [series! bitset! none!]
		/part "Removes a number of values, or values up to the given series index"
			length [number! char! series!]
		return:  [series! bitset! none!]
	]
	#get-definition ACT_REMOVE
]

reverse: make action! [[
		"Reverses the order of elements; returns at same position"
		series	 [series!]
		/part "Limits to a given length or position"
			length [number! series!]
		return:  [series!]
	]
	#get-definition ACT_REVERSE
]

select: make action! [[
		"Find a value in a series and return the next value, or NONE"
		series	 [series! any-object! none!]
		value 	 [any-type!]
		/part "Limit the length of the search"
			length [number! series!]
		/only "Treat a series search value as a single value"
		/case "Perform a case-sensitive search"
		/any  "TBD: Use * and ? wildcards in string searches"
		/with "TBD: Use custom wildcards in place of * and ?"
			wild [string!]
		/skip "Treat the series as fixed size records"
			size [integer!]
		/last "Find the last occurrence of value, from the tail"
		/reverse "Find the last occurrence of value, from the current index"
		return:  [any-type!]
	]
	#get-definition ACT_SELECT
]

sort: make action! [[
		"Sorts a series (modified); default sort order is ascending"
		series	 [series!]
		/case "Perform a case-sensitive sort"
		/skip "Treat the series as fixed size records"
			size [integer!]
		/compare "Comparator offset, block or function"
			comparator [integer! block! any-function!]
		/part "Sort only part of a series"
			length [number! series!]
		/all "Compare all fields"
		/reverse "Reverse sort order"
		/stable "Stable sorting"
		return:  [series!]
	]
	#get-definition ACT_SORT
]

skip: make action! [[
		"Returns the series relative to the current index"
		series	 [series!]
		offset 	 [integer!]
		return:  [series!]
	]
	#get-definition ACT_SKIP
]

swap: make action! [[
		"Swaps elements between two series or the same series"
		series1  [series!]
		series2  [series!]
		return:  [series!]
	]
	#get-definition ACT_SWAP
]

tail: make action! [[
		"Returns a series at the index after its last value"
		series	 [series!]
		return:  [series!]
	]
	#get-definition ACT_TAIL
]

tail?: make action! [[
		"Returns true if a series is past its last value"
		series	 [series!]
		return:  [logic!]
	]
	#get-definition ACT_TAIL?
]

take: make action! [[
		"Removes and returns one or more elements"
		series	 [series!]
		/part	 "Specifies a length or end position"
			length [number! series!]
		/deep	 "Copy nested values"
		/last	 "Take it from the tail end"
	]
	#get-definition ACT_TAKE
]

trim: make action! [[
		"Removes space from a string or NONE from a block or object"
		series	[series! object! error!]
		/head	"Removes only from the head"
		/tail	"Removes only from the tail"
		/auto	"Auto indents lines relative to first line"
		/lines	"Removes all line breaks and extra spaces"
		/all	"Removes all whitespace"
		/with	"Same as /all, but removes characters in 'str'"
			str [char! string! integer!]
	]
	#get-definition ACT_TRIM
]

;-- I/O actions --

;create
;close
;delete
;modify
;open
;open?
;query
;read
;rename
;update
;write
REBOL [
	Title: "Generates all-reds-tests.txt"
	Author: "Joshua Shireman"
	Version: 0.0.1
	Tabs:	4
	Rights: "Copyright (C) 2015 Joshua Shireman. All rights reserved."
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/origin/BSD-3-License.txt"
]

;; This scans the current Red/System tests directory for filenames with "test-reds" 
;; and generates a file %all-reds-tests.txt file with a list of names.  

all-reds-test-file: %all-reds-tests.txt
all-reds-tests: copy []

write all-reds-test-file {}

read-dir: func [ 
	dir [file!]
][
	foreach file read dir [
		file: either dir = %./ [file][dir/:file]
		append all-reds-tests file
		if dir? file [
			read-dir file
		]
	]
]

read-dir %./

foreach file all-reds-tests [
	if (find file "-test.reds") [
		write/append all-reds-test-file reduce [file newline] 
	]
]
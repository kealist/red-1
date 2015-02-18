REBOL [
	Title:   "Builds and Runs All Red and Red/System Tests"
	File: 	 %run-all.r
	Author:  "Peter W A Wood"
	Version: 0.3.0
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;; function to find and run-tests
run-all-script: func [
	dir [file!]
	file [file!]
][
	qt/tests-dir: system/script/path/:dir
  	foreach line read/lines dir/:file [
  		if any [
			find line "===start-group"
  	  		find line "--run-"
  		][
  			do line
  		]
  	]
]

batch-mode: false
each-mode: false
binary?: false
args: any [system/script/args system/options/args]
if args  [
	;; should we run non-interactively?
	batch-mode: find system/script/args "--batch"
	
	;; should we run each file individually?
	each-mode: find system/script/args "--each"

	;; should we use the binary compiler?
	args: parse system/script/args " "
	if find system/script/args "--binary" [
		binary?: true
		bin-compiler: select args "--binary"
		if any [
			bin-compiler = "--batch"
			bin-complier = "--each"
		][
			bin-compiler: none								;; use default
		]
		if bin-compiler [						
			if not attempt [exists? to file! bin-compiler] [
				either batch-mode [
					write %quick-test/quick-test.log "Invalid compiler path"
					quit/return 1
				][
					print "Invalid compiler path supplied"
					print args
					print ""
					halt
				]
			]
		]
	
	]
]

;; supress script messages
store-quiet-mode: system/options/quiet
system/options/quiet: true
store-current-dir: what-dir

do %quick-test/quick-test.r
qt/tests-dir: clean-path %/tests/

if binary? [
	qt/binary?: binary?
	if bin-compiler [qt/bin-compiler: bin-compiler]
]

qt/tests-dir: clean-path %system/tests/
do %system/tests/source/units/make-red-system-auto-tests.r

qt/tests-dir: clean-path %tests/
do %tests/source/units/run-all-init.r

***start-run-quiet*** "Complete Red Test Suite"

do %tests/source/units/run-all-extra-tests.r

either each-mode [
    do %tests/source/units/auto-tests/run-each-comp.r
    do %tests/source/units/auto-tests/run-each-interp.r
][
    --run-test-file-quiet %source/units/auto-tests/run-all-comp1.red
    --run-test-file-quiet %source/units/auto-tests/run-all-comp2.red
    --run-test-file-quiet %source/units/auto-tests/run-all-interp.red    
]
qt/script-header: "Red/System []"
qt/tests-dir: clean-path %system/tests/ 
run-all-script %system/tests/ %run-all.r

do %tests/source/units/run-all-final.r
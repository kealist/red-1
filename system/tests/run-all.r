REBOL [
  Title:   "Builds and Runs the Red/System Tests"
	File: 	 %run-all.r
	Author:  "Peter W A Wood"
	Version: 0.8.3
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

;; should we run non-interactively?
batch-mode: all [system/options/args find system/options/args "--batch"]

;; supress script messages
store-quiet-mode: system/options/quiet
system/options/quiet: true

do %../../quick-test/quick-test.r
qt/tests-dir: system/script/path

;; set the default script header
qt/script-header: "Red/System []"

;; make auto files if needed
do %source/units/make-red-system-auto-tests.r

;; make -test.reds file lib-test

do %make-reds-test-list.r

print "something 1"
;; read all-reds-tests.txt

reds-tests: read/lines %all-reds-tests.txt

print "something 2"
;; run the tests
print rejoin ["Run-All    v" system/script/header/version]
print rejoin ["Quick-Test v" qt/version]
print rejoin ["REBOL       " system/version]

start-time: now/precise

;; any .reds test with more than one space between --run-test-file-quiet and 
;;  the filename will be excluded from the ARM tests

***start-run-quiet*** "Red/System Test Suite"

===start-group=== "Compiler Tests"
  --run-script-quiet %source/compiler/alias-test.r
  --run-script-quiet %source/compiler/cast-test.r
  --run-script-quiet %source/compiler/comp-err-test.r
  --run-script-quiet %source/compiler/exit-test.r
  --run-script-quiet %source/compiler/int-literals-test.r
  --run-script-quiet %source/compiler/output-test.r
  --run-script-quiet %source/compiler/return-test.r
  --run-script-quiet %source/compiler/cond-expr-test.r
  --run-script-quiet %source/compiler/inference-test.r
  --run-script-quiet %source/compiler/callback-test.r
  --run-script-quiet %source/compiler/infix-test.r
  --run-script-quiet %source/compiler/not-test.r
  --run-script-quiet %source/compiler/print-test.r
  --run-script-quiet %source/compiler/enum-test.r
  --run-script-quiet %source/compiler/pointer-test.r
  --run-script-quiet %source/compiler/namespace-test.r
  --run-script-quiet %source/compiler/compiles-ok-test.r
  --run-script-quiet %source/compiler/dylib-test.r
  ;--run-test-file-quiet %source/compiler/define-test.reds
===end-group===

foreach test all-reds-tests [
  do compose [
    ===start-group=== (test)
      --run-script-quiet (to-file test)
    ===end-group===
  ]
]

***end-run-quiet***

end-time: now/precise
print ["       in" difference end-time start-time newline]
system/options/quiet: store-quiet-mode
either batch-mode [
	quit/return either qt/test-run/failures > 0 [1] [0]
][
	print ["The test output was logged to" qt/log-file]
	ask "hit enter to finish"
	print ""
	qt/test-run/failures
]

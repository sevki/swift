// RUN: %target-swift-frontend -emit-silgen %s -module-name test -swift-version 5 -enable-experimental-concurrency | %FileCheck %s
// REQUIRES: concurrency

func acceptsConcurrent(_: @escaping @concurrent () -> Int) { }

func concurrentWithCaptures(i: Int) -> Int {
  var i = i

  // CHECK: sil private [ossa] @$s4test22concurrentWithCaptures1iS2i_tFSiyJcfU_ : $@convention(thin) @concurrent (@guaranteed { var Int }) -> Int
  acceptsConcurrent {
    i + 1
  }
  i = i + 1

  // CHECK: sil private [ossa] @$s4test22concurrentWithCaptures1iS2i_tF13localFunctionL_SiyJF : $@convention(thin) @concurrent (@guaranteed { var Int }) -> Int
  @concurrent func localFunction() -> Int {
    return i + 1
  }
  acceptsConcurrent(localFunction)
  i = i + 1

  return i
}

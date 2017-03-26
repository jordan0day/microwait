# Microwait

A small library for attempting to perform sub-millisecond waits.

Currently the sleep is implemented as a busy loop, which is not ideal from a
power perspective, but it was easy to write. Future versions may include
optional NIFs for using lower level operations which may be more
power-efficient.

Just call `Microwait.wait_micros(500)` to perform a wait of *at least* 500
microseconds.

Pass a second optional `true` parameter to have the wait internally call
`:erlang.yield()`. This call won't be helpful on multicore machines (and per
the erlang documentation, may actually hurt performance), but might aid overall
performance on single-core machines.

`Microwait.wait_micros(500, true)`

## Future TODOs
* Implement NIF(s) which may use underlying OS-level sleep operations.
* Efficiency improvements, such as using normal `Process.sleep/1` calls when
specified wait times are greater than a millisecond.
* Track BEAM reduction rate.
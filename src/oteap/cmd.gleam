import gleam/erlang/process.{Pid, Subject}

// import gleam/otp/actor
// import gleam/io

pub opaque type Cmd(msg) {
  None
  Task(fn() -> msg)
  Batch(List(Cmd(msg)))
}

pub const none = None

pub fn task(f: fn() -> msg) {
  Task(f)
}

pub fn execute_(subject: Pid, cmd: Cmd(msg)) {
  case cmd {
    None -> Nil

    Task(f) -> {
      let msg = f()
      raw_send(subject, msg)
    }

    Batch([hd, ..tl]) -> {
      execute_(subject, hd)
      execute_(subject, Batch(tl))
    }
  }
}

// UTILS -----------------------------------------------------------------------
pub external fn pid_to_subject(pid: Pid) -> Subject(msg) =
  "ffi" "pid_to_subject"

external fn raw_send(pid: Pid, msg: msg) -> Nil =
  "erlang" "send"

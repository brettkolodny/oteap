import gleam/otp/actor
import gleam/erlang/process.{Pid, Subject}
import oteap/cmd.{Cmd}
import gleam/io

pub type Handler(model, msg) =
  fn(model, msg) -> #(model, Cmd(msg))

pub type Init(init, model, msg) =
  fn() -> #(model, Cmd(msg))

pub type TeaServer(init, model, msg) {
  TeaServer(init: Init(init, model, msg), handler: Handler(model, msg))
}

pub fn start(server: TeaServer(init, model, msg)) {
  let handler = fn(msg: msg, model: model) {
    io.debug("Handler")
    io.debug(process.self())
    let #(model, c) = server.handler(model, msg)
    cmd.execute_(process.self(), c)
    actor.Continue(model)
  }

  let #(model, c) = server.init()

  let maybe_actor = actor.start(model, handler)

  case maybe_actor {
    Ok(subject) -> {
      cmd.execute_(subject_to_pid(subject), c)
      maybe_actor
    }

    _ -> maybe_actor
  }
}

external fn subject_to_pid(sub: Subject(msg)) -> Pid =
  "ffi" "subject_to_pid"

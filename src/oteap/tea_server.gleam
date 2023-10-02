import gleam/erlang/process.{Pid}
import oteap/cmd.{Cmd}

pub type Handler(model, msg) =
  fn(model, msg) -> #(model, Cmd(msg))

pub type Init(model, msg) =
  fn() -> #(model, Cmd(msg))

pub type TeaServer(init, model, msg) {
  TeaServer(init: Init(model, msg), handler: Handler(model, msg))
}

pub fn start(server: TeaServer(init, model, msg)) {
  start_(server)
}

external fn start_(args: TeaServer(init, model, msg)) -> Pid =
  "tea_server" "start"

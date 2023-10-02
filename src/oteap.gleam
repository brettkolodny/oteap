import gleam/io
import gleam/erlang/process
import oteap/tea_server.{TeaServer}
import oteap/cmd.{Cmd}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let server = TeaServer(fn() { init(Nil) }, update)
  let server_ = tea_server.start(server)
  io.debug(server_)
  process.sleep_forever()
}

// MSG -------------------------------------------------------------------------

type Msg {
  Increment
  Decrement
}

// MODEL -----------------------------------------------------------------------

type Model =
  Int

// INIT ------------------------------------------------------------------------

fn init(_: Nil) -> #(Model, Cmd(Msg)) {
  let command =
    fn() {
      process.sleep(1000)
      Increment
    }
    |> cmd.task()

  #(0, command)
}

// UPDATE ----------------------------------------------------------------------

fn update(model: Model, msg: Msg) -> #(Model, Cmd(Msg)) {
  case msg {
    Increment -> {
      let inc_cmd = fn() {
        process.sleep(1000)
        Increment
      }

      #(model + 1, cmd.task(inc_cmd))
    }

    Decrement -> #(model - 1, cmd.none)
  }
}

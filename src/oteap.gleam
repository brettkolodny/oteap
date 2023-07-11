import gleam/io
import gleam/erlang/process.{Pid, Subject}
import oteap/tea_server.{TeaServer}
import oteap/cmd.{Cmd}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let server = TeaServer(fn() { init(Nil) }, update)
  let assert Ok(_actor) = tea_server.start(server)
  process.sleep_forever()

  io.println("Hello from oteap!")
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
  io.debug("Starting!")
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
  io.debug(msg)
  case msg {
    Increment -> {
      let command =
        fn() {
          process.sleep(1000)
          Increment
        }
        |> cmd.task()

      #(model + 1, command)
    }

    Decrement -> #(model - 1, cmd.none)
  }
}


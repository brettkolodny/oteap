-module(tea_server).

-behaviour(gen_server).

-export([init/1, handle_call/3, handle_cast/2, start/1]).

start(Args) ->
    gen_server:start(?MODULE, Args, []).

init({_, Init, Handler}) ->
    {Initial_Model, Cmd} = Init(),
    Initial_State = {{model, Initial_Model}, {handler, Handler}},
    dispatch(Cmd),
    {ok, Initial_State}.

handle_call(_Request, _From, _State) ->
    nil.

handle_cast(Msg, {{model, Model}, {handler, Handler}}) ->
    {New_Model, Cmd} = Handler(Model, Msg),

    dispatch(Cmd),

    New_State = {{model, New_Model}, {handler, Handler}},

    {noreply, New_State}.

%% UITLS

dispatch(Cmd) ->
    Self = self(),

    case Cmd of
        {none} ->
            nil;
        {task, Fun} ->
            spawn(fun() ->
                     Msg = Fun(),
                     gen_server:cast(Self, Msg)
                  end),
            nil;
        {batch, Cmds} ->
            case Cmds of
                [] ->
                    nil;
                [C] ->
                    dispatch(C);
                [Hd | Tl] ->
                    dispatch(Hd),
                    dispatch({batch, Tl});
                _ ->
                    nil
            end;

        _ ->
            nil
    end,

    nil.

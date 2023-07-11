-module(ffi).
-export([pid_to_subject/1, subject_to_pid/1]).

pid_to_subject(Pid) ->
    Pid.

subject_to_pid(Subject) ->
    {_, Pid, _} = Subject,
    Pid.
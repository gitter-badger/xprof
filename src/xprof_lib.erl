-module(xprof_lib).

-export([mfaspec2atom/1,
         mfa2atom/1,
         mfaspec2id/1,
         now2epoch/1,
         set_mode/1,
         get_mode/0,
         get_mode_cb/0,
         prefix/2,
         prefix_rest/2
        ]).

-spec mfaspec2atom(xprof:mfa_spec()) -> xprof:mfa_name().
mfaspec2atom({MFAId, {_MSOff, _MSOn}}) ->
    mfa2atom(MFAId).

-spec mfa2atom(xprof:mfa_id()) -> xprof:mfa_name().
mfa2atom({M, F, '_'}) ->
    list_to_atom(string:join(["xprof_", atom_to_list(M),
                              atom_to_list(F), "_"], "_"));
mfa2atom({M,F,A}) ->
    list_to_atom(string:join(["xprof_", atom_to_list(M),
                              atom_to_list(F), integer_to_list(A)], "_")).

-spec mfaspec2id(xprof:mfa_spec()) -> xprof:mfa_id().
mfaspec2id({MFAId, {_, _}}) ->
    MFAId.

now2epoch({MS, S, _US}) ->
    MS * 1000000 + S.

-spec set_mode(xprof:mode()) -> ok.
set_mode(Mode) when Mode =:= elixir; Mode =:= erlang ->
    application:set_env(xprof, mode, Mode).

-spec get_mode() -> xprof:mode().
get_mode() ->
    case application:get_env(xprof, mode) of
        undefined ->
            Mode = detect_mode(),
            set_mode(Mode),
            Mode;
        {ok, Mode} ->
            Mode
    end.

-spec get_mode_cb() -> module().
get_mode_cb() ->
    case get_mode() of
        erlang -> xprof_erlang_syntax;
        elixir -> xprof_elixir_syntax
    end.

-spec detect_mode() -> xprof:mode().
detect_mode() ->
    case lists:keymember(elixir, 1, application:which_applications()) of
        true -> elixir;
        false -> erlang
    end.

-spec prefix(binary(), binary()) -> boolean().
prefix(Prefix, Bin) ->
    PrefixSize = byte_size(Prefix),
    case Bin of
        <<Prefix:PrefixSize/binary, _/binary>> -> true;
        _ -> false
    end.

-spec prefix_rest(binary(), binary()) -> false | binary().
prefix_rest(Prefix, Bin) ->
    PrefixSize = byte_size(Prefix),
    case Bin of
        <<Prefix:PrefixSize/binary, Rest/binary>> -> Rest;
        _ -> false
    end.

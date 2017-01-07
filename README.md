XProf [![Build Status](https://travis-ci.org/Appliscale/xprof.svg?branch=master)](https://travis-ci.org/Appliscale/xprof) [![Coverage Status](https://coveralls.io/repos/github/Appliscale/xprof/badge.svg?branch=master)](https://coveralls.io/github/Appliscale/xprof?branch=master)
=====

*XProf* is a profiler that allows you to track execution time of Erlang
functions. It's also able to capture arguments and results of a function calls
that lasted longer than given number of milliseconds.

## Goal

*XProf* was created to help solving performance problems of live, highly
concurrent and utilized BE systems. It's often the case that high latency or big
CPU usage is caused by very specific requests that are triggering
inefficient code. Finding this code is usually pretty difficult.

## How to use it

![Demo](xprof_demo.gif)

1. Add `xprof` to your rebar.config (and optionally to `reltool.config` in order to include it into your release).
2. Build your project.
3. Start `xprof` by executing `xprof:start()` in Erlang shell.
4. Go to http://SERVER:7890.
5. Type in function that you would like to start tracing.
6. Start tracing clicking green button.

```erlang
{deps, [
       ...
       {xprof, ".*", {git, "https://github.com/appliscale/xprof.git"}}
]}.
```

`xprof` is available on *Hex* package manager, so you are able to use it also in the following way:

```erlang
%% It is possible only with newest version of `rebar3` (at least `3.3.3`):

{deps, [
       ...
       {xprof, "1.1.0"}
]}.
```

```elixir
# Inside `mix.exs`:

defp deps do
    [
      ...
      {:xprof, "~> 1.1.0"}
    ]
  end
```

## Keyboard shortcuts

- **UP**/**DOWN** arrows: select previous/next item in the dropdown suggestion
  list
- **TAB**: if no suggetion is selected yet auto-complete to longest common
  prefix of dropdown list items. Otherwise copy the selected item to the search
  box and clear the dropdown list.
- **ENTER**: start tracing either the selected suggestion if there is any or the
  expression in the search box.

## Configuration

You can configure `xprof` by changing its application variables:

Key         | Default     | Description
:-----------|:------------|:-----------
`port`      |7890         |Port for the web interface

## XProf flavoured match-spec funs

**CAUTION: Experimental support (WIP).**

In the function browser you can also specify further filters in the form of a
match-spec fun (similar to recon or redbug). After the module and function name
one can also give a function definition instead of arity. This gives the user
the full power of match specifications and can be used both to selectively
measure duration of function calls that match complicated filters and to capture
only part of the arguments. The function has the same limitations as
`dbg:fun2ms/1`. (See
[Match Specifications in Erlang](http://erlang.org/doc/apps/erts/match_spec.html) and
[ms\_transform](http://erlang.org/doc/man/ms_transform.html)). The function can
be terminated by a single dot or `end.` and `return_trace` is always implicitly
on (that is how `xprof` measures duration)

For example only measure the duration of `ets:lookup` on table `data`

```erlang
ets:lookup([data, _]) -> true.
```

Or only capture the `important` field of a possibly big `data` record

```erlang
ets:insert([_, #data{important = I}]) -> message(I).
```

## Contributing

All improvements, fixes and ideas are very welcomed!

Project uses rebar3 for building and testing erlang code. WebUI part resides in
`xprof` app's priv directory and it's already precompiled so there is no need to
build JS sources in order to run `xprof`.

### Running tests

```bash
make test
```

### Working with JS sources

The WebUI uses

* *React.js*
* *ECMAScript 6* (with elements from *7th* version).
* *Bootstap*
* *Bower*
* *Webpack*

All sources are in _priv_ directory. The _app_ folder contains the sources and
the _build_ folder is a placeholder for final JS generated by webpack and then
served by cowboy server (*XProf's* dependency).

### Starting `xprof` in development mode

To develop `xprof` in convenience following setup is recommended.

You have to invoke following command once, if you do not have dependencies or
you need to update them:

```bash
$ make bootstrap_front_end
```

Then going with normal development flow - in the first terminal window start
Erlang `xprof` by calling `make dev`. The _sync_ app will be started, It
automatically reloads erlang modules that have changed, so you don't need to
recompile everytime something changed.

```bash
$ make dev
```

In the second window install all the assets and start *webpack* in development
mode which is also going to recompile all *JS* files in `priv` directory when
they are modified. To achieve that use following command:

```bash
$ make webpack_autoreload
```

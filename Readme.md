[![build](https://github.com/pointfree-wasm/pointfree-wasm.github.io/actions/workflows/ci.yml/badge.svg)](https://github.com/pointfree-wasm/pointfree-wasm.github.io/actions/workflows/ci.yml)

# Synopsis

This is a pretty simple Haskell application that runs entirely in the browser thanks to Web Assembly.

The idea was to try out how WASM Haskell backend would handle a package with non-trivial functionality but without complicated user interface. The [pointfree package](https://hackage.haskell.org/package/pointfree) was great fit since it does interesting transformation while its interface is just a string from a user for input and a list of strings for output.

Apart from working conversion to pointfree in your browser this project might be interesting as a working example on how to use Haskell WASM backend.

# Building and running locally

These steps are made for Linux/MacOS but should work on Windows as well but may require some tweaking.

If in doubt you can check how this project’s CI is set up and copy steps from there: https://github.com/pointfree-wasm/pointfree-wasm.github.io/blob/master/.github/workflows/ci.yml. The advantage of CI is that it’s a working version.

## Step 0 - get ordinary Haskell development up and running

Install `ghc` and `cabal`. A good way to do so is via (`ghcup`)[https://www.haskell.org/ghcup/].

## Step 1 - obtaining GHC WASM backend

Please refer to https://gitlab.haskell.org/ghc/ghc-wasm-meta for detailed instructions.

For example, if you use `nix` package manager then use following flake-based command:

```
$ nix shell https://gitlab.haskell.org/ghc/ghc-wasm-meta/-/archive/master/ghc-wasm-meta-master.tar.gz
```

## Step 2 - ensure `happy` executable is in your PATH

Optionally do `cabal update`, then execute `cabal install happy` with regular ghc.

If you haven’t done so, add cabal’s installation directory to PATH:

```
$ export PATH="$HOME/.cabal/bin:$PATH"
```

Check with `happy --version` that executable is available in the PATH environment variable:

```
$ happy --version
Happy Version 1.20.1.1 Copyright (c) 1993-1996 Andy Gill, Simon Marlow (c) 1997-2005 Simon Marlow

Happy is a Yacc for Haskell, and comes with ABSOLUTELY NO WARRANTY.
This program is free software; you can redistribute it and/or modify
it under the terms given in the file 'LICENSE' distributed with
the Happy sources.
```

NB this step is needed because `haskell-src-exts` depends on the `happy` build tool but `haskell-src-exts` wasn’t updated to let `cabal` quietly provide `happy` during build so `happy` executable has to be on the PATH for the time being.
it
## Step 3 - build WASM file and other dependencies

After `wasm32-wasi-cabal build all` the resulting `.wasm` file will be at the path returned by `wasm32-wasi-cabal list-bin pointfree-wasm:exe:pointfree-wasm`. Link it to the directory where `index.html` is located, i.e. the project’s root:

```
$ ln -s $(wasm32-wasi-cabal list-bin pointfree-wasm:exe:pointfree-wasm) .
```

Next generate `pointfree-wasm.js` that provides some definitions the `.wasm` file requires:

```
$ $(wasm32-wasi-ghc --print-libdir)/post-link.mjs -i $(wasm32-wasi-cabal list-bin pointfree-wasm:exe:pointfree-wasm) -o pointfree-wasm.js
```

## Step 4 - run web server in project’s root

Any web server would do, good starting point is `python3 -m http.server` if Python is installed.

Now you can open the address the web server is running on in the browser and it should work.

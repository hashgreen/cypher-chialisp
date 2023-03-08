# Cypher | chialisp library 🌱

A [chialisp](https://chialisp.com) library to develop smart coins (contracts) on the Chia Blockchain by [Hashgreen Labs](https://www.hashgreen.net).

- Implements standards like [Chia Asset Token (CAT)](https://chialisp.com/cats) and [singleton](https://chialisp.com/singletons/).
- Object-oriented-like interface for easier development.
- Reusable components for building complex contracts.

## Overview

### Installation From Source

Make sure you have [Poetry](https://python-poetry.org) first, then run:

```sh
$ git clone https://github.com/hashgreen/cypher.git && cd cypher
$ poetry shell && poetry install
```

Cypher is planned to be released as a package under [PyPI](https://pypi.org) once it reaches a stable version.


### Quick Start

```sh
$ run --include . tests/test-hello-world.clsp
```

If dependencies are installed correctly, you should see `"hello-world passed"`.

### Usage

Once installed, you can use Cypher in a chialisp contract by importing them with `include`.
The main Cypher library is imported via `cypher.clsp`, and the re-implemented Chia standards can be imported separately from `chia/*.clsp`.

```clojure
(mod ()  ; add variables here
  (include cypher.clsp)
  (include chia/cat-lib.clsp)

  (defun main
    ()  ; begin to write your main logic here about your cool CAT
  )

  (main)
)
```

You can find a list of exported symbols at the end of each file. They look like:

```clojure
;; Exports

(defmacro ... args (c ... args))
```

### Testing

We have included tests for the library, written in chialisp as well under [`tests/`](tests).
To run the test suite, simply run

```sh
$ make -j8 test
```

### Standard Reimplementation

Check out [our reimplementation](chia/) of standard puzzles to understand better how you can use Cypher to achieve your goals.

## What Is Cypher For?

The goals of Cypher are to achieve:

- **Boilerplate Reduction**

  In many official implementations such as [Chia Asset Token](https://github.com/Chia-Network/chia-blockchain/blob/e5bc89e5b6ea36b9e1c65da7c13fdc96cfaae2dd/chia/wallet/puzzles/cat_v2.clvm), we see countless utility functions copied and pasted over and over.
  By importing these utilities from Cypher, the chialisp community can reduce the excessive copy-and-pasting, significantly increase the readability in their implementation, and only focus on the critical logic of their smart coins.

- **Security**

  As we all know, we learn smart contract security by avoiding others' mistakes, and the official standards are [no exception](https://www.chia.net/2022/07/25/upgrading-the-cat-standard/).
  We aim to incorporate logical checks around some commonly used functions, and ensure the invoked usages do not fall for basic exploits.
  If you feel brave and completely understand what you are operating, you will have to explicitly *opt out* by using unsafe variations of the functions to remove these security checks.

- **Common Utilities**

  It is annoying to do complex math, especially if you are writing a functional language.
  We incorporated an array of mathematical utilities ranging from [fractional math](cypher/fracmath.clsp) to [logarithms](cypher/logexpmath.clsp), to make decentralized finance easier.
  There are also [condition-related](cypher/condition_codes.clsp), [macro-related](cypher/macros.clsp) utilities waiting to be explored!

- **Implementation of Standards**

  Learning from the official standards can be a great way to pick up chialisp knowledge, and we refactor the official implementation into chialisp scripts that uses Cypher and are [much more reader-friendly](chia/singleton-v1-1.clsp).

## Considerations

You will have a lot of questions to ask about the design of Cypher.
We do not promise we have answers to all, and yet we strive hard to follow the conventions of the Lisp language and balance it in the context of chialisp.

- **Choice of Namespace**

  If you dive deep enough, you will discover variables exported with different prefixes: no prefix, `cf.`-prefixed, `@cf.`-prefixed, and `%cf.`-prefixed, with the goal of reminding the user the underlying implementation.
  For example, it has been a practice to directly invoke [clvm](https://chialisp.com/clvm) condition codes such as `AGG_SIG_ME` or `CREATE_COIN` with the bare names directly.
  Other constants are less standardized and putting them under the `cf.` namespace sounds more reasonable.

  As for `@cf.` exports like `@cf.and`, we highlight the fact that they are secretly macros which focus on modifying the bodies of parameters they are passed in.

  In the library, there are some other more complex functions (e.g., `cf.log`) that tries to use the argument multiple times, and passing arguments in a inline style would make the compiled program a literal hell as the arguments will be expanded everywhere.
  For these functions the default is to use `defun` to wrap around the arguments, and you can opt out and use `defun-inline` by doing `%cf.log` if you know what you are doing.

- **Object-Oriented-Like**

  Lisp is an elegant functional language that has existed for decades.
  Why make it OOP -- you might ask.
  This generation of programmers are just too spoiled by object-oriented programming that they cannot simply awe the beauty of Lisp, or its descendant, chialisp.
  Hence OOP we must... We must...

- **`.clsp`, `.clvm`, or `.clib`?**

  There is a long debate how one should name a chialisp implementation file, or a compiled chialisp script, or even a hex file.
  Across the board, there are who love [`.clvm` extensions](https://github.com/Chia-Network/chia-blockchain/tree/1.7.0/chia/wallet/puzzles) and who love [`.clsp` extensions](https://github.com/Chia-Network/internal-custody/blob/0.2.2/cic/clsp/singleton/singleton_top_layer_v1_1.clsp).
  That said, we decided to name chialisp implementations `.clsp`, compiled [low-level language](https://chialisp.com/clvm) `.clvm`, and hex-serialized bytecode `.clvm.hex`.
  We will not include a commonly used extension `clib`, as everything we write are honestly library code, and it would look very much like we are writing library for C language for someone who does not have a sufficient context.

## Caveats

There is a pretty significant caveat of using Cypher -- the compile time for your chialisp program may be excruciatingly long!
This is because in the implementation of the [official compiler](https://github.com/Chia-Network/clvm_tools_rs) reads all symbols and consider all of them in each step of the optimization.
Importing Cypher by `(import cypher.clsp)` would trigger this by introducing all symbols into your program.

For example, compiling the refactored singleton v1.1 took ~70s on a reasonably well machine.
```sh
$ run --include . chia/singleton-v1-1.clsp > chia/singleton-v1-1.clvm
```

There are two options to go: you an either directly import the desired second-level library by `(import cypher/math.clsp)`, or you can wait until this [new compiler](https://github.com/Chia-Network/clvm_tools_rs/blob/a660ce7ce07064a6a81bb361f169f6de195cba10/README.md?plain=1#L40-L43) to mature, and hopefully compiles everything blazingly fast!

## Contribute

Be a contributor by opening up an issue or pull request!

## License

Cypher is released under [Apache 2.0](LICENSE).

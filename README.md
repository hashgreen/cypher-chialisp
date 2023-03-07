# Cypher | chialisp library

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

## What Is Cypher For?

The goals of Cypher are to achieve:

- **Boilerplate Reduction**:
  In many official implementations such as [Chia Asset Token](https://github.com/Chia-Network/chia-blockchain/blob/e5bc89e5b6ea36b9e1c65da7c13fdc96cfaae2dd/chia/wallet/puzzles/cat_v2.clvm), we see countless utility functions copied and pasted over and over.
  By importing these utilities from Cypher, the chialisp community can reduce the excessive copy-and-pasting, significantly increase the readability in their implementation, and only focus on the critical logic of their smart coins.

- **Security**:
  As we all know, we learn smart contract security by avoiding others' mistakes, and the official standards are [no exception](https://www.chia.net/2022/07/25/upgrading-the-cat-standard/).
  We aim to incorporate logical checks around some commonly used functions, and ensure the invoked usages do not fall for basic exploits.
  If you feel brave and completely understand what you are operating, you will have to explicitly *opt out* by using unsafe variations of the functions to remove these security checks.

- **Common Utilities**:
  It is annoying to do complex math, especially if you are writing a functional language.
  We incorporated an array of mathematical utilities ranging from [fractional math](cypher/fracmath.clsp) to [logarithms](cypher/logexpmath.clsp), to make decentralized finance easier.
  There are also [condition-related](cypher/condition_codes.clsp), [macro-related](cypher/macros.clsp) utilities waiting to be explored!

- **Implementation of Standards**:
  Learning from the official standards can be a great way to pick up chialisp knowledge, and we refactor the official implementation into chialisp scripts that uses Cypher and are [much more reader-friendly](chia/singleton-v1-1.clsp).


### Considerations

- language: % @
- docstring
- pseudo oop
- clsp clvm clib


### Roadmap

## Contribute

```sh
make -j8 test
```

## License

RESP (Redis Serialization Protocol)
====================

This is a standalone version of the excellent work done by Falko Peters' Haskell Redis library (Hedis).

Included are some slight modifications & criterion benchmarks. More benchmarks and tests are planned.


Why?
---------------------

In case we want to use RESP without redis. Also, to showcase this beast RESP parser.


To install
---------------------
git clone https://github.com/adarqui/RESP
cabal sandbox init
cabal-install (or cabal-meta install)


An example
---------------------
    $ ./dist/build/simple/simple 1 2 3 4 5
    request: "*5\r\n$1\r\n1\r\n$1\r\n2\r\n$1\r\n3\r\n$1\r\n4\r\n$1\r\n5\r\n"
    reply: Just (MultiBulk (Just [Bulk (Just "1"),Bulk (Just "2"),Bulk (Just "3"),Bulk (Just "4"),Bulk (Just "5")]))

    $ for i in `seq 1 10000`; do echo $i; done | xargs ./dist/build/simple/simple
    ...
The repl
---------------------
cabal repl


Benchmarks
---------------------
cabal bench


Tests
---------------------


LICENSE
---------------------
See ./LICENSE

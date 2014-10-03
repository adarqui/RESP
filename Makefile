all:
	cabal sandbox init
	cabal install

clean:
	cabal clean

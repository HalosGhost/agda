GHC_PACKAGE_PATH ?= $(PWD)/.cabal-sandbox/x86_64-linux-ghc-8.0.1-packages.conf.d/:
PROJECTS = fizzbuzz hw

.PHONY: all clean prep bins pdfs

all: clean prep bins pdfs

clean:
	@rm -rf build

prep:
	@mkdir -p build/{pdf,bin}
	@cabal sandbox init
	@cabal update
	@cabal install text

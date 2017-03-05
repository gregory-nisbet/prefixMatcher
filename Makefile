.PHONY: all sandbox clean test realclean testdeps tabularasa

all: sandbox
	cabal --require-sandbox install

sandbox:
	test -d .cabal-sandbox || (cabal sandbox init ; cabal update)

# clean editor backups, .hi files, and .o files
clean:
	find src test -type f -name '*~' -exec $(RM) {} \;
	find src test -type f -name '*.hi' -exec $(RM) {} \;
	find src test -type f -name '*.o' -exec $(RM) {} \;
	$(RM) ./*~ ./.*~ ||:
	$(RM) ./*.hi ./*.o ||:

test: sandbox
	cabal --require-sandbox test

testdeps:
	cabal --require-sandbox install "test-framework >=0.8.1" "test-framework-hunit >=0.3" "HUnit >=1.5"

realclean: clean
	$(RM) -rf dist ||:
	$(RM) -rf cabal.sandbox.config .cabal-sandbox ||:

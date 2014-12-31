UNAME:=$(shell uname -s)

ifeq ($(UNAME),Darwin)
EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
else
EMACS=emacs
endif
LIB=init mylib rc.d

.PHONY: build test

build: build-init build-mylib build-rc.d

build-init:
	$(EMACS) --batch -Q -L . --eval \
		"(progn \
		(batch-byte-compile))" init/*.el

build-mylib:
	$(EMACS) --batch --eval \
		"(progn \
		(batch-byte-compile))" mylib/*.el

build-rc.d:
	$(EMACS) --batch --eval \
		"(progn \
		(batch-byte-compile))" rc.d/*.el

clean:
	rm -f init/*.elc mylib/*.elc rc.d/*.elc

test: build
	$(EMACS) --batch -Q -L . -l test/run-test.el

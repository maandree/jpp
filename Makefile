SHELL = "bash"


default: all

all: jpp


jpp:


install:

uninstall:

clean:
	[[ -d "./bin" ]] &&  rm -r "./bin/"


.PHONY: clean uninstall install


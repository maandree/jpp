default: all

all: gcj


gcj:
	gcj --classpath="./src/" --bootclasspath="/usr/share/classpath/glibj.zip" -fsource="6" --encoding="utf-8"  \
	     -static-libgcj -fno-bounds-check -fno-store-check  --disable-assertions -freduced-reflection          \
	     -Wall --main="jpp.Program" `find ./src/ | grep \\.java\$$`


install:

uninstall:

clean:
	[[ -d "./bin" ]] &&  rm -r "./bin/"


.PHONY: clean uninstall install


default: all

all: javac


javac:
	mkdir -p "./bin/"
	javac -cp "./src/" -d "./bin/" `find ./src/ | grep \\.java\$$`

gcj:
	gcj --classpath="./src/" --bootclasspath="/usr/share/classpath/glibj.zip" -fsource="6" --encoding="utf-8"  \
	     -static-libgcj -fno-bounds-check -fno-store-check  --disable-assertions -freduced-reflection          \
	     -Wall --main="jpp.Program" `find ./src/ | grep \\.java\$$`


install:

uninstall:

clean:
	[[ -d "./bin" ]] &&  rm -r "./bin/"


.PHONY: clean uninstall install


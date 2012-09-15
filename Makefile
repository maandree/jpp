default: all

all: javac jar


javac:
	mkdir -p "./bin/"
	javac -cp "./src/" -d "./bin/" `find ./src/ | grep \\.java\$$`

jar: javac
	cp -r "./META-INF" "./bin"
	(cd "./bin"; \
	 jar -cfm "../jpp.jar" "META-INF/MANIFEST.MF" `find ./ | grep \\.class\$$` )

#gcj:
#	gcj --classpath="./src/" --bootclasspath="/usr/share/classpath/glibj.zip" -fsource="6" --encoding="utf-8"  \
#	     -static-libgcj -fno-bounds-check -fno-store-check  --disable-assertions -freduced-reflection          \
	     -Wall --main="jpp.Program" `find ./src/ | grep \\.java\$$`


install: jar
	mkdir -p "$(DESTDIR)/usr/lib"
	install -m 644 "jpp.jar" "$(DESTDIR)/usr/lib/"
	echo 'java -jar "/usr/lib/jpp.jar" "$$@"' > "$(DESTDIR)/usr/bin/jpp"
	chmod 755 "$(DESTDIR)/usr/bin/jpp"

uninstall:
	[[ -f "/usr/bin/jpp"     ]] &&  unlink "/usr/bin/jpp"
	[[ -f "/usr/lib/jpp.jar" ]] &&  unlink "/usr/lib/jpp.jar"

clean:
	[[ -d "./bin" ]] &&      rm -r  "./bin/"
	[[ -f "./jpp.jar" ]] &&  unlink "./jpp.jar"


.PHONY: clean uninstall install


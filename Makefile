# Copyright © 2012, 2013  Mattias Andrée (maandree@member.fsf.org)
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
# 
# [GNU All Permissive License]

PREFIX=/usr
BIN=/bin
DATA=/share
LICENSES=$(DATA)/licenses
PKGNAME=jpp
COMMAND=jpp
BINJAR=$(DATA)/misc

BOOK=jpp
BOOKDIR=info/



all: code info

code: jpp javac jar

jpp: bin/jpp
bin/jpp:
	mkdir -p "./bin/"
	echo 'java -jar "$(PREFIX)$(BINJAR)/jpp.jar" "$$@"' > "bin/jpp"
	chmod a+x bin/jpp

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
#	     -Wall --main="jpp.Program" `find ./src/ | grep \\.java\$$`

info: $(BOOK).info.gz
%.info: $(BOOKDIR)%.texinfo
	$(MAKEINFO) "$<"
%.info.gz: %.info
	gzip -9c < "$<" > "$@"


pdf: $(BOOK).pdf
%.pdf: $(BOOKDIR)%.texinfo
	texi2pdf "$<"

pdf.gz: $(BOOK).pdf.gz
%.pdf.gz: %.pdf
	gzip -9c < "$<" > "$@"

pdf.xz: $(BOOK).pdf.xz
%.pdf.xz: %.pdf
	xz -e9 < "$<" > "$@"


dvi: $(BOOK).dvi
%.dvi: $(BOOKDIR)%.texinfo
	$(TEXI2DVI) "$<"

dvi.gz: $(BOOK).dvi.gz
%.dvi.gz: %.dvi
	gzip -9c < "$<" > "$@"

dvi.xz: $(BOOK).dvi.xz
%.dvi.xz: %.dvi
	xz -e9 < "$<" > "$@"


install: install-cmd install-license install-info

install-cmd: bin/jpp jpp.jar
	mkdir -p "$(DESTDIR)$(PREFIX)$(BIN)"
	mkdir -p "$(DESTDIR)$(PREFIX)$(BINJAR)"
	install -m 755 "bin/jpp" "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	install -m 644 "jpp.jar" "$(DESTDIR)$(PREFIX)$(BINJAR)/jpp.jar"

install-license:
	mkdir -p "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -m 644 COPYING LICENSE "$(DESTDIR)$(PREFIX)$(DATA)$(LICENSES)/$(PKGNAME)"

install-info: $(BOOK).info.gz
	mkdir -p "$(DESTDIR)$(PREFIX)$(DATA)/info"
	install -m 644 "$(BOOK).info.gz" "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

uninstall:
	-rm "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	-rm "$(DESTDIR)$(PREFIX)$(BINJAR)/jpp.jar"
	-rm "$(DESTDIR)$(PREFIX)$(DATA)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm "$(DESTDIR)$(PREFIX)$(DATA)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rmdir "$(DESTDIR)$(PREFIX)$(DATA)$(LICENSES)/$(PKGNAME)"
	-rm "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

clean:
	-rm -r *.{t2d,aux,cp,cps,fn,ky,log,pg,pgs,toc,tp,vr,vrs,op,ops,bak,info,pdf,ps,dvi,gz} jpp.jar bin 2>/dev/null

.PHONY: clean uninstall install all jar javac


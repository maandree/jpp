# Copyright © 2012, 2013  Mattias Andrée (maandree@member.fsf.org)
# 
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
# 
# [GNU All Permissive License]

PREFIX=/usr

PROGRAM=jpp
BOOK=$(PROGRAM)
BOOKDIR=info/

all: javac jar info


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


install:
	mkdir -p "$(DESTDIR)$(PREFIX)/lib"
	install -m 644 "jpp.jar" "$(DESTDIR)$(PREFIX)/lib/"
	mkdir -p "$(DESTDIR)$(PREFIX)/bin"
	echo 'java -jar "$(PREFIX)/lib/jpp.jar" "$$@"' > "$(DESTDIR)$(PREFIX)/bin/jpp"
	chmod 755 "$(DESTDIR)$(PREFIX)/bin/jpp"
	mkdir -p "$(DESTDIR)$(PREFIX)/share/licenses/$(PROGRAM)"
	mkdir -p "$(DESTDIR)$(PREFIX)/share/info/"
	install -m 644 COPYING "$(DESTDIR)$(PREFIX)/share/licenses/$(PROGRAM)"
	install -m 644 LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/$(PROGRAM)"
	install -m 644 "$(BOOK).info.gz" "$(DESTDIR)$(PREFIX)/share/info"

uninstall:
	unlink "$(DESTDIR)$(PREFIX)/bin/jpp"
	unlink "$(DESTDIR)$(PREFIX)/lib/jpp.jar"
	rm -r "$(DESTDIR)$(PREFIX)/share/licenses/$(PROGRAM)"
	unlink "$(DESTDIR)$(PREFIX)/share/info/$(BOOK).info.gz"

clean:
	[[ -d "./bin" ]] &&      rm -r  "./bin/"
	[[ -f "./jpp.jar" ]] &&  unlink "./jpp.jar"
	rm -r *.{t2d,aux,cp,cps,fn,ky,log,pg,pgs,toc,tp,vr,vrs,op,ops,bak,info,pdf,ps,dvi,gz} 2>/dev/null || exit 0

.PHONY: clean uninstall install all jar javac


# Copyright © 2012, 2013  Mattias Andrée (m@maandree.se)
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
JAVA = java
JAVA_PREFIX = /usr
JAVA_PATH = $(JAVA_PREFIX)$(BIN)/$(JAVA)
SHEBANG = $(JAVA_PATH) -jar

BOOK=jpp
BOOKDIR=info/

JAVA_CLASSES = $(shell find src | grep '\.java$$' | sed -e 's:^src/:bin/:g' -e 's/\.java$$/\.class/g')



.PHONY: all
all: code info

.PHONY: code
code: jpp

.PHONY: javac
javac: $(JAVA_CLASSES)

bin/%.class: src/%.java
	@mkdir -p bin
	javac -cp "src" -d "bin" "$<"

.PHONY: jar
jar: bin/jpp.jar
bin/jpp.jar: $(JAVA_CLASSES) META-INF/MANIFEST.MF
	jar -cfm "$@" META-INF/MANIFEST.MF $(shell find bin | grep '\.class$$' | sed -e 's:^bin/:-C bin :g' -e 's_\$$_"\$$"_g')

.PHONY: jpp
jpp: bin/jpp.install

bin/jpp.install: bin/jpp.jar
	(echo '#!$(SHEBANG)' ; cat "$<") > "$@"
	chmod a+x "$@"

#gcj:
#	gcj --classpath="./src/" --bootclasspath="/usr/share/classpath/glibj.zip" -fsource="6" --encoding="utf-8"  \
#	     -static-libgcj -fno-bounds-check -fno-store-check  --disable-assertions -freduced-reflection          \
#	     -Wall --main="jpp.Program" `find ./src/ | grep \\.java\$$`


.PHONY: info
info: $(BOOK).info.gz
%.info: $(BOOKDIR)%.texinfo
	$(MAKEINFO) "$<"
%.info.gz: %.info
	gzip -9c < "$<" > "$@"


.PHONY: pdf
pdf: $(BOOK).pdf
%.pdf: $(BOOKDIR)%.texinfo
	texi2pdf "$<"

.PHONY: pdf.gz
pdf.gz: $(BOOK).pdf.gz
%.pdf.gz: %.pdf
	gzip -9c < "$<" > "$@"

.PHONY: pdf.xz
pdf.xz: $(BOOK).pdf.xz
%.pdf.xz: %.pdf
	xz -e9 < "$<" > "$@"


.PHONY: dvi
dvi: $(BOOK).dvi
%.dvi: $(BOOKDIR)%.texinfo
	$(TEXI2DVI) "$<"

.PHONY: dvi.gz
dvi.gz: $(BOOK).dvi.gz
%.dvi.gz: %.dvi
	gzip -9c < "$<" > "$@"

.PHONY: dvi.xz
dvi.xz: $(BOOK).dvi.xz
%.dvi.xz: %.dvi
	xz -e9 < "$<" > "$@"


.PHONY: install
install: install-cmd install-license install-info

.PHONY: install-cmd
install-cmd: bin/jpp.install
	mkdir -p -- "$(DESTDIR)$(PREFIX)$(BIN)"
	install -m 755 bin/jpp.install -- "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"

.PHONY: install-license
install-license:
	mkdir -p -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	install -m 644 COPYING LICENSE -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"

.PHONY: install-info
install-info: $(BOOK).info.gz
	mkdir -p -- "$(DESTDIR)$(PREFIX)$(DATA)/info"
	install -m 644 "$(BOOK).info.gz" -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(PREFIX)$(BIN)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(PREFIX)$(LICENSES)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(PREFIX)$(DATA)/info/$(PKGNAME).info.gz"

.PHONY: clean
clean:
	-rm -r *.{t2d,aux,cp,cps,fn,ky,log,pg,pgs,toc,tp,vr,vrs,op,ops,bak,info,pdf,ps,dvi,gz} bin 2>/dev/null


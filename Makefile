FILE=main

LATEX=lualatex
BIBTEX=bibtex

LATEX_OPTS=-interaction=nonstopmode -halt-on-error

all: document

four-times:
	./helpers/four-times.sh

document:
	$(LATEX) $(LATEX_OPTS) $(FILE).tex

html:
	asciidoctor -D output stillness-flowing.adoc

epub:
	./helpers/generate_epub.sh $(FILE)

epub-validate:
	EPUBCHECK=~/bin/epubcheck asciidoctor-epub3 -D output -a ebook-validate main.adoc

mobi:
	./helpers/generate_mobi.sh $(FILE)

preview:
	latexmk -pvc $(FILE).tex

chapters-to-asciidoc:
	./helpers/chapters_to_asciidoc.sh

chapters-to-docx:
	./helpers/chapters_to_docx.sh

stylus-watch:
	stylus -w ./vendor/asciidoctor-epub3/assets/styles/*.styl -o ./vendor/asciidoctor-epub3/data/styles/

dist-html:
	cp doc/*.html ../prophecy-template-html && cp -r doc/images/*.jpg ../prophecy-template-html/images/

tangle-prophecy:
	cd doc && emacs --batch -L -l 'prophecy.org' --eval "(require 'org)" --eval '(org-babel-tangle "prophecy.org")'

export-prophecy-to-tex:
	cd doc && emacs --batch -L -l 'prophecy.org' -l 'export-init.el' --eval '(progn (setq org-export-with-toc nil)(org-latex-export-to-latex))'

export-prophecy-to-html:
	@echo "Use M-x org-export-dispatch from emacs."

# FIXME doesn't export with css theme.
# cd doc && emacs --batch -L -l 'prophecy.org' -l 'export-init.el' --eval '(progn (setq org-export-with-toc t)(org-html-export-to-html))'

prophecy.cls: tangle-prophecy

prophecy.pdf: export-prophecy-to-tex
	cd doc && latexmk prophecy.tex

clean:
	+rm -fv $(FILE).{dvi,ps,pdf,aux,log,bbl,blg}


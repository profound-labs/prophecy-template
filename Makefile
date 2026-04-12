FILE=main

LATEX=latexmk
BIBTEX=bibtex

LATEX_OPTS=-interaction=nonstopmode -halt-on-error -lualatex

all: document

dist:
	./helpers/dist.sh

serve:
	python3 -m http.server -d gh-pages/ 5000

ebooks:
	./helpers/ebooks.sh

pdf-to-ebooks-docs: document
	cp main.pdf manuscript/markdown/assets/docs/The-Book.pdf

four-times:
	./helpers/four-times.sh

document:
	$(LATEX) $(LATEX_OPTS) $(FILE).tex

preview:
	latexmk -pvc $(FILE).tex

sass:
	sass --no-source-map ./assets/sass:./assets/stylesheets

sass-watch:
	sass --watch --no-source-map ./assets/sass:./assets/stylesheets

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


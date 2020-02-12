template := eisvogel.latex
font := SourceHanSansCN-Regular
highlight_style := pygments

all: doc

doc: docgen/gitflow_doc.pdf

docgen/gitflow_doc.pdf: gitflow_doc.md
	pandoc $< --pdf-engine xelatex -o $@ --from markdown --template docgen/${template} -V CJKmainfont=${font} --highlight-style ${highlight_style}

clean:
	rm -rf *.pdf

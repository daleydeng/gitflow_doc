template := eisvogel.latex
font := SourceHanSansCN-Regular
highlight_style := pygments
all: doc

doc: gitflow_doc.pdf

gitflow_doc.pdf: gitflow_doc.md
	pandoc $< --pdf-engine xelatex -o $@ --from markdown --template ${template} -V CJKmainfont=${font} --highlight-style ${highlight_style}

clean:
	rm -rf *.pdf

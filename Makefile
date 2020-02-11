template := eisvogel.latex
font := SourceHanSansCN-Regular

all: doc

doc: gitflow_doc.pdf

gitflow_doc.pdf: gitflow_doc.md
	pandoc $< --pdf-engine xelatex -o $@ --from markdown --template ${template} -V CJKmainfont=${font} --listings

clean:
	rm -rf *.pdf

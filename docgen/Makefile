template := eisvogel.latex
font := SourceHanSansCN-Regular
highlight_style := pygments

all: pdf site

pdf: gitflow_doc.pdf

gitflow_doc.pdf: ../gitflow_doc.md
	pandoc $< --pdf-engine xelatex -o $@ --from markdown --template ${template} -V CJKmainfont=${font} --highlight-style ${highlight_style} --resource-path=../

site:
	mkdocs build

clean:
	rm -rf *.pdf site

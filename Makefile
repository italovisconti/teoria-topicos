# Vista previa local del sitio (requiere: pip install -r requirements-docs.txt)
PY ?= python3

.PHONY: serve build clean

prep:
	@rm -rf .site-src && mkdir -p .site-src
	@cp -r assets Patrones "Unidades Adicionales" Ejercicios .site-src/
	@cp *.md LICENSE .site-src/

serve: prep  ## http://127.0.0.1:8000
	$(PY) -m mkdocs serve

build: prep
	$(PY) -m mkdocs build --site-dir _site

clean:
	@rm -rf .site-src _site

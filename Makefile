# Makefile: ビルドルールを指定する

# --------------------------------------------------------
# 変数（設定）
# --------------------------------------------------------

# シェルコマンドを実行する際のシェルを指定
SHELL := /bin/bash

# ディレクトリ
# tmp_dir       := tmp
input_dir_md     := src
input_dir_latex  := src/LaTeX
output_dir_latex := src/LaTeX/out
output_dir_img   := img
config_dir       := config

# 入力ファイル（Markdown）
# 101_ のような接頭辞の順に、ファイルをソートして並べる
input_files_md := $(sort $(wildcard $(input_dir_md)/*.md))

# 出力ファイル
output_file_html := index.html

# Pandocのオプション
pandoc_options := --standalone
pandoc_options += --number-section
pandoc_options += --toc
pandoc_options += --shift-heading-level-by=0
pandoc_options += -f markdown+tex_math_single_backslash
pandoc_options += --data-dir=.
pandoc_options += --katex=https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.12.0/
pandoc_options += --template=elegant_bootstrap_menu.html
pandoc_options += -M title="視点学の基礎"
pandoc_options += -M author="視点学たん (@viewpointicstan)"

# --------------------------------------------------------
# ビルドルール（PDF生成用）
# --------------------------------------------------------

# make と打ったときのデフォルトターゲット
.DEFAULT_GOAL := html

# HTMLを生成する
.PHONY: html
html: 
	pandoc $(input_files_md) $(pandoc_options) -o $(output_file_html) 

# make diagram: 可換図式 (LaTeX) を out/ 以下に生成する
.PHONY: diagram
diagram: 
	# pLaTeXでPDFを生成する
	cd $(input_dir_latex) && ls *.tex | xargs -I {} cluttex -e platex {}
	# 生成したものを out/tmp ディレクトリに移動する
	mkdir -p $(output_dir_latex)/tmp
	mv $(input_dir_latex)/*.pdf $(output_dir_latex)/tmp
	# PDFの不要な空白領域を削除する（crop）→ *-crop.pdf が生成される
	ls $(output_dir_latex)/tmp/*.pdf | xargs -I {} pdfcrop {}
	# *-crop.pdf を *.pdf にリネーム
	cd $(output_dir_latex)/tmp && ls *-crop.pdf | \
	  sed -e 's/-crop.pdf//' | \
	  xargs -I {} mv {}-crop.pdf ../{}.pdf
	# 元のPDFを削除
	rm -rf $(output_dir_latex)/tmp
	# PDFをPNG画像に変換する
	ls $(output_dir_latex)/*.pdf | \
	  sed -e 's/.pdf//' | \
	  xargs -I {} pdftoppm -png -singlefile {}.pdf {}
	# PNG画像をimgディレクトリに移動
	mkdir -p $(output_dir_img)
	mv $(output_dir_latex)/*.png $(output_dir_img)

# make clean-latex: 生成した可換図式 (LaTeX) を削除する
.PHONY: clean-diagram
clean-diagram:
	rm -rf $(output_dir_latex)/

# make clean-html: 生成したHTMLを削除する
.PHONY: clean-html
clean-html:
	rm -f $(output_file_html)

# make clean: 生成したファイル群を削除する
.PHONY: clean
clean:
	make clean-diagram
	make clean-html


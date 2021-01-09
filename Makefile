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
config_dir       := config

# 入力ファイル（Markdown）
# 01_ のような接頭辞の順に、ファイルをソートして並べる
# ただし「執筆用メモ」は除外する
input_files_md := $(sort $(wildcard $(input_dir_md)/**/*.md))

# --------------------------------------------------------
# ビルドルール（PDF生成用）
# --------------------------------------------------------

# make と打ったときのデフォルトターゲット
.DEFAULT_GOAL := print

# make diagram: 可換図式 (LaTeX) を out/ 以下に生成する
.PHONY: diagram
diagram:
	cd $(input_dir_latex) && ls *.tex | xargs -I {} cluttex -e platex {}
	mkdir -p $(output_dir_latex)
	mv $(input_dir_latex)/*.pdf $(output_dir_latex)/
	rm -rf $(output_dir_latex)/*-crop.pdf
	ls $(output_dir_latex)/*.pdf | xargs -I {} pdfcrop {}

# make clean-latex: 生成した可換図式 (LaTeX) を削除する
.PHONY: clean-latex
clean-latex:
	rm -rf $(output_dir_latex)/

# make clean: 生成したファイル群を削除する
.PHONY: clean
clean:
	make clean-latex

# .PHONY: list
# list:
# 	echo $(input_files_md) | tr ' ' '\n'


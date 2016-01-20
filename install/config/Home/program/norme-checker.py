#! /usr/bin/python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser, FileType
import io
import re

testerror = 0

def printerror (file, i, line, str):
	global testerror
	testerror = 1
	print "line",i,"|",file.name,">",line,"\033[31m===",str,"=== \033[0m"

def cleanline (line):
	posr = 0
	write = True
	maxi = len(line)
	ret = ""
	while posr < maxi:
		if line[posr] == '\\' and not write:
			posr += 1
		elif line[posr] == '"':
			write = not write
			ret += line[posr]
		elif write and line[posr] and line[posr]:
			ret += line[posr]
		posr += 1
	if write:
		return ret
	else:
		return line

def global_test(i, line, file):
	global testerror
	if line.find("\/\/") != -1:
		printerror(file, i, line, "Commentaire c++")
	if line.find(" \n") != -1 or line.find("\t\n") != -1:
		printerror(file, i, line, "SPACE END LINE")
	if line.find(" \t") != -1:
		printerror(file, i, line, "SPACE TAB")
	if line.find("\t ") != -1:
		printerror(file, i, line, "TAB SPACE")
	if re.match(".+  ", line) != None and re.match("^\*\*", line) == None:
		printerror(file, i, line, "Double espace")
	if line.find(" ;") != -1 and line.find("continue ;") == -1 and line.find("return ;") == -1 and line.find("break ;") == -1:
		printerror(file, i, line, "Espace ;")
	if line.find('+') != -1 and (line.find(' + ') == -1 and line.find(' += ') == -1 and line.find('++') == -1 and line.find('\'+\'') == -1):
		printerror(file, i, line, "+ collé")
	#if re.search("([0-9]\-)|([^=] *-[0-9])", line) != None:
	#    print i,line,"\tmoins colle"
	if re.search('\*[0-9]', line) != None:
		printerror(file, i, line, "* collé")
	if line.find('/') != -1 and (line.find("\'/\'") == -1 and line.find(' / ') == -1 and line.find(' /= ') == -1 and line.find('*/') == -1 and line.find('/*') == -1 and re.search('^#' , line) == None and re.match("^\*\*", line) == None) and re.match("^\*\*", line) == None:
		printerror(file, i, line, "/ collé")
	if line.find('%') != -1 and (line.find('\'%\'') == -1 and line.find(' % ') == -1 and line.find(' %= ') == -1) and re.match("^\*\*", line) == None:
		printerror(file, i, line, "% collé")
	if line.find(' ,') != -1:
		printerror(file, i, line, "SPACE ,")
	if re.search(',\S', line) != None:
		printerror(file, i, line, ", SPACE")
	if line.find('( ') != -1:
		printerror(file, i, line, "( SPACE")
	if line.find(' )') != -1:
		printerror(file, i, line, "SPACE )")
	if line.find('=') != -1 and line.find('>=') == -1 and line.find('|=') == -1 and line.find('&=') == -1 and line.find('<=') == -1 and re.search(" [!=/*+-]?= ", line) == None and re.match("^\*\*", line) == None:
		printerror(file, i, line, "= collé")
	if re.search(r'\bmalloc\b', line) != None and (line.find(')malloc') == -1 and line.find(') malloc') == -1 and line.find("ft_memalloc") == -1) and re.match("^\*\*", line) == None:
		printerror(file, i, line, "Cast malloc")
	if re.search(r'\bdefine\b', line) != None and re.search('[A-Z]', line) == None:
		printerror(file, i, line, "define macro sans MAJ")
	if re.search(r'\breturn\b', line) != None and (line.find('return (') == -1 and line.find("return ;") == -1) and re.match("^\*\*", line) == None:
		printerror(file, i, line, "return sans espace")
	if re.search(r'\bfor\b', line) != None and line.find('for (') == -1 and line.find('\tfor') != -1 and re.match("^\*\*", line) == None:
		printerror(file, i, line, "for sans espace")
	if re.search(r'\bwhile\b', line) != None and line.find('while (') == -1 and re.match("^\*\*", line) == None:
		printerror(file, i, line, "while sans espace")
	#if line.find('sizeof') != -1 and line.find('sizeof ') == -1:
	#    print i,line,"sizeof sans espace"
	if re.search(r'\btypedef\b', line) != None and line.find('typedef ') == -1:
		printerror(file, i, line, "typedef sans espace")
	if re.search(r'\bif\b', line) != None and (line.find('if (') == -1 and line.find('ifndef') == -1 and line.find('ifdef') == -1 and line.find("endif") == -1) and re.match("^\*\*", line) == None:
		printerror(file, i, line, "if sans espace")
	if re.search(r'\bstruct\b', line) != None and (line.find('typedef struct\t') == -1 and line.find('struct ') == -1) and re.match("^\*\*", line) == None:
		printerror(file, i, line, "struct sans tab")
	if re.search(r'\benum\b', line) != None and line.find('enum\t') == -1:
		printerror(file, i, line, "enum sans tab")
	if re.search(r'\bunion\b', line) != None and line.find('union\t') == -1:
		printerror(file, i, line, "union sans tab")
	if re.search("[a-zA-Z0-9_]+[ \t]+[a-zA-Z0-9_]+[ \t]+=.*\(", line) != None:
		printerror(file, i, line, "Variable initialisation error")

#def comment_test (i, line):
#    if line != "*/\n" and line.find('**') != 0:
#        print i,line,"Erreur de commentaire"

def check(args):
	G = "\033[102m \033[0m"
	GG = "\033[102m  \033[0m"
	S = " "
	SS = "  "
	global testerror
	for file in args.files:
		#print file
		i = 0
		global nbline
		accolade = 0
		nbline = 0
		comment = False
		line = file.readline()
		while line != '':
			i += 1

			# 80 cols
			if len(line) > 81:
				printerror(file, i, line, "> 80 column")

			# Clean strings
			line = cleanline(line)
			line = re.sub('//.*', '\n', line)

			# Block operation
			accolade += line.count('{')
			accolade -= line.count('}')
			if accolade > 0 and len(line) != 1:
				nbline += 1
			elif len(line) != 1:
				nbline = 0
			if nbline > 25:
				printerror(file, i, line, "> 25 line function")

			if re.match('/\*', line) != None:
				comment = True
			else:
				#if comment:
				#    comment_test(i, line)
				#else:
				global_test(i, line, file)

			if re.match('\*/', line) != None:
				comment = False
			line = file.readline()
	if testerror == 0:
		print GG+SS+GG+S+GG+GG+GG+S+GG+SS+GG+SS+SS+GG+SS+SS+SS+GG+S+GG+GG+GG+S+GG+SS+GG+"\n"+GG+SS+GG+S+GG+SS+GG+S+GG+SS+GG+SS+SS+GG+SS+GG+SS+GG+S+SS+GG+SS+S+GG+G+S+GG+"\n"+SS+GG+SS+S+GG+SS+GG+S+GG+SS+GG+SS+SS+GG+SS+GG+SS+GG+S+SS+GG+SS+S+GG+S+G+GG+"\n"+SS+GG+SS+S+GG+GG+GG+S+GG+GG+GG+SS+SS+SS+GG+SS+GG+SS+S+GG+GG+GG+S+GG+SS+GG+"\n"

parser = ArgumentParser(description='Check the norme in c')
parser.add_argument('files', nargs='+', type=FileType('r+'))
try:
	args = parser.parse_args()
	check(args)
except IOError:
	print "file doesn't exist"

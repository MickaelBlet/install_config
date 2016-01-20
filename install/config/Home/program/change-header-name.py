#! /usr/bin/python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser, FileType
import io
import re

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
			line = file.readline()

parser = ArgumentParser(description='Check the norme in c')
parser.add_argument('files', nargs='+', type=FileType('r+'))
try:
	args = parser.parse_args()
	check(args)
except IOError:
	print "file doesn't exist"

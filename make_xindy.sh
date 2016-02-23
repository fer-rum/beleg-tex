# This is a small helper script
# for the use with TeXMaker.
# If you use a seperate build directory
# change the user-action command from
#
#    makeglossaries %
#
# to
#
#    bash make_xindy.sh %
#
#! /bin/bash

xindy  \
	-L english \
	-C utf8 \
	-I xindy \
	-M "./build/$1" \
	-t "./build/$1.alg" \
	-o "./build/$1.acr" \
	"./build/$1.acn"


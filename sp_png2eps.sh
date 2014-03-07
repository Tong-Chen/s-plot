#!/bin/bash

if test $# -lt 1; then
	echo 1>&2  "Using $0 file.png [file2.png,...]"
	exit 1
fi

for i in $@; do 
	prefix=`basename $i .png`
	pngtopnm $i >$prefix.pnm
	pnmtops -noturn -rle $prefix.pnm >$prefix.ps 2>/dev/null
	ps2epsi $prefix.ps

	/bin/rm -f $prefix.ps
	/bin/rm -f $prefix.pnm
	mv $prefix.epsi $prefix.eps
done

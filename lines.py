#!/usr/bin/env python
# -*- coding: utf-8 -*-
#from __future__ import division, with_statement
'''
Copyright 2010, 陈同 (chentong_biology@163.com).  
Please see the license file for legal information.
===========================================================
'''
__author__ = 'chentong & ct586[9]'
__author_email__ = 'chentong_biology@163.com'
#=========================================================
import sys
import os

def main():
    if len(sys.argv) < 2 :
        print >>sys.stderr, "Output a png graph file with the \
    filename given as prefix."
        print >>sys.stderr, '''
    File Format:(with a header line, startswith a '#'. This is necessary
    and is used to annotate the first line not as data.)
    #sample iso1    iso2    iso3    iso4
    sample1 0.345   0.35    0.43    0.89
    sample2 1.234   9.23    20.1    0
    sample3 5.02    3.42    0.33    0.01
    sample4 5.60    0.01    0.03    4.3
    #######################
    Note: sample column is the x-axis label
    sample row is the legend
    The column number is not allowed to be larger than 37.
    '''
        print >>sys.stderr, 'Using python %s filename \
legend[default with legend, which is your itms in your first line, \
if there are many items, it would be better to tun it off by supply\
a 0 here.] xtics[default text xtics, if number supply a 0] \
preaditionallines[; seperate multiple lines] postaditionallines \
xlabel ylabel title [lines or linespoints]' % sys.argv[0]
        sys.exit(0)
    #---------------------------------
    lenpara = len(sys.argv)
    legendornot = 1
    if lenpara >= 3:
        legendornot = int(sys.argv[2])
    #-------------------------------
    xticsornot = 1 #text xtics
    xticsvalue = ''
    if lenpara >= 4:
        xticsornot = int(sys.argv[3])
        xticsvalue = '1:'
    #-------------------------------
    pregnu = ''
    if lenpara >= 5:
        pregnu = sys.argv[4]       
    #-------------------------------
    postgnu = ''
    if lenpara >= 6:
        postgnu = sys.argv[5]       
    #-------------------------------
    xlabel = ''
    if lenpara >= 7:
        xlabel = sys.argv[6]
    #-------------------------------
    ylabel = ''
    if lenpara >= 8:
        ylabel = sys.argv[7]
    #-------------------------------
    title = ''
    if lenpara >= 9:
        title = sys.argv[8]
    #-------------------------------
    style = 'lines'
    if lenpara >=10:
        style = sys.argv[9]
    #-------------------------------
    lsDict = {2:' ls 1', 3:' ls 2', 4:' ls 3', 5:' ls 4', 
            6:' ls 5', 7:' ls 6', 8:' ls 7', 9:' ls 8',
            10:' ls 9', 11:' ls 10', 12:' ls 11', 13:' ls 12',
            14:' ls 13', 15:' ls 14', 16:' ls 15', 17:' ls 16',
            18:' ls 17', 19:' ls 18', 20:' ls 19', 21:' ls 20',
            22:' ls 21', 23:' ls 22', 24:' ls 23', 25:' ls 24',
            26:' ls 25', 27:' ls 26', 28:' ls 27', 29:' ls 28',
            30:' ls 29', 31:' ls 30', 32:' ls 31', 33:' ls 32',
            34:' ls 33', 35:' ls 34', 36:' ls 35', 37:' ls 36'
            }
    #-----------------------------
    sample = []
    header = 1
    for line in open(sys.argv[1]):
        if header:
            header = 0
            lineL = line.strip().split("\t")
            plot = 'plot ' + '\'' + sys.argv[1] + '\' '  
            pos = 1
            for item in lineL[1:]:
                pos += 1
                if pos == 2:
                    plot += 'using ' + xticsvalue + str(pos) + \
                        ' title ' + '\'' +\
                        item + '\'' + ' with ' + style + lsDict[pos]
                else:
                    plot += ',\'\' using ' + xticsvalue + str(pos) + ' title ' + '\'' +\
                        item + '\'' + ' with ' + style + lsDict[pos]
        #---------------------------------------
        else:
            tmp = line.split("\t",1)[0]
            sample.append(tmp)
    #--------------------------------------------
    xtics = 'set xtics ('
    i48 = -1
    for item in sample:
        i48 += 1
        if item == '-':
            continue
        if i48 == 0:
            xtics += '\'' + item + '\' ' + str(i48) 
        else:
            xtics += ',\'' + item + '\' ' + str(i48) 
    xtics += ')'
    #------------------------------
    xrange='set xrange [-0.5:' + str(i48+0.5) + ']'
    #------------------------------
    fileout = sys.argv[1] + '.plt'
    fh = open(fileout , 'w')
    print >>fh, 'set term png'
    print >>fh, "set output \'" + sys.argv[1] + '.png\''
    print >>fh, '''
set style line 1 lt 1 linecolor rgb "red"  lw 3
set style line 2 lt 1 linecolor rgb "orange"  lw 3
set style line 3 lt 1 linecolor rgb "#000000"  lw 3
set style line 4 lt 1 linecolor rgb "green"  lw 3
set style line 5 lt 1 linecolor rgb "cyan"  lw 3
set style line 6 lt 1 linecolor rgb "blue"  lw 3
set style line 7 lt 1 linecolor rgb "violet"  lw 3
set style line 8 lt 1 linecolor rgb "olive"  lw 3
set style line 9 lt 1 linecolor rgb "purple"  lw 3
set style line 10 lt 2 linecolor rgb "red"  lw 3
set style line 11 lt 2 linecolor rgb "orange"  lw 3
set style line 12 lt 2 linecolor rgb "#000000"  lw 3
set style line 13 lt 2 linecolor rgb "green"  lw 3
set style line 14 lt 2 linecolor rgb "cyan"  lw 3
set style line 15 lt 2 linecolor rgb "blue"  lw 3
set style line 16 lt 2 linecolor rgb "violet"  lw 3
set style line 17 lt 2 linecolor rgb "olive"  lw 3
set style line 18 lt 2 linecolor rgb "purple"  lw 3
set style line 19 lt 3 linecolor rgb "red"  lw 3
set style line 20 lt 3 linecolor rgb "orange"  lw 3
set style line 21 lt 3 linecolor rgb "#000000"  lw 3
set style line 22 lt 3 linecolor rgb "green"  lw 3
set style line 23 lt 3 linecolor rgb "cyan"  lw 3
set style line 24 lt 3 linecolor rgb "blue"  lw 3
set style line 25 lt 3 linecolor rgb "violet"  lw 3
set style line 26 lt 3 linecolor rgb "olive"  lw 3
set style line 27 lt 3 linecolor rgb "purple"  lw 3
set style line 28 lt 3 linecolor rgb "red"  lw 3
set style line 29 lt 3 linecolor rgb "orange"  lw 3
set style line 30 lt 3 linecolor rgb "#000000"  lw 3
set style line 31 lt 3 linecolor rgb "green"  lw 3
set style line 32 lt 3 linecolor rgb "cyan"  lw 3
set style line 33 lt 3 linecolor rgb "blue"  lw 3
set style line 34 lt 3 linecolor rgb "violet"  lw 3
set style line 35 lt 3 linecolor rgb "olive"  lw 3
set style line 36 lt 3 linecolor rgb "purple"  lw 3

'''
    if not legendornot:
        print >>fh, "set nokey"
    if xticsornot:
        print >>fh, xrange
        print >>fh, xtics
    if pregnu:
        print >>fh, pregnu
    #----------------------------
    if xlabel:
        print >>fh, 'set xlabel \"%s\"' % xlabel 
    if ylabel:
        print >>fh, 'set ylabel \"%s\"' % ylabel 
    if title:
        print >>fh, 'set title \"%s\"' % title 
    #-----------------------------
    print >>fh, plot
    if postgnu:
        print >>fh, postgnu
    print >>fh, 'exit'
    fh.close()
    cmd1 = 'gnuplot ' + fileout
    #cmd2 = 'convert -density 300 -flatten ' + sys.argv[1] + '.eps ' +\
    #    sys.argv[1] + '.png'
    os.system(cmd1)
    #os.system(cmd2)
if __name__ == '__main__':
    main()


#! /bin/bash

cd /usr/local/SASHome/SASFoundation/9.4/samples/base

# Word Frequency
sas -noterminal wordfreq.sas
echo wordfreq.lst

# Resolving trees by sorting and merging
sas -noterminal trees.sas
echo trees.lst

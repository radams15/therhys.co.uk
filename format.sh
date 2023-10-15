#!/bin/bash

files=`find . \( -name *.pm -o -name *.pl \) | xargs`

perltidy -b -bext='/' $files

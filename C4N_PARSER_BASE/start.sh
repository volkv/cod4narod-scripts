#!/bin/sh

sleep 10

RED='\033[1;31m' 
BLUE='\033[1;34m'
GREEN='\033[1;32m'
NC='\033[0m' 

DIRFILE=`readlink -e "$0"`
CURFILE=`basename "$DIRFILE"`
CURDIR=`dirname "$DIRFILE"`

echo "\n"
echo "${RED} Devoleped by volkv.com (CoD4Narod.RU) ${NC}"

setterm -term linux -back black
echo "${GREEN}"
while (true) 
do
php -q -f $CURDIR/parser.php
done;
echo "${NC}"

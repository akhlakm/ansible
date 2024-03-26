#!/bin/bash

subject="$1"
body="$2"
to=${3:-notify}

echo -e "$body" | mailx -v -s $subject $to@t.c

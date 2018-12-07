#!/usr/bin/env bash
staged=$(yadm diff --cached --numstat | wc -l)
modified=$(yadm ls-files -m | wc -l)

no= 
yes=

if [[ $staged != "0" || $modified != "0" ]]; then
    echo " %{F#BF616A}$no%{F-} s: $staged | m: $modified"
else
    echo " %{F#A3BE8C}$yes%{F-} s:$staged | m:$modified"
fi

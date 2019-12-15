#!/usr/bin/env bash

# returns true if current times seconds field
# is divisible by 3
function delay() {
    f=$(date +"%S")
    j=$((10#$f % 3))

    if (( 10#$j == 0 )); then
        # notify-send $f "$j loading"
        echo true
    else
        # notify-send $f "$j not"
        echo false
    fi
}

###################
## COLOR PALETTE ##
###################

# [colors]
# Nord
# ===================== #
# blacks
nord0="#2E3440"
nord1="#3B4252"
nord2="#434C5E"
nord3="#4C566A"
# whites
nord4="#D8DEE9"
nord5="#E5E9F0"
nord6="#ECEFF4"

# ===================== #
# blues 
# seafoam
nord7="#8FBCBB"
# turquoise
nord8="#88C0D0"
# pastel
nord9="#81A1C1"
# blue
nord10="#5E81AC"

# ===================== #
# red
nord11="#BF616A"
# orange
nord12="#D08770"
# yellow
nord13="#EBCB8B"
# green
nord14="#A3BE8C"
# purple
nord15="#B48EAD"

yadm fetch > /dev/null 2>&1

staged=$(yadm diff --cached --numstat | wc -l)
modified=$(yadm ls-files -m | wc -l)
# shows how many commits ahead and behind local master is from origin
ahead_behind_count=$(yadm rev-list --left-right --count master...origin/master)
ahead=$(echo $ahead_behind_count | cut -d ' ' -f1)
behind=$(echo $ahead_behind_count | cut -d ' ' -f2)

ahead_icon=
behind_icon=
yadm_icon=


no=
yes=
modified_icon=
staged_icon=
commits_prompt="  $yadm_icon $behind $behind_icon $ahead $ahead_icon "

# TODO: fix this, not sure how to hand parameters to this script from polybar
if [[ $1 == true ]]; then
    arrow=" "
else
    arrow=""
fi



function color {
    echo "%{B${1}}%{F${2}}${3}%{B-}%{F-}"
}

if [[ "$behind" -gt 0 ]]; then
    fg=$nord11
    commits_prompt=$(color "${nord0}" "${nord11}" "${commits_prompt}")
elif [[ "$ahead" -gt 0 ]]; then
    fg=$nord15
    commits_prompt=$(color "${nord0}" "${nord15}" "${commits_prompt}")
else
    fg=$nord14
    commits_prompt=$(color "${nord0}" "${nord14}" "${commits_prompt}")
fi


if [[ $staged != "0" || $modified != "0" ]]; then

    bg=$nord15
    staged_prompt=$(color "${nord0}" "${nord12}" " $staged_icon $staged $modified_icon $modified  $no ")$(color "${nord0}" "${nord13}" $arrow)
else
    bg=$nord14
    staged_prompt=$(color "${nord0}" "${nord9}" " $staged_icon $staged $modified_icon $modified  $yes ")$(color "${nord0}" "${nord14}" $arrow)
fi

if [[ $bg == $fg ]]; then
    separator=$(color "${bg}" "${nord0}" "")
else
    separator=$(color "${bg}" "${fg}" $arrow)
fi

echo $commits_prompt${separator}$staged_prompt

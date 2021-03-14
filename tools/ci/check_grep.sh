
#!/bin/bash
set -euo pipefail

#nb: must be bash to support shopt globstar
shopt -s globstar

st=0

echo "Checking for TGM formatting"
if grep -El '^\".+\" = \(.+\)' maps/DeadSpace/*.dmm;	then
    echo "Non-TGM formatted map detected. Please convert it using Map Merger!"
    st=1
fi;
echo "Checking for mapping tags"
if grep -nP '^\ttag = \"icon' maps/DeadSpace/*.dmm;	then
    echo "tag vars from icon state generation detected in maps, please remove them."
    st=1
fi;
echo "Checking for step_[xy]"
if grep -nP 'step_[xy]' maps/DeadSpace/*.dmm;	then
    echo "step_x/step_y variables detected in maps, please remove them."
    st=1
fi;
echo "Checking for stacked cables"
if grep -nP '"\w+" = \(\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/obj/structure/cable,\n([^)]+\n)*/area/.+\)' maps/DeadSpace/*.dmm;	then
    echo "found multiple cables on the same tile, please remove them."
    st=1
fi;
echo "Checking for pixel_[xy]"
if grep -nP 'pixel_[xy] = 0' maps/DeadSpace/*.dmm;	then
    echo "pixel_x/pixel_y = 0 variables detected in maps, please review to ensure they are not dirty varedits."
fi;
echo "Checking for vareditted areas"
if grep -nP '^/area/.+[\{]' maps/DeadSpace/*.dmm;	then
    echo "Vareditted /area path use detected in maps, please replace with proper paths."
    st=1
fi;
echo "Checking for base /turf paths"
if grep -nP '\W\/turf\s*[,\){]' maps/DeadSpace/*.dmm; then
    echo "base /turf path use detected in maps, please replace with proper paths."
    st=1
fi;
echo "Checking for unmanaged globals"
if grep -nP '^/*var/' code/**/*.dm; then
    echo "Unmanaged global var use detected in code, please use the helpers."
    st=1
fi;
echo "Checking for 0 length timers"
if grep -nP 'addtimer\(.+?, ?0\)($| |/)' code/**/*,dm; then
	echo "Default timer type with no length detected. Please add the correct flags or use the async macro call"
	st=1
fi;
echo "Checking for space indentation"
if grep -nP '(^ {2})|(^ [^ * ])|(^    +)' code/**/*.dm; then
    echo "space indentation detected"
    st=1
fi;
echo "Checking for mixed indentation"
if grep -nP '^\t+ [^ *]' code/**/*.dm; then
    echo "mixed <tab><space> indentation detected"
    st=1
fi;
echo "Checking long list formatting"
if pcregrep -nM '^(\t)[\w_]+ = list\(\n\1\t{2,}' code/**/*.dm; then
    echo "long list overidented, should be two tabs"
    st=1
fi;
if pcregrep -nM '^(\t)[\w_]+ = list\(\n\1\S' code/**/*.dm; then
    echo "long list underindented, should be two tabs"
    st=1
fi;
if pcregrep -nM '^(\t)[\w_]+ = list\([^\s)]+( ?= ?[\w\d]+)?,\n' code/**/*.dm; then
    echo "first item in a long list should be on the next line"
    st=1
fi;
if pcregrep -nM '^(\t)[\w_]+ = list\(\n(\1\t\S+( ?= ?[\w\d]+)?,\n)*\1\t[^\s,)]+( ?= ?[\w\d]+)?\n' code/**/*.dm; then
    echo "last item in a long list should still have a comma"
    st=1
fi;
if pcregrep -nM '^(\t)[\w_]+ = list\(\n(\1\t[^\s)]+( ?= ?[\w\d]+)?,\n)*\1\t[^\s)]+( ?= ?[\w\d]+)?\)' code/**/*.dm; then
    echo ") in a long list should be on a new line"
    st=1
fi;
if pcregrep -nM '^(\t)[\w_]+ = list\(\n(\1\t[^\s)]+( ?= ?[\w\d]+)?,\n)+\1\t\)' code/**/*.dm; then
    echo "the ) in a long list should match identation of the opening list line"
    st=1
fi;
nl='
'
nl=$'\n'
while read f; do
    t=$(tail -c2 $f; printf x); r1="${nl}$"; r2="${nl}${r1}"
    if [[ ! ${t%x} =~ $r1 ]]; then
        echo "file $f is missing a trailing newline"
        st=1
    fi;
done < <(find . -type f -name '*.dm')
#Disabled because #1187 was closed.
#TODO: Re-enable at later date.
#if grep -nP '^/[\w/]\S+\(.*(var/|, ?var/.*).*\)' code/**/*.dm; then
#    echo "changed files contains proc argument starting with 'var'"
#    st=1
#fi;
if grep -ni 'nanotransen' code/**/*.dm; then
    echo "Misspelling(s) of nanotrasen detected in code, please remove the extra N(s)."
    st=1
fi;
if grep -ni 'nanotransen' maps/**/*.dmm; then
    echo "Misspelling(s) of nanotrasen detected in maps, please remove the extra N(s)."
    st=1
fi;

#IN FUTURE Create Map change in BUILD.
#if ls maps/*.json | grep -nP "[A-Z]"; then
#    echo "Uppercase in a map json detected, these must be all lowercase."
#	st=1
#fi;
#for json in maps/*.json
#do
#    filename="maps/$(jq -r '.map_path' $json)/$(jq -r '.map_file' $json)"
#    if [ ! -f $filename ]
#    then
#        echo "found invalid file reference to $filename in _maps/$json"
#        st=1
#    fi
#done */

exit $st

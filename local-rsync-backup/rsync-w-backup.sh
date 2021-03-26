#!/bin/bash

# Q&D backups, for undo

# Input: none
# Output: logfile; files in dest, rsync'd from src
# Requirements: rsync-excludes (in same dir as executable)

# History:
# 20210326 mvr: _explicitly_ exclude the dest dir
# 20210326 mvr: add ability to override $destDirParent
# 20210326 mvr: skip this invocation, if another is still running
# 20210326 mvr: ensure parent dir exists (safer)
# 20210326 mvr: add --extended-attributes (!)
# circa 2020 mvr: incep


# if no dest dir provided, try a default:
if [ -z "$destDirParent" ] ; then
    destDirParent=~/tmp/rsync-dest
fi
destDirCurrent=$destDirParent/current
destDirBackups=$destDirParent/backups

theNow=$(date "+%Y%m%d-%H%M%S")

#doDryRun='--dry-run'
doVerbose='--verbose'
#extraOpts='--stats  --progress'

myBase=$(basename "$0")
myDir=$(dirname "$0")


# FIRST: make sure another isn't already/still running:
myPID=$$
otherInvocs=$(pgrep -f "$myBase" | fgrep -v "$myPID")
if [ -n "$otherInvocs" ] ; then
    echo 'ERR: bailing, since there is another already/still running]' >&2
    exit 1
fi

# make sure at least the parent dir exists:
if [ \! -d "$destDirParent" ] ; then
    echo 'ERR: bailing; destDir does not exist: '"$destDirParent"
    exit 1
fi

# create our directory structure, in the dest parent:
for aDest in "$destDirCurrent"  "$destDirBackups" ; do
	if ! [ -d "$aDest" ] ; then
	    mkdir -p "$aDest"
	    retnCode=$?
	    if [ $retnCode -ne 0 ] ; then
		echo "ERR: baliling; mkdir \"$aDest\" failed with retnCode $retnCode"
		exit 1
	    fi
	fi
done

# encapsulate output, to redirect all to log file:
{
echo
echo $(date "+%Y%m%d-%H%M%S") "$myBase STARTING"

# note: NO trailing slash on srcDir, so will copy that _dir_ (vs only contents) to dest:
for srcDir in ~ /private/etc; do
  rsync \
	"$srcDir" \
	"$destDirCurrent" \
	--exclude-from="$myDir"/rsync-excludes \
        --exclude="$destDirParent" \
	$doDryRun \
	$extraOpts \
	$doVerbose \
    --archive \
    --extended-attributes \
    --omit-dir-times \
    --checksum \
    --ignore-errors \
    --delete-after \
    --itemize-changes \
    --one-file-system \
    --human-readable \
    --backup \
    --backup-dir=${destDirBackups}/$theNow \
        2>&1 \
        | grep -v '^\.'
  retnCode=$?
  echo $(date "+%Y%m%d-%H%M%S") "$myBase done rsync $srcDir; retnCode" $retnCode
done

# redirect all stdout to log file:
} >> "$destDirParent"/log.txt

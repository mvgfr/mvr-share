#!/bin/bash

# Q&D backups, for undo

# Input: none
# Output: logfile; files in dest, rsync'd from src
# Requirements: rsync-excludes (in same dir as executable)


# NOTE: this hard-coded dest dir, is in the rsync-excludes (kinda required)
destDirParent=~/tmp/rsync-dest
  destDirCurrent=$destDirParent/current
  destDirBackups=$destDirParent/backups
theNow=$(date "+%Y%m%d-%H%M%S")
#doDryRun='--dry-run'
doVerbose='--verbose'
#extraOpts='--stats  --progress'

myBase=$(basename "$0")
myDir=$(dirname "$0")


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
	$doDryRun \
	$extraOpts \
	$doVerbose \
    --archive \
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

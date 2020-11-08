## a local rsync, with backup, to make safety copies
some benefits
- restore a file that was accidentally deleted
- check a previous iteration of a file (ex: for undo)

setup & operation
- clone this repo
  - suggested location: `~/tmp/git/`
- keep the `rsync-excludes` file in the same dir as the `rsync-w-backup.sh` script
  - the script ASSumes it will be there
    - if not found, likely result: full disk, and headaches
- run the script once to test (which may take awhile)  
`./rsync-w-backup.sh`
- check the destination directory, for desired results
- cron it:
  - modify your user's `crontab`  
  `crontab -e`
  - adding line like this `3,33 * * * *   ~/tmp/git/mvr-share/local-rsync-backup/rsync-w-backup.sh`
    - which does a run every half hour  
    (3 minutes offset, so less chance of conflict with other operations)
  - after an hour, check the results

notes
- tested on macOS 10.15; for others: YMMV
- keep an eye on your disk usage; it can get filled fast
  - you may want to be more selective, in the source/s selected for rsync
- destination directory:
  - default location is `~/tmp/rsync-dest`
    - which will be created if need be, by the script
    - the `~/tmp` dir is in the default excludes (so won't loop infinitely)
    - the volume must have enough space for rsync and its backups
  - the dest dir will contain
    - a log file: `log.txt`
    - a dir named `current`: the rsync results, as of the most recent execution
    - a dir named `backups`: with subdir named by timestamp, of:
      - incremental backups (ex: modified or deleted files)
- the script is cfg'd to rsync these sources: your homedir, and `/private/etc`
  - if desired, edit the script, to use other sources
    - note: follow the comments; you likely do NOT want a trailing slash, on source directories

## a local rsync, with backup, to make safety copies
some benefits
- restore a file that was accidentally deleted
- checl a previous iteration of a file

components
- rsync-w-backup.sh: do the rsync
- rsync-excludes: do NOT rsync everything
- (user's) crontab: to exec automatically, on a schedule
- a destination directory (details below)
- log file: `~/rsync-dest/log.txt`

setup & operation
- clone this repo
  - suggested location: `~/tmp/git/`
- keep the `rsync-excludes` file in the same dir as the `rsync-w-backup.sh` script
  - script ASSumes it will be there
    - if not found, likely result: full disk, and headaches
- create a destination dir called "rsync-dest"
  - suggested path: `~/tmp/rsync-dest`
  - notes:
    - the `~/tmp` dir is in the default excludes (so won't loop infinitely)
    - the volume must have enough space for rsync and its backups
    - the dest dir will contain
      - a log file: ~/rsync-dest/log.txt
      - a dir named "current": the as-of-now rsync results
      - a dir named "backups": as new rsyncs are done:
        - incremental backups go here (ex: modified or deleted files)
          - in dirs named by timestamp
- symlink this new rsync-dest dir, to `~/rsync-dest`  
`ln -s ~/tmp/rsync-dest ~/rsync-dest`
- the script is cfg'd to rsync the sources: your homedir, and `/private/etc`
  - if desired, edit the script to modify
    - note: follow the comments; you likely do NOT want a trailing slash, on source directories
- run the script once to test (which may take awhile)
`./rsync-w-backup.sh`
- check the log, for desired results  
`less ~/rsync-dest/log.txt`
- check the dest dir, for desired results
- once happy with results, cron it
  - modify your user's `crontab`
  `crontab -e`
  - adding line like this `3,33 * * * *   ~/tmp/git/mvr-share/rsync-w-backup.sh`
    - which does a run every half hour
    (3 minutes offset, so less chance of conflict with other operations)
- keep an eye on your disk usage; it can get filled fast
  - you may want to be more selective, in the source/s selected for rsync

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

setup
- clone this repo
  - suggested location: `~/tmp/git/repo-name`
- keep the `rsync-excludes` file in the same dir as the `rsync-w-backup.sh` script
  - script ASSumes it will be there
    - if not found, likely result: full disk, and headaches
- create a destination dir called "rsync-dest"
  - suggested path: `~/tmp/rsync-dest/`
  - notes:
    - the `~/tmp/` dir is in the default excludes (so won't loop infinitely)
    - the volume must have enough space for rsync and its backups
    - the dest dir will contain
      - a log file: ~/rsync-dest/log.txt
      - a dir named "current": the as-of-now rsync results
      - a dir named "backups": as new rsyncs are done, backups go here (ex: deleted files)
- symlink this new rsync-dest dir, to `~/rsync-dest`  
`ln -s ~/tmp/rsync-dest ~/rsync-dest`
- the script is cfg'd to rsync the sources: home dir, and XYZ
  - if desired, edit the script to modify
    - note: follow the comments; you likely do NOT want a trailing slash, on source directories
- run the script once to test (which may take awhile)
`./rsync-w-backup.sh`
- check the log, for destired results  
`less ~/rsync-dest/log.txt`
- check the dest dir, for destired results
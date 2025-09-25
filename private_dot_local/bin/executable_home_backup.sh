#!/bin/bash
set -e

rsync -avh --no-links --delete --exclude=.* --exclude=dyski /home/szymon/ /mnt/backup/home/szymon/
rsync -avh --no-links --delete --exclude=.* --exclude=dyski /home/szymon/ /mnt/backup_wd/home/szymon/

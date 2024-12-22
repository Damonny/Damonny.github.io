#/bin/bash
cd /volume2/backup/blog && git fetch origin && git merge origin/main && hexo clean && hexo g && hexo d

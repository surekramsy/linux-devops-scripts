#================================
Docker cleanup Script:
#================================

#crontab -l
#0 20 * * * /bin/bash /home/ec2-user/docker_cleanup.sh

#cat docker_cleanup.sh 
#!/bin/bash

LOG_FILE="/home/ec2-user/docker-cleanup.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

DOCKER_PATH="/var/lib/docker"

USAGE=$(df "$DOCKER_PATH" | awk 'NR==2 {print $5}' | sed 's/%//')

echo "[$DATE] Disk usage: ${USAGE}%" >> $LOG_FILE

if [ "$USAGE" -gt 70 ]; then
    echo "[$DATE] Threshold exceeded (>70%). Running Docker cleanup..." >> $LOG_FILE

    # Remove dangling images
    docker image prune -f >> $LOG_FILE 2>&1

    echo "[$DATE] Cleanup completed successfully." >> $LOG_FILE
else
    echo "[$DATE] Cleanup skipped. Usage below threshold." >> $LOG_FILE
fi

echo "--------------------------------------------------" >> $LOG_FILE

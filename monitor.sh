### 2. `monitor.sh`
```bash
#!/bin/bash
# Linux Server Monitor - Bash Version

LOGFILE="logs/$(date +%F_%T).log"
mkdir -p logs

CPU_ALERT=80
MEM_ALERT=85
DISK_ALERT=90

while true; do
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
    MEM=$(free | awk '/Mem/{printf("%.2f%"), $3/$2*100}')
    DISK=$(df -h / | awk 'NR==2 {print $5}')

    echo "$(date '+%F %T') | CPU: $CPU | MEM: $MEM | DISK: $DISK" | tee -a $LOGFILE

    # Alerts
    cpu_val=$(echo $CPU | tr -d '%')
    mem_val=$(echo $MEM | tr -d '%')
    disk_val=$(echo $DISK | tr -d '%')

    if [ $cpu_val -ge $CPU_ALERT ]; then
        echo "ALERT: High CPU usage $CPU" | tee -a $LOGFILE
    fi
    if [ $mem_val -ge $MEM_ALERT ]; then
        echo "ALERT: High Memory usage $MEM" | tee -a $LOGFILE
    fi
    if [ $disk_val -ge $DISK_ALERT ]; then
        echo "ALERT: High Disk usage $DISK" | tee -a $LOGFILE
    fi

    sleep 5
done

#!/bin/bash


#variables

LOG_DIR="/var/log/myapp"
MAX_LOG_SIZE=5000000 #5MB
MAX_LOG_AGE=30 #30 Days



#Function to rotate logs


rotate_logs() {
    for log_file in "$LOG_DIR"/*.log; do
        if [ $(stat -c%s "$log_file") -gt $MAX_LOG_SIZE ]; then
            base_name=$(basename "$log_file")                         # اسم الملف بس من غير المسار
            new_name="${LOG_DIR}/${base_name}.$(date +'%y%m%d')"     # الاسم الجديد بنفس المجلد
            mv "$log_file" "$new_name"
            gzip "$new_name"
            echo "Log rotated: $log_file"
        fi
    done
}




#Function of clean up \

clean_old_logs() {
	find "$LOG_DIR" -name "*.gz" -mtime +$MAX_LOG_AGE -exec rm {} \;
        echo "Old logs cleaned up"	
}




#Run the finctions

rotate_logs
clean_old_logs

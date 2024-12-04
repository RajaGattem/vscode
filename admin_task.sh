#!/bin/bash

# Admin task script for backups and permission checks

# Define variables
BACKUP_DIR="/backup"                # Backup directory
SOURCE_DIR="/home"                  # Directory to backup
PERMISSION_FILE="/etc/passwd"       # File to check permissions
BACKUP_FILE_NAME="backup_$(date +%Y%m%d).tar.gz"  # Backup file name

LOG_FILE="/var/log/admin_tasks.log"  # Log file location

# Function to log messages
log_message() {
    local message=$1
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $message" >> $LOG_FILE
    echo "$message"  # Print to terminal for immediate feedback
}

# Function to perform a backup
perform_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
        log_message "Backup directory does not exist. Creating directory: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
    fi

    log_message "Starting backup of $SOURCE_DIR"

    # Create the backup using tar and avoid leading slash in file names
    tar -czf "$BACKUP_DIR/$BACKUP_FILE_NAME" -C / home

    if [ $? -eq 0 ]; then
        log_message "Backup completed successfully: $BACKUP_DIR/$BACKUP_FILE_NAME"
        # Check the backup file and set appropriate permissions
        check_backup_permissions "$BACKUP_DIR/$BACKUP_FILE_NAME"
    else
        log_message "Backup failed. Exiting..."
        exit 1
    fi
}

# Function to check if the backup file exists and set permissions
check_backup_permissions() {
    local backup_file=$1
    
    if [ ! -f "$backup_file" ]; then
        log_message "ERROR: Backup file does not exist: $backup_file"
        return
    fi

    log_message "Checking permissions for backup file: $backup_file"
    
    # Check the current permissions
    BACKUP_PERMISSIONS=$(ls -l "$backup_file")
    log_message "Permissions for backup file: $BACKUP_PERMISSIONS"

    # Check if the file is readable and writable by the owner, and set permissions
    if [[ ! -r "$backup_file" || ! -w "$backup_file" ]]; then
        log_message "WARNING: $backup_file is not readable or writable by the owner. Setting appropriate permissions."
        chmod 600 "$backup_file"  # Set the backup file permissions to be read and writable by the owner only
        log_message "Permissions set to 600 for $backup_file."
    else
        log_message "$backup_file has correct permissions."
    fi
}

# Function to check file permissions
check_permissions() {
    if [ ! -f "$PERMISSION_FILE" ]; then
        log_message "File $PERMISSION_FILE does not exist."
        return
    fi

    log_message "Checking permissions for $PERMISSION_FILE"
    
    # Check for read, write, and execute permissions for the owner, group, and others
    PERMISSIONS=$(ls -l "$PERMISSION_FILE")
    log_message "Permissions for $PERMISSION_FILE: $PERMISSIONS"

    # Example: Check if the file is readable and writable by the owner
    if [[ ! -r "$PERMISSION_FILE" || ! -w "$PERMISSION_FILE" ]]; then
        log_message "WARNING: $PERMISSION_FILE is not readable or writable by the owner."
    else
        log_message "$PERMISSION_FILE has correct permissions."
    fi
}

# Function to check disk usage
check_disk_usage() {
    log_message "Checking disk usage..."
    DISK_USAGE=$(df -h)
    log_message "Disk Usage:\n$DISK_USAGE"
}

# Function to check system uptime
check_uptime() {
    log_message "Checking system uptime..."
    UPTIME=$(uptime)
    log_message "System Uptime: $UPTIME"
}

# Main menu
show_menu() {
    clear
    echo "==========================="
    echo " Admin Task Script"
    echo "==========================="
    echo "1. Perform Backup"
    echo "2. Check Permissions"
    echo "3. Check Disk Usage"
    echo "4. Check System Uptime"
    echo "5. Exit"
    echo "==========================="
    echo -n "Enter your choice [1-5]: "
}

# Main script loop
while true; do
    show_menu
    read -r choice

    case $choice in
        1)
            perform_backup
            ;;
        2)
            check_permissions
            ;;
        3)
            check_disk_usage
            ;;
        4)
            check_uptime
            ;;
        5)
            log_message "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid choice, please try again."
            ;;
    esac

    # Wait for a while before showing the menu again
    echo -e "\nPress any key to continue..."
    read -r
done


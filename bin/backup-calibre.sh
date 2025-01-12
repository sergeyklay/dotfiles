#!/usr/bin/env bash

# Copyright (C) 2025 Serghei Iakovlev <gnu@serghei.pl>
#
# This file is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.

# backup-calibre.sh - A script to backup a Calibre library directory securely.
#
# SYNOPSIS
#   backup-calibre.sh
#
# DESCRIPTION
#   The backup-calibre.sh script creates encrypted backups of a specified
#   Calibre library directory.  The backups are stored as GPG-encrypted tar.gz
#   files with additional checksum files for verification. The script also
#   ensures that a defined maximum number of backups are retained by removing
#   the oldest backups when necessary.
#
# USAGE
#   To run the script, set the required environment variables and execute:
#
#        BACKUP_DIR=/path/to/backup/directory \
#        CALIBRE_LIBRARY=/path/to/calibre/library \
#        ENCRYPTION_KEY="recipient_key_id_or_email" \
#        ./backup-calibre.sh
#
# DEPENDENCIES
#   - tar: For archiving and compressing the library.
#   - gpg: For encrypting the backup files.
#   - Environment variables (see usage below).
#
# ENVIRONMENT VARIABLES
#   - BACKUP_DIR: Path to the directory where backups will be stored.
#   - CALIBRE_LIBRARY: Path to the Calibre library directory to be backed up.
#   - ENCRYPTION_KEY: GPG recipient key identifier for encrypting backups.
#   - MAX_BACKUPS: Maximum number of backups to retain (optional; default: 15).
#   - ARCHIVE_NAME_TEMPLATE: Template for the backup file names, e.g.,
#                            "calibre_backup_{hostname}_{date}.tar.gz"
#                            (optional; default: a predefined format).
#
# EXAMPLES
#   To automate this script, you can use a systemd timer. For example:
#
#   Create a systemd service file $HOME/.config/systemd/user/backup-calibre.service:
#
#        [Unit]
#        Description=Backup Calibre Library
#
#        [Service]
#        Type=oneshot
#        ExecStart=/path/to/backup-calibre.sh
#        Environment="BACKUP_DIR=/path/to/backup/directory"
#        Environment="CALIBRE_LIBRARY=/path/to/calibre/library"
#        Environment="ENCRYPTION_KEY=recipient_key_id_or_email"
#
#   Create a systemd timer file: $HOME/.config/systemd/user/backup-calibre.timer:
#
#        [Unit]
#        Description=Run Calibre Library Backup Daily
#
#        [Timer]
#        OnCalendar=daily
#        Persistent=true
#
#        [Install]
#        WantedBy=timers.target
#
#   Enable and start the timer:
#
#        systemctl -user enable --now backup-calibre.timer
#
#   To see logs:
#
#        journalctl --user -u backup-calibre.timer
#        journalctl --user -u backup-calibre.service

# shellcheck shell=bash

# Exit on error
set -e

# Default configurations
DEFAULT_MAX_BACKUPS=15
DEFAULT_ARCHIVE_NAME='calibre_backup_{hostname}_{date}.tar.gz'

log_error() { printf "\e[1;31m%s\e[0m\n" "$1" >&2; }
log_info() { printf "%s\n" "$1" >&1; }

# Cleanup temporary files
cleanup() {
  if [ -n "$ARCHIVE_PATH" ]; then
    if [ -f "$ARCHIVE_PATH" ]; then
      rm -f "$ARCHIVE_PATH"
    fi
  fi
}
# Trap signals to ensure cleanup on script termination
trap '__exit_code=$?; cleanup; exit $__exit_code' EXIT SIGINT SIGTERM SIGHUP SIGQUIT

check_env_var() {
  VAR_NAME=$1
  VAR_VALUE=$(eval "echo \${$VAR_NAME}")
  if [ -z "$VAR_VALUE" ]; then
    log_error "Environment variable $VAR_NAME is not set or empty."
    exit 1
  fi
}

check_directory() {
  DIR_PATH=$1
  CREATE_IF_NOT_EXISTS=$2
  if [ ! -d "$DIR_PATH" ]; then
    if [ "$CREATE_IF_NOT_EXISTS" = "true" ]; then
      log_info "Creating directory $DIR_PATH"
      mkdir -p "$DIR_PATH" || (log_error "Failed to create directory $DIR_PATH" && exit 1)
    else
      log_error "Directory $DIR_PATH does not exist."
      exit 1
    fi
  fi
}

check_command() {
  COMMAND=$1
  if ! command -v "$COMMAND" >/dev/null 2>&1; then
    log_error "Command $COMMAND is not installed or not in PATH."
    exit 1
  fi
}

create_backup() {
  HOSTNAME=$(hostname)
  TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
  ARCHIVE_NAME=$(echo "$ARCHIVE_NAME_TEMPLATE" | sed "s/{hostname}/$HOSTNAME/" | sed "s/{date}/$TIMESTAMP/")
  ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

  log_info "Creating backup archive: $ARCHIVE_PATH"
  ( cd "$CALIBRE_LIBRARY" && tar -czf "$ARCHIVE_PATH" . )

  log_info "Encrypting backup archive: $ARCHIVE_PATH"
  gpg --encrypt --no-armor --recipient "$ENCRYPTION_KEY" --output "${ARCHIVE_PATH}.gpg" "$ARCHIVE_PATH"

  log_info "Backup archive encrypted successfully: ${ARCHIVE_PATH}.gpg"

  # Remove unencrypted archive
  rm -f "$ARCHIVE_PATH"
}

enforce_backup_limit() {
  BACKUPS_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type f | wc -l)
  if [ "$BACKUPS_COUNT" -gt "$MAX_BACKUPS" ]; then
    OLDEST_BACKUP=$(find "$BACKUP_DIR" -maxdepth 1 -type f | sort | head -n 1)
    log_info "Removing oldest backup: $OLDEST_BACKUP"
    rm -f "$OLDEST_BACKUP"
  fi
}

main() {
  # Check required environment variables
  check_env_var "CALIBRE_LIBRARY"
  check_env_var "BACKUP_DIR"
  check_env_var "ENCRYPTION_KEY"

  # Set defaults for optional variables
  MAX_BACKUPS=${MAX_BACKUPS:-$DEFAULT_MAX_BACKUPS}
  ARCHIVE_NAME_TEMPLATE=${ARCHIVE_NAME_TEMPLATE:-$DEFAULT_ARCHIVE_NAME}

  # Validate directories
  check_directory "$CALIBRE_LIBRARY"
  check_directory "$BACKUP_DIR" true

  # Check required commands
  check_command "tar"
  check_command "gpg"

  # Define paths and filenames
  LAST_HASH_FILE="$BACKUP_DIR/last_backup.hash"
  LAST_HASH_FILE_NAME=$(find "$BACKUP_DIR" -maxdepth 1 -type f -name "*.gpg" | sort | tail -n 1 | xargs -n 1 basename 2>/dev/null || echo "")

  # Compute the current hash of the library
  CURRENT_HASH=$(find "$CALIBRE_LIBRARY" -type f -exec sha256sum {} \; | sort | sha256sum | awk '{print $1}')

  # Compare hashes if previous hash and archive exist
  if [ -f "$LAST_HASH_FILE" ] && [ -n "$LAST_HASH_FILE_NAME" ] && [ -f "$BACKUP_DIR/$LAST_HASH_FILE_NAME" ]; then
    LAST_HASH=$(awk '{print $1}' "$LAST_HASH_FILE")
    if [ "$CURRENT_HASH" = "$LAST_HASH" ]; then
      log_info "No changes detected in the library. Backup not required."
      exit 0
    fi
  elif [ -z "$LAST_HASH_FILE_NAME" ]; then
    log_info "No previous backup found. Proceeding with initial backup."
  fi

  # Create a new backup
  create_backup

  # Identify the new archive and generate checksum
  NEW_ARCHIVE_NAME=$(find "$BACKUP_DIR" -maxdepth 1 -type f -name "*.gpg" | sort | tail -n 1 | xargs -n 1 basename)
  if [ -n "$NEW_ARCHIVE_NAME" ]; then
    log_info "Generating checksum file for the new backup."
    echo "$CURRENT_HASH *$NEW_ARCHIVE_NAME" >"$BACKUP_DIR/${NEW_ARCHIVE_NAME}.sha256"
    echo "$CURRENT_HASH" >"$LAST_HASH_FILE"
  fi

  # Enforce backup limit
  enforce_backup_limit
}

main

exit 0

# Local Variables:
# mode: sh
# End:

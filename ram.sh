ram() {
    local PROGRAM="$1"
    local RAM_DISK_SIZE="$2"
    local MOUNT_POINT="/mnt/ramdisk"

    cleanup() {
        if mountpoint -q "$MOUNT_POINT"; then
            sudo umount "$MOUNT_POINT"
            echo "Unmounted RAM disk at $MOUNT_POINT."
            sudo rmdir "$MOUNT_POINT"
            echo "Removed the RAM disk directory."
        else
            echo "RAM disk not mounted."
        fi
    }

    trap cleanup EXIT

    [ -z "$PROGRAM" ] && echo "Usage: run_in_ram_disk <PathToProgramOrProgramName> <RamDiskSize>" && return 1
    [ -z "$RAM_DISK_SIZE" ] && echo "Usage: run_in_ram_disk <PathToProgramOrProgramName> <RamDiskSize>" && return 1

    if [[ ! "$PROGRAM" =~ ^/ ]]; then
        PROGRAM=$(command -v "$PROGRAM")
        [ -z "$PROGRAM" ] && echo "Error: Program '$1' not found." && return 1
    fi

    AVAILABLE_MEMORY=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
    AVAILABLE_MEMORY="$((AVAILABLE_MEMORY / 1024))"

    REQUIRED_MEMORY_MB=$(echo "$RAM_DISK_SIZE" | sed 's/G/ * 1024/' | bc | awk '{printf "%d", $1}')

    (( AVAILABLE_MEMORY < REQUIRED_MEMORY_MB )) && echo "Not enough available memory to create a RAM disk of size $RAM_DISK_SIZE." && return 1

    sudo mkdir -p "$MOUNT_POINT"
    sudo mount -t tmpfs -o size="$RAM_DISK_SIZE" tmpfs "$MOUNT_POINT"

    cp "$PROGRAM" "$MOUNT_POINT" || { echo "Failed to copy $PROGRAM to RAM disk."; return 1; }

    "$MOUNT_POINT/$(basename "$PROGRAM")"  # Run the program

    echo "Program has exited."
}

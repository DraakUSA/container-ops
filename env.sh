#!/bin/false
# env.sh - Sourced by all other scripts
#
# Environment Configuration for container-ops
#
# Permissions: chmod 644 env.sh (Readable, not executable)

# 1. OS Detection & Windows Fixes
export MSYS_NO_PATHCONV=1
export OSTYPE_CURRENT="$(uname -s | tr '[:upper:]' '[:lower:]')"

# 2. Path Resolution
# Points to ~/docker regardless of where the script is called from
export BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 3. Check and Load Secrets from .env
if [ -f "$BASE_DIR/.env" ]; then
    # echo "--- Loading secrets from .env ---"
    # We use 'set -a' to automatically export all variables defined in .env
    # then 'set +a' to turn that behavior back off.
    set -a
    source "$BASE_DIR/.env"
    set +a
else
    echo "--- Notice: .env not found. ---"
fi

# 4. Preferences
export MY_EDITOR=${VISUAL:-${EDITOR:-vi}}

# 5. Standard Operations Variables
export DOCKER_RESTART_POLICY="unless-stopped"
export COMPOSE_PROJECT_NAME="container_ops"

export STACKS_FILE="$BASE_DIR/stacks.txt"

export SCRIPTS_DIR="$BASE_DIR/scripts"
export CONTAINERS_DIR="$BASE_DIR/containers"
export LOG_DIR="$BASE_DIR/logs"

# 6. Safety Check: Ensure stacks.txt and logs/ exist
if [ ! -f "$STACKS_FILE" ]; then
    touch "$STACKS_FILE"
    echo "--- Created missing stacks.txt ---"
fi

if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
    echo "--- Created missing log directory: $LOG_DIR ---"
fi
 
# 7. Shared Function: Load stacks from stacks.txt
load_stacks() {
    if [ -f "$STACKS_FILE" ]; then
        mapfile -t STACKS < <(grep -v '^#' "$STACKS_FILE" | grep -v '^$' | sed 's/[[:space:]]*$//')
    else
        echo "Error: $STACKS_FILE not found. Run 'd discover' first."
        exit 1
    fi
}

status_title() {
    local title=" $1 "
    local width=72
    # Calculate left padding
    local pad_left=$(( (width - ${#title}) / 2 ))
    # Calculate right padding (ensures symmetry even if title is odd)
    local pad_right=$(( width - ${#title} - pad_left ))
    
    echo " "
    printf '%*s' "$width" '' | tr ' ' '#'
    echo ""
    # Use the two different padding values
    printf '#%*s%s%*s#\n' "$((pad_left - 1))" '' "$title" "$((pad_right - 1))" ''
    printf '%*s' "$width" '' | tr ' ' '#'
    echo -e "\n"
}

# echo "--- container-ops environment loaded ---"


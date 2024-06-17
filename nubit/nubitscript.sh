#!/bin/bash
# official script command of Avail script from daningyn
COMMAND="curl -sL1 https://nubit.sh | bash"
# Here is script making LC restart if getting errors
while true; do echo "Starting command: $COMMAND"
    # Run command in the background
    bash -c "$COMMAND" &

    PID=$!

    wait $PID; EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ]; then 
        echo "Command exited successfully. Restarting..."
    else 
        echo "Command failed with status $EXIT_STATUS. Restarting..."
    fi

    sleep 10
done

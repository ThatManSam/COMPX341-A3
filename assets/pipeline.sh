#!/usr/bin/bash

# Sleeping after each echo so that the user can see 
# them before npm spits out heaps of messages
SLEEP_TIME=1

MESSAGE="COMPX341-22A-A3 Commiting from CI/CD Pipeline"

# ===== Pipeline =====
echo_and_wait "Installing packages"
npm install

echo_and_wait "Builing Application"
npm run build

# Check that the build succeeded
RESULT=$?
if [[ $RESULT == 0 ]]; then
    echo_and_wait "Build Successful"
    # Commit the changes with the new build
    echo_and_wait "Committing Build"
    git add .
    git commit -m "$MESSAGE"

    # Check that the commit was successful
    COMMIT_RESULT=$?
    if [[ $COMMIT_RESULT == 0 ]]; then
        echo_and_wait "Pushing Changes"
        git push

        # Check that the push was successful
        PUSH_RESULT=$?
        if [[ $PUSH_RESULT != 0 ]]; then
            echo_and_wait "Failed to push changes to remote"
        fi
    else
        echo_and_wait "Failed to commit changes"
    fi
else
    # The build failed so don't commit and tell the user
    echo "Build failed"
    exit 1
fi

echo_and_wait "Starting Application"
npm run start
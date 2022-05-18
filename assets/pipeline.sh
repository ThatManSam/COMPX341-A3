#!/usr/bin/bash

# Sleeping after each echo so that the user can see 
# them before npm spits out heaps of messages
SLEEP_TIME=1

echo_and_wait () {
    echo $1 && sleep $SLEEP_TIME
}

usage () {
    echo "Usage: pipeline {<Commit message>|--no-commit|--help}
<Commit message>        Message to have in the commit - Required
-n or --no-commit       Run the pipeline but don't commit changes
-h or --help            This help text"
}

# Checking command line options
while [[ "$1" != '' ]]; do
    case "$1" in
        -n | --no-commit)
            COMMIT=1
            shift 1
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            MESSAGE=$1
            shift 1
            ;;
    esac
done

# Setting the commit to true (0) if the --no-commit | -n flag wasn't given
if [[ -z $COMMIT ]]; then
    COMMIT=0

    # Setting the default message if none was specified
    if [[ -z $MESSAGE ]]; then
        MESSAGE="COMPX341-22A-A3 Commiting from CI/CD Pipeline"
        echo "Please enter a commit message
"
        usage
        exit 1
    fi
fi

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
    if [[ $COMMIT == 0 ]]; then
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
    fi
else
    # The build failed so don't commit and tell the user
    echo "Build failed"
    exit 1
fi

echo_and_wait "Starting Application"
npm run start
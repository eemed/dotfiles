#!/bin/bash

# f.sh - use fzf for stuff
# Source this in bashrc to add the f function

f() {
    case "$1" in
        ps|process)
            pid=$(ps a | sed 1d | fzf | awk '{print $1}')
            if [ "x$pid" != "x" ]; then
                echo $pid | xargs kill -9
            fi
            ;;

        j|jobs)
            local job jobstring
            jobstring=$(jobs)
            if [ "$jobstring" = "" ]; then
                echo "No background jobs"
            else
                job=$(jobs | fzf | sed 's/.*\[\([^]]*\)\].*/\1/g')
                fg $job
            fi
            ;;

        *)
            echo "Usage: $0 COMMAND"
            echo "  where COMMAND is one of"
            echo ""
            echo "  ps, process     kill process"
            echo "  j, jobs         foreground a background job"
            ;;
    esac
}

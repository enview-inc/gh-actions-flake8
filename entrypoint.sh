#!/bin/sh

# Copy the matcher to a shared volume with the host; otherwise "add-matcher"
# can't find it.
cp /code/flake8-matcher.json ${HOME}/
echo "::add-matcher::${HOME}/flake8-matcher.json"

# Create the flake8 arguments
echo "Running flake8 on '${INPUT_PATH}' with the following options:"
command_args=""
echo " - ignoring: '${INPUT_IGNORE}'"
if [ "x${INPUT_IGNORE}" != "x" ]; then
    command_args="${command_args} --ignore ${INPUT_IGNORE}"
fi
echo " - max line length: '${INPUT_MAX_LINE_LENGTH}'"
if [ "x${INPUT_MAX_LINE_LENGTH}" != "x" ]; then
    command_args="${command_args} --max-line-length ${INPUT_MAX_LINE_LENGTH}"
fi
echo " - select: '${INPUT_SELECT}'"
if [ "x${INPUT_SELECT}" != "x" ]; then
    command_args="${command_args} --select ${INPUT_SELECT}"
fi
echo " - exclude: '${INPUT_EXCLUDE}'"
if [ "x${INPUT_EXCLUDE}" != "x" ]; then
    command_args="${command_args} --exclude ${INPUT_EXCLUDE}"
fi
echo " - path: '${INPUT_PATH}'"
command_args="${command_args} ${INPUT_PATH}"
echo "Resulting command: flake8 ${command_args}"

# Run flake8
# echo "Flake8 version: "
# flake8 --version

flake8 ${command_args}
res=$?
if [ "$res" = "0" ]; then
    echo "Flake8 found no problems"
else
    echo "Flake8 found one or more problems"
    echo "If these are print statements, you can resolve them by using the enviewlogging package here: "
    echo "https://github.com/enview-inc/TheUtilities/tree/develop/enviewlogging_folder"
fi

# Remove the matcher, so no other jobs hit it.
echo "::remove-matcher owner=flake8-error::"
echo "::remove-matcher owner=flake8-warning::"

# If we are in warn-only mode, return always as if we pass
if [ -n "${INPUT_ONLY_WARN}" ]; then
    exit 0
else
    exit $res
fi

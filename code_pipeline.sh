#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------
# NAME:
#     SOURCES/apps/bin/code-pipeline.sh
#
# DESCRIPTION:
#     Script to register the project repository as software and create CI build pipeline in CoDE platform
#

echo "--[code-pipeline.sh]--------------------------------------------------------------------"
set -e

# Make sure you are inside a git repository root folder
if [ ! -d ".git" ]; then
        echo "Current directory is not a git repository. Please switch to a git repo"
        exit 1
fi

cwd=$(pwd)
repo_name=$(basename ${cwd})
echo "Repository Name: ${repo_name}"

# Ensure Code CLI (code control) is installed
codecontrol > /dev/null
status=$?

if [ "$status" -ne 0 ]; then
        echo "code control is not installed on the system. Please install it from "http://test.app.com/""
        exit 2
fi

# Register project as software and get the software id
# Software creation is required to create a CI pipeline in CoDE

# Check whether software is already created
software_id=$(codecontrol list software --filter "${repo_name}" | sed -n '2s/[^a-zA-Z0-9 -]//gp' | sed 's/ \+/ /g' | cut -d' ' -f2)
software_id=$(echo "${software_id:3:-3}")

if [ -n "$software_id" ]; then
        echo "Software already created for this project"
        echo "Software ID: ${software_id}"
else
        echo "Creating software..."
        # In CoDE, the "Unified Monitoring" application registered with id - 'c4e145f6db1d2f4c39fe9c9adb96198b'
        codecontrol create software --software-name "${repo_name}" --app-id "c4e4c39fe9c9adb96198b" --all-groups "it-app-git" --mailer-alias "app-developers"
        sleep 30

        # Ensure software registered successfully and get software id
        software_id=$(codecontrol list software --filter "${repo_name}" | sed -n '2s/[^a-zA-Z0-9 -]//gp' | sed 's/ \+/ /g' | cut -d' ' -f2)
        software_id=$(echo "${software_id:3:-3}")

        if [ -n "$software_id" ]; then
                echo "Software created successfully"
                echo "Software ID: ${software_id}"
        else
                echo "Failed to register repository as software"
                exit 3
        fi
fi

# Create a repo for the software. Even though we already created repo, it's required to create it in CoDE
# check if repo already exists
repo_url=$(codecontrol list repo --filter "${repo_name}" | awk 'NR==2 {print $4}')

if [ -n "$repo_url" ]; then
        echo "Repo is already created for this software"
        echo "Repo URL: ${repo_url}"
else
        echo "Creating repo for the software..."
        codecontrol create repo --software-id ${software_id} --repo-name ${repo_name} --project-key APPTEAM
        sleep 30

        # Verify repo created successfully
        repo_url=$(codecontrol list repo --filter "${repo_name}" | awk 'NR==2 {print $4}')

        if [ -n "$repo_url" ]; then
                echo "Repo created successfully"
                echo "Repo URL: ${repo_url}"
        else
                echo "Failed to create a repo for the software: ${repo_url}"
                exit 4
        fi
fi

# Create a CI build Pipeline for project
# Check whether pipeline is already created for this repository
pipeline=$(codecontrol list build --filter "${repo_name}")

if [ -n "$pipeline" ]; then
        echo "Pipeline is already created for this repository"
        pipeline_job_url=$(codecontrol list build --filter "${repo_name}" | awk 'NR==2 {print $3}')
        echo "Pipeline Job URL: ${pipeline_job_url}"
        exit 5
else
        echo "Creating pipeline..."
        echo "Yes" | codecontrol create build --server-name "test.app.com" --software-id "${software_id}" --ci-job-name "${repo_name}" --job-folder-path "IT/APPTEAM"
        sleep 30

        # Ensure pipeline created successfully and get the pipeline job url
        pipeline_job_url=$(codecontrol list build --filter "${repo_name}" | awk 'NR==2 {print $3}')

        if [ -n "$pipeline_job_url" ]; then
                echo "Pipeline created successfully for ${repo_name}"
                echo "Pipeline Job URL: ${pipeline_job_url}"
        else
                echo "Failed to create a pipeline"
                exit 6
        fi
fi


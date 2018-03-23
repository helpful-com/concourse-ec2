#!/bin/bash

set -e

BASE_DIR="/opt/concourse"

export CONCOURSE_BINARY_URL="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key concourse_binary_url)"
export FLY_BINARY_URL="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key fly_binary_url)"
export CONCOURSE_DB_URL="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key concourse_db_url)"

export USERNAME="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key username ci)"
export PASSWORD="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key password walt)"
export PIPELINE="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key pipeline)"

export GITHUB_AUTH_CLIENT_ID="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key github-auth-client-id)"
export GITHUB_AUTH_CLIENT_SECRET="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key github-auth-client-secret)"
export GITHUB_AUTH_ORGANIZATION="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key github-auth-organization)"
export GITHUB_AUTH_TEAM="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key github-auth-team)"

export AWS_HOSTNAME="$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)"

export HOSTNAME="$(curl -s http://169.254.169.254/latest/user-data | $BASE_DIR/bin/extract_yaml_key hostname $AWS_HOSTNAME)"

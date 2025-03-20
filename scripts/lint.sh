#!/bin/bash
set -e

# Get the directory containing the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "Running isort..."
python -m isort .

echo "Running black..."
python -m black .

echo "Running flake8..."
python -m flake8 src tests

echo "Running pytest with coverage..."
python -m pytest
#!/bin/bash

set -e  # Exit on any error
echo "🔧 Container entrypoint started."

# Optional: activate conda environment if needed
CONDA_PREFIX="tf29"
if [ -n "$CONDA_PREFIX" ]; then
    echo "✅ Activating conda environment: $CONDA_PREFIX"
    source /opt/conda/etc/profile.d/conda.sh
    source /opt/conda/bin/activate "$CONDA_PREFIX"
    exec "$@"

fi

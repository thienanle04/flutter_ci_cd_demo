#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <aab-or-apk-path>" >&2
  exit 2
fi

ARTIFACT_PATH="$1"

if [ -z "${FIREBASE_TOKEN-}" ] || [ -z "${FIREBASE_APP_ID-}" ]; then
  echo "FIREBASE_TOKEN or FIREBASE_APP_ID is not set. Aborting." >&2
  exit 1
fi

if [ ! -f "$ARTIFACT_PATH" ]; then
  echo "Artifact not found: $ARTIFACT_PATH" >&2
  exit 1
fi

echo "Installing firebase-tools..."
npm install -g firebase-tools@latest

echo "Uploading $ARTIFACT_PATH to Firebase App Distribution (app: $FIREBASE_APP_ID)"
firebase appdistribution:distribute "$ARTIFACT_PATH" \
  --app "$FIREBASE_APP_ID" \
  --token "$FIREBASE_TOKEN" \
  --release-notes "Automated build from Codemagic" || {
    echo "Firebase upload failed" >&2
    exit 1
  }

echo "Upload complete."

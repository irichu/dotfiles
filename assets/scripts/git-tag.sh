#!/usr/bin/env bash

SCRIPT_DIR="$(
	cd $(dirname $0)
	pwd
)"

git tag v$(cat "$SCRIPT_DIR"/../txt/version.txt)

# Push tag to remote
#git push origin v$(cat "$SCRIPT_DIR"/../txt/version.txt)

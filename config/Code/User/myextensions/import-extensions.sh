#!/bin/bash

cat code-extensions.txt | while read extension; do echo "Install $extension ..." && code --install-extension "$extension"; done

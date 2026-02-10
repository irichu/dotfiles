#!/usr/bin/env bash

ghostty +show-config --default --docs >ghostty_config.txt

bat ghostty_config.txt

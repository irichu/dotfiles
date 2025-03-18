#!/bin/bash

# date format
#date_format="%m/%d"
DATE_FORMAT="%Y-%m-%d" # iso date

# time format
TIME_FORMAT="%H:%M:%S"

# datetime format
#datetime_format_type=0 # "$date_format $time_format"
DATETIME_FORMAT_TYPE=1 # "$date_format(weekday) $time_format"
#datetime_format_type=2 # "$time_format $date_format(weekday)"

# weekday
SHOW_WEEKDAY="true"

# weekday color
DEFAULT_WEEKDAY_COLOR="colour231"
WEEKDAY_SUN_COLOR="colour204"
WEEKDAY_MON_COLOR=$default_weekday_color
WEEKDAY_TUE_COLOR=$default_weekday_color
WEEKDAY_WED_COLOR=$default_weekday_color
WEEKDAY_THU_COLOR=$default_weekday_color
WEEKDAY_FRI_COLOR=$default_weekday_color
WEEKDAY_SAT_COLOR="colour111"

THEME="developer-textcolored" # default
#THEME="developer"
#THEME="developer-textcolored"
#THEME="developer-colorful"
#THEME="developer-mono"

#THEME="dark-turquoise"
#THEME="dark-turquoise-textcolored"
#THEME="dark-turquoise-colorful"
#THEME="dark-turquoise-mono"

#THEME="dark-orange"
#THEME="dark-orange-textcolored"
#THEME="dark-orange-colorful"
#THEME="dark-orange-mono"

#THEME="dark-skyblue"
#THEME="dark-skyblue-textcolored"
#THEME="dark-skyblue-colorful"
#THEME="dark-skyblue-mono"

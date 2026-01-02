#!/usr/bin/env bash

tokei -o json . \
| jq -r '
  def header:
    "| Language | Files | Lines | Code | Comments | Blanks |",
    "| - | -: | -: | -: | -: | -: |";

  def files_count(v):
    if (v.reports? // [] | length) == 0
    then ""
    else (v.reports | length | tostring)
    end;

    def sum_stats(items):
    reduce items[].stats as $s (
        {code: 0, comments: 0, blanks: 0};
        .code += ($s.code // 0)
        | .comments += ($s.comments // 0)
        | .blanks += ($s.blanks // 0)
    );


  def total_files:
    (
      to_entries
      | map(select(.key != "Total"))
      | map(
          (.value.reports? // [] | length)

          # children are included
          #+
          #(
          #  .value.children? // {}
          #  | to_entries
          #  | map(.value | length)
          #  | add // 0
          #)
        )
      | add
    );

  header,

  (
    to_entries
    | map(select(.key != "Total"))
    | sort_by(.key)
    | .[]
    | .key as $lang
    | .value as $v

    # parent
    | (
        "| \($lang) | \(files_count($v)) | \($v.code + $v.comments + $v.blanks) | \($v.code) | \($v.comments) | \($v.blanks) |"
      ),

      # children
      (
        $v.children? // {}
        | to_entries[]
        | .key as $child
        | .value as $items
        | sum_stats($items)
        | "| \($lang)/\($child) | (\($items | length)) | \(.code + .comments + .blanks) | \(.code) | \(.comments) | \(.blanks) |"
      )
  ),

  (
    "| ----- | ----- | ----- | ----- | ----- | ----- |"
  ),

  (
    .Total as $t
    | "| **Total** | \(total_files) | \($t.code + $t.comments + $t.blanks) | \($t.code) | \($t.comments) | \($t.blanks) |"
  )
'

#!/usr/bin/env bash
JQ="/usr/bin/jq"

if ! test -f "$JQ"; then
  curl -Ls https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > "/usr/bin/jq" \
      && chmod +x "/usr/bin/jq"
fi

json_get_key() {
  local file="$1"
  local key="$2"

  if test -f "$file"; then
    jq -c -M --raw-output "$key // \"\"" < "$file" || return 1
  else
    echo ""
  fi
}

read_json() {
  local file="$1"
  local key="$2"

  if test -f "$file"; then
    # -c = print on only one line
    # -M = strip any color
    # --raw-output = if the filter’s result is a string then it will be written directly
    #                to stdout rather than being formatted as a JSON string with quotes
    # shellcheck disable=SC2002
    cat "$file" | $JQ -c -M --raw-output "$key // \"\"" || return 1
  else
    echo ""
  fi
}

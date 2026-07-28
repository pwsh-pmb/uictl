#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function fix_func_parens_space_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local RGX='^[+-]?\s*function '
  exec < <(
    git grep -nPe "$RGX"
    grep -nPe "$RGX" -- *.patch 2>/dev/null
    )
  local BUF= SRC= LNUM= FUNC_NAME= FUNC_ARGS=
  RGX="($RGX[A-Za-z0-9-]+)"
  while IFS= read -rs BUF; do
    SRC="${BUF%%:*}"; BUF="${BUF#*:}"
    LNUM="${BUF%%:*}"; BUF="${BUF#*:}"
    BUF="${BUF#*ion }"
    FUNC_NAME="${BUF%%[^A-Za-z0-9-]*}"
    BUF="${BUF:${#FUNC_NAME}}"
    BUF="${BUF%' {'}"
    case "$BUF" in
      '('*[a-z]*')' | \
      ' {'*[a-z]*'}' | \
      '' ) continue;;
    esac
    echo "# $SRC <$LNUM> $FUNC_NAME <<$BUF>>"
    case "$BUF" in
      ' ()' | '()' )
        echo "    ${LNUM}s~$RGX"' ?\(\) \{~\1 \{~';;
      ' ('*[a-z]*')' )
        echo "    ${LNUM}s~$RGX"' \(~\1\(~';;
    esac
  done
}










fix_func_parens_space_cli_init "$@"; exit $?

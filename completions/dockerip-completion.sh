#!/usr/bin/env bash

_dockerip_completions()
{
  COMPREPLY=($(compgen -W "$(docker ps --format "{{.Names}}")" -- "${COMP_WORDS[1]}"))
}

complete -F _dockerip_completions dockerip

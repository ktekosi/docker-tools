#!/usr/bin/env bash

_dockerbash_completions()
{
  COMPREPLY=($(compgen -W "$(docker ps --format "{{.Names}}")" -- "${COMP_WORDS[1]}"))
}

complete -F _dockerbash_completions dockerbash

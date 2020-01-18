#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# bat-extras | Copyright (C) 2019 eth-p | MIT License
#
# Repository: https://github.com/eth-p/bat-extras
# Issues:     https://github.com/eth-p/bat-extras/issues
# -----------------------------------------------------------------------------

# Returns 0 (true) if the current script pager is less, otherwise 1 (false)
is_pager_less() {
	[[ "$(get_pager)" = "less" ]]
}

# Echos the name of the pager command
get_pager() {
	echo "$(basename "${SCRIPT_PAGER_CMD[0]}")"
}

# Executes a command or function, and pipes its output to the pager (if exists).
#
# Returns: The exit code of the command.
# Example:
#     pager_exec echo hi
pager_exec() {
	if [[ -n "$1" ]]; then
		if [[ -n "$SCRIPT_PAGER_CMD" ]]; then
			"$@" | "${SCRIPT_PAGER_CMD[@]}" "${SCRIPT_PAGER_ARGS[@]}"
			return $?
		else
			"$@"
			return $?
		fi
	fi
}

# Displays the output of a command or function inside the pager (if exists).
#
# Example:
#     bat | pager_display
pager_display() {
	if [[ -n "$SCRIPT_PAGER_CMD" ]]; then
		"${SCRIPT_PAGER_CMD[@]}" "${SCRIPT_PAGER_ARGS[@]}"
	else
		cat
	fi
}

# -----------------------------------------------------------------------------

# Defaults.
SCRIPT_PAGER_CMD=("$PAGER")
SCRIPT_PAGER_ARGS=()

# Add arguments for the less pager.
if is_pager_less "$(basename "${SCRIPT_PAGER_CMD[0]}")"; then
	SCRIPT_PAGER_ARGS=(-R)
fi

# Prefer the bat pager.
if [[ -n "${BAT_PAGER+x}" ]]; then
	SCRIPT_PAGER_CMD=($BAT_PAGER)
	SCRIPT_PAGER_ARGS=()
fi

# Prefer no pager if not a tty.
if ! [[ -t 1 ]]; then
	SCRIPT_PAGER_CMD=()
	SCRIPT_PAGER_ARGS=()
fi

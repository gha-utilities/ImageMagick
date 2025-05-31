#!/usr/bin/env bash

##
# See https://github.com/orgs/community/discussions/106666 for multi-line outputs

#
# See https://github.com/bash-utilities/failure for updates of following function
#


# Bash Trap Failure, a submodule for other Bash scripts tracked by Git
# Copyright (C) 2023  S0AndS0
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation; version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


## Outputs Front-Mater formatted failures for functions not returning 0
## Use the following line after sourcing this file to set failure trap
##    trap 'failure "LINENO" "BASH_LINENO" "${?}"' ERR
failure(){
	local -n _lineno="${1:-LINENO}"
	local -n _bash_lineno="${2:-BASH_LINENO}"
	local _code="${3:-0}"

	## Workaround for read EOF combo tripping traps
	if ! ((_code)); then
		return "${_code}"
	fi

	local -a _output_array=()
	_output_array+=(
		'---'
		"lines_history: [${_lineno} ${_bash_lineno[*]}]"
		"function_trace: [${FUNCNAME[*]}]"
		"exit_code: ${_code}"
	)

	if [[ "${#BASH_SOURCE[@]}" -gt '1' ]]; then
		_output_array+=('source_trace:')
		for _item in "${BASH_SOURCE[@]}"; do
			_output_array+=("  - ${_item}")
		done
	else
		_output_array+=("source_trace: [${BASH_SOURCE[*]}]")
	fi

	_output_array+=('---')
	printf '%s\n' "${_output_array[@]}" >&2
	exit "${_code}"
}
trap 'failure "LINENO" "BASH_LINENO" "${?}"' ERR
set -Ee -o functrace


readarray -td ',' _destination_extensions < <(printf '%s' "${INPUT_DESTINATION_EXTENSIONS:?Undefined destination extensions}")
_source_directory="${INPUT_SOURCE_DIRECTORY:?Undefined source directory}"
_source_extension="${INPUT_SOURCE_EXTENSION:?Undefined source extension}"

_destination_name_prefix="${INPUT_DESTINATION_NAME_PREFIX:-}"
_destination_name_suffix="${INPUT_DESTINATION_NAME_SUFFIX:-}"
_destination_clobber="${INPUT_DESTINATION_CLOBBER:-0}"
_magick_opts="${INPUT_MAGICK_OPTS}"

_exec_magick="${INPUT_EXEC_MAGICK:?Undefined exec name/path for Image Magick}"

_found=()
_wrote=()
_failed=()

if ((VERBOSE)); then
	printf >&2 '_destination_extensions -> %s\n' "${_destination_extensions[@]}"
	printf >&2 '_source_extension -> %s\n' "${_source_extension}"
	printf >&2 '_magick_opts -> %s\n' "${_magick_opts}"
	printf >&2 '_source_directory -> %s\n' "${_source_directory}"
fi

while read -rd '' _source_path; do
	_found+=("${_source_path}")

	_source_dirname="$(dirname "${_source_path}")"
	_source_basename="$(basename "${_source_path}")"
	_source_name="${_source_basename%.*}"

	if ((VERBOSE)); then
		printf >&2 '_source_dirname -> %s\n' "${_source_dirname}"
		printf >&2 '_source_basename -> %s\n' "${_source_basename}"
		printf >&2 '_source_name -> %s\n' "${_source_name}"
	fi

	_destination_path_without_extension="${_source_dirname}/${_destination_name_prefix}${_source_name}${_destination_name_suffix}"

	if ((VERBOSE)); then
		printf >&2 '_destination_path_without_extension -> %s\n' "${_destination_path_without_extension}"
		printf >&2 '_source_name -> %s\n' "${_source_name}"
	fi

	for _extension in "${_destination_extensions[@]}"; do
		if ! (( ${#_extension} )); then
			break
		fi

		_destination_path="${_destination_path_without_extension}.${_extension}"
		if ((VERBOSE)); then
			printf >&2 '_destination_path -> %s\n' "${_destination_path}"
		fi

		if [[ "${_source_path}" == "${_destination_path}" ]]; then
			continue
		elif [[ -f "${_destination_path}" ]] && ! ((_destination_clobber)); then
			continue
		fi

		_command=()
		if ((${#_magick_opts})); then
			if ((VERBOSE)); then
				printf >&2 'magick "%s" %s "%s"\n' "${_source_path}" "${_magick_opts}" "${_destination_path}"
			fi
			# shellcheck disable=SC2206
			_command=("${_exec_magick}" "${_source_path}" ${_magick_opts} "${_destination_path}")
		else
			if ((VERBOSE)); then
				printf >&2 '%s "%s" "%s"\n' "${_exec_magick}" "${_source_path}" "${_destination_path}"
			fi
			_command=("${_exec_magick}" "${_source_path}" "${_destination_path}")
		fi

		if "${_command[@]}"; then
			_wrote+=("${_destination_path}")
		else
			_failed+=("${_destination_path}")
		fi
	done
done < <(find "${_source_directory}" -type f -print0)

if (( ${#_found[@]} )); then
	tee -a 1>/dev/null "${GITHUB_OUTPUT:?Undefined GitHub Output environment variable}" <<EOL
found<<EOF
$(printf '%s\n' "${_found[@]}")
EOF
EOL
fi

if (( ${#_wrote[@]} )); then
	tee -a 1>/dev/null "${GITHUB_OUTPUT:?Undefined GitHub Output environment variable}" <<EOL
wrote<<EOF
$(printf '%s\n' "${_wrote[@]}")
EOF
EOL
fi

if (( ${#_failed[@]} )); then
	tee -a 1>/dev/null "${GITHUB_OUTPUT:?Undefined GitHub Output environment variable}" <<EOL
failed<<EOF
$(printf '%s\n' "${_failed[@]}")
EOF
EOL
fi

# vim: noexpandtab

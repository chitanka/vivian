# exit the script if somewhere is an uninitialised variable
set -o nounset
#  exit the script if any statement returns a non-true value
#set -o errexit

is_function_loaded() {
	local func_name=$1
	type $func_name &>/dev/null
}

# Check if a value exists in an array
# @param $1 mixed  Needle
# @param $2 array  Haystack
# @return  Success (0) if value exists, Failure (1) otherwise
# Usage: in_array "$needle" "${haystack[@]}"
# See: http://fvue.nl/wiki/Bash:_Check_if_array_element_exists
in_array() {
	local hay needle=$1
	shift
	for hay; do
		[[ $hay == $needle ]] && return 0
	done
	return 1
}

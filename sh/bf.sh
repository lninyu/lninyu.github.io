function unko() {
    local -i SL=100 SS=0xff pos ptr mem=(0) t=() bracket=()
    local IFS= string="${1}" char

    # shellcheck disable=2124,2206
    for ((pos = 0; pos < ${#string}; ++pos)) {
        case "${string:pos:1}" in
        '[') t+=(pos); ;;
        ']') bracket[pos]=${t[@]: -1}
             bracket[${bracket[pos]}]=pos
             t=(${t[@]:0:${#t[@]}-1}) ;;
        esac
    }

    for ((pos = 0; pos < ${#string}; ++pos)) {
        char="${string:pos:1}"

        case "${char}" in
        '>') ((++ptr, ptr = ptr > SL ? 0 : ptr, mem[ptr] = mem[ptr])) ;;
        '<') ((--ptr, ptr = ptr < 0 ? SL : ptr, mem[ptr] = mem[ptr])) ;;
        '+') ((++mem[ptr], mem[ptr] = mem[ptr] > SS ? 0 : mem[ptr])) ;;
        '-') ((--mem[ptr], mem[ptr] = mem[ptr] < 0 ? SS : mem[ptr])) ;;
        '[') ((mem[ptr] == 0)) && pos=${bracket[pos]} ;;
        ']') ((mem[ptr] != 0)) && pos=${bracket[pos]} ;;
        '.') printf -v char "%02x" "${mem[ptr]}"; printf "%b" "\\x${char}" ;;
        ',') read -rn1 char; printf -v mem[ptr] "%d" "'${char}" ;;
        esac
    }
}

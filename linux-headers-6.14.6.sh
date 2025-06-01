pkg_name="linux-headers"
pkg_ver="6.14.6"

function pkg_fetch {
    local url="https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.14.6.tar.xz"
    fetch_url "${url}" "archive.tar.xz"
}

function pkg_prepare {
    local cmd=(tar -xf "archive.tar.xz" --strip-components=1)
    entry "Cleaning up package"
    local cmd=(make mrproper)
    shell_cmd "${cmd[@]}"
    entry "Generating headers"
    cmd=(make headers)
    shell_cmd "${cmd[@]}"
}

function pkg_install {
    local inst_dir="${AX_INSTS}/${pkg_name}-${pkg_ver}"
    create_dirs "${inst_dir}/usr"
    cmd=(cp -r usr/include "${inst_dir}/usr")
    shell_cmd "${cmd[@]}"
}

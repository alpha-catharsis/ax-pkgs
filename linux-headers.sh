pkg_name="linux-headers"
pkg_vers=("6.14.6")

function pkg_fetch {
    local pkg_ver="${1}"
    local url="https://www.kernel.org/pub/linux/kernel/v6.x/linux-${pkg_ver}.tar.xz"
    fetch_url "${url}" "linux.tar.xz"
}

function pkg_prepare {
    local pkg_ver="${1}"
    unpack_archive_stripped "linux.tar.xz"
    entry "Cleaning up package"
    local cmd=(make mrproper)
    shell_cmd "${cmd[@]}"
    entry "Generating headers"
    cmd=(make headers)
    shell_cmd "${cmd[@]}"
    cmd=(find usr/include -type f ! -name '*.h' -delete)
    shell_cmd "${cmd[@]}"
}

function pkg_install {
    local pkg_ver="${1}"
    local inst_dir="${AX_INSTS}/${pkg_name}/${pkg_ver}"
    create_dirs "${inst_dir}/usr"
    cmd=(cp -r usr/include "${inst_dir}/usr")
    shell_cmd "${cmd[@]}"
}

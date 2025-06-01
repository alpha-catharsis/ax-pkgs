pkg_name="glibc"
pkg_ver="2.41"

function pkg_fetch {
    local url="https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz"
    fetch_url "${url}" "archive.tar.xz"
    url="https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.41-fhs-1.patch"
    fetch_url "${url}" "glibc-2.41-fhs-1.patch"
}

function pkg_prepare {
    unpack_archive_stripped "archive.tar.xz"
    entry "Creating 64-bit library compatibility links"
    local cmd=(ln -sfv ../lib/ld-linux-x86-64.so.2 "${AX_ROOT}"/lib64)
    shell_cmd "${cmd[@]}"
    cmd=(ln -sfv ../lib/ld-linux-x86-64.so.2 "${AX_ROOT}"/lib64/ld-lsb-x86-64.so.3)
    shell_cmd "${cmd[@]}"
    apply_patch "glibc-2.41-fhs-1.patch"
    prepare_build
    entry "Enforcing the use of [path:/usr/sbin] directory"
    echo "rootsbindir=/usr/sbin" > configparms
    configure_build ".." \
      "--prefix=/usr" \
      "--host=${AX_TGT}" \
      "--build=$(../scripts/config.guess)" \
      "--with-headers=${AX_ROOT}/usr/include" \
      "--disable-nscd" \
      "libc_cv_slibdir=/usr/lib" \
      "--enable-kernel=5.4"
    compile_build
}

function pkg_install {
    local inst_dir="${AX_INSTS}/${pkg_name}/${pkg_ver}"
    create_dirs "${inst_dir}/usr"
    install_build "${inst_dir}"
    entry "Fix hardcoded path to the executable loader in [note:ldd] script"
    cmd=(sed /RTLDLIST=/s@/usr@@g -i "${inst_dir}"/usr/bin/ldd)
    shell_cmd "${cmd[@]}"
}

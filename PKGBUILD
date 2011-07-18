# Contributor : Devaev Maxim <mdevaev@gmail.com>

pkgname=linux-scripts
pkgver=20110718
pkgrel=1
pkgdesc="Additional useful scripts"
arch=('any')
url="http://github.com/mdevaev/linux-scripts.git"
license="GPL"
makedepends=('git')

_gitroot="git://github.com/mdevaev/linux-scripts.git"
_gitname="linux-scripts"


build() {
    cd $startdir/src
    if [ -d $_gitname ]; then
        msg "Updateing local repository..."
        cd $_gitname
        git pull origin master || return 1
        msg "The local files are updated."
        cd ..
    else
        git clone $_gitroot --depth=1
    fi

    msg "Git clone done or server timeout"
    msg "Starting make..."

    rm -rf $_gitname-build
    cp -r $_gitname $_gitname-build
    cd $_gitname-build

    make DESTDIR=$pkgdir install
}


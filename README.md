## 环境准备
- yum -y install gcc gcc-c++ autoconf automake libtool make openssl openssl-devel pcre-devel libxml2-devel libcurl-devel libicu-devel openldap openldap-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libpng libpng-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses curl  gdbm-devel db4-devel libXpm-devel libX11-devel gd-devel gmp-devel readline-devel libxslt-devel expat-devel xmlrpc-c xmlrpc-c-devel libvpx-devel libzip libzip-devel
- imageMagic
- libwebp
- openresty
- ngx_devel_kit
- nginx-http-concat
- lua-nginx-module



## 安装lua
```
cd /opt/openresty-1.11.2.4/bundle/LuaJIT-2.1-20170405
make && make install --prefix=xxxx 
```
## 设置环境

### /etc/ld.so.conf
```
/usr/local/lib
/usr/local/lib64
```
### /etc/profile
```
export LUAJIT_LIB=/usr/local/lib
export LUAJIT_INC=/usr/local/include/luajit-2.1:/usr/local/webserver/nginx
export LD_LIBRARY_PATH=/usr/local/lib
```

## 安装nginx
```
./configure \
--prefix=/usr/local/webserver/nginx  \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_flv_module \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--add-module=/opt/nginx-http-concat-master \
--add-module=/opt/openresty-1.11.2.4/bundle/ngx_devel_kit-0.3.0 \
--add-module=/opt/lua-nginx-module-0.10.10   
```


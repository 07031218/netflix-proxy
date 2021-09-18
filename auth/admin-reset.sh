#!/usr/bin/env bash

# globals
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
SQLITE_DB=${CWD}/db/auth.db

read -sp "请输入欲设置的新密码: " PASSWORD && printf "\n"
echo -e "----------开始修改密码-----------"
    #pushd ${CWD} && \
     HASH=$(python3 ${CWD}/pbkdf2_sha256_hash.py ${PASSWORD} | awk '{print $2}') && \
      sqlite3 ${SQLITE_DB} "UPDATE USERS SET password='${HASH}' WHERE id=1;" && \
    #  popd && \
      printf "Congratulations，密码修改完成。新密码为：${PASSWORD}\n"

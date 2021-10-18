#!/usr/bin/env bash

# globals
apt install python3-pip > /dev/null 2>&1
pip3 install passlib > /dev/null 2>&1
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
SQLITE_DB=${CWD}/db/auth.db
read -p "请输入欲设置新密码的账户的用户名: " USERNAME && printf "\n"
read -sp "请输入欲设置的新密码: " PASSWORD && printf "\n"
echo -e "----------开始修改密码-----------"
    #pushd ${CWD} && \
     HASH=$(python3 ${CWD}/pbkdf2_sha256_hash.py ${PASSWORD} | awk '{print $2}') && \
      sqlite3 ${SQLITE_DB} "UPDATE USERS SET password='${HASH}' WHERE username='${USERNAME}';" && \
    #  popd && \
      printf "Congratulations，${USERNAME}的密码修改完成。新密码为：${PASSWORD}\n"

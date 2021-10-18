#!/usr/bin/env bash

# globals
apt install python3-pip > /dev/null 2>&1
pip3 install passlib > /dev/null 2>&1
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
SQLITE_DB=${CWD}/db/auth.db
echo -e "----------------------开始创建用户------------------------"
read -p "请输入用户名: " USERNAME
read -sp "请输入密码: " PASSWORD && printf "\n"
read -p "请输入过期日期? (YYYY-MM-DD): " EXPIRES
read -p "请输入0或1来选择用户组 (0=user 1=admin): " PRIVILEGE

if [[ ! ${EXPIRES} =~ [0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
    printf "invalid date=${EXPIRES} (e.g. YYYY-MM-DD)\n"
    exit 1
fi

if [[ -n "${USERNAME}" && -n "${PASSWORD}" && -n "${EXPIRES}" && -n "${PRIVILEGE}" ]]; then
    printf "adding username=${USERNAME} expires=${EXPIRES} privilege=${PRIVILEGE}\n"
    pushd ${CWD} && \
      HASH=$(python3 ${CWD}/pbkdf2_sha256_hash.py ${PASSWORD} | awk '{print $2}') && \
      sqlite3 ${SQLITE_DB} "INSERT INTO USERS (privilege, expires, username, password) VALUES (${PRIVILEGE}, '${EXPIRES}', '${USERNAME}', '${HASH}');" && \
      popd
else
    printf "invalid input user=\"${USERNAME}\" password=\"${PASSWORD}\" expires=\"${EXPIRES}\" privilege=\"${PRIVILEGE}\"\n"
    exit 1
fi

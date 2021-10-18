#!/usr/bin/env bash

# globals
apt install python3-pip > /dev/null 2>&1
pip3 install passlib > /dev/null 2>&1
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
SQLITE_DB=${CWD}/db/auth.db

read -p "请输入要修改过期日期的用户名名称: " USERNAME
read -p "输入过期日期? (YYYY-MM-DD): " EXPIRES

if [[ ! ${EXPIRES} =~ [0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
    printf "invalid date=${EXPIRES} (e.g. YYYY-MM-DD)\n"
    exit 1
fi

if [[ -n "${USERNAME}" && -n "${EXPIRES}" ]]; then
    printf "editing username=${USERNAME} expires=${EXPIRES} \n"
    echo -e "----------------------开始修改${username}的过期日期-------------------------"
      sqlite3 ${SQLITE_DB} "UPDATE USERS SET expires='${EXPIRES}' WHERE username=${USERNAME};" && \
    echo -e "----------修改${username}的过期日期完成，新的过期日期为${EXPIRES}-----------"
else
    printf "invalid input user=\"${USERNAME}\" expires=\"${EXPIRES}\" \n"
    exit 1
fi

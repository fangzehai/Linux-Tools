#!/bin/bash

list="/root/shell/host.list"
if [ $# -lt 1 ]
then
    echo "请添加远程指令 eg: ./admin-cmd.sh cm1[-ops]";
    exit 1;
fi
if [[ "$1" =~ (rm|init|userdel) ]]
then
    echo -e "======= \033[31m 正在执行敏感指令，请谨慎操作 \033[0m ========="
    sleep 2;
fi
cat -n $list
echo "----------------------"
read -p "请输入要执行命令的主机编号或分组名称，输入ALL可发送到所有主机 " num
if [ "$num" = "ALL" ]
then
    ip=`cat $list | grep "[0-9]"`
elif [ ! "$num" = "ALL" ] && [[ $num  =~ ^[a-Z] ]]
then

    res=`grep "\<$num\>" $list | wc -l`
    if [ $res -eq 0 ]
    then
        echo "分组不存在";
        exit 1;
    else 
        ip=`sed -n '/'$num'/,/^[[]/{p}' $list | grep "^[0-9]"`
    fi
    else 
    for n in `echo $num`
    do
      ip="$ip `cat -n $list | awk 'NR=='$n'&&$NF ~ /^[0-9]/{print $NF}'`"
    done
fi
for i in `echo $ip`
do
    echo -e "------- 正在连接 \033[31m $i \033[0m --------"
    ssh  $i $*;
done

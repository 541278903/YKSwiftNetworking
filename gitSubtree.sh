pullOrPush="pull"
gitAddress="https://gitee.com/Edwrard"
moduleName=""
confirmed="n"

getActionName(){
    read -p "请输入你想做的操作？ (pull/push/add):" pullOrPush

    if test -z "$pullOrPush"; then
        getActionName
    fi
}

getModuleName(){
    getActionName
    read -p "请输入你要处理的模块？" moduleName
}

echo "\n"
while [ "$confirmed" != "y" -a "$confirmed" != "Y" ]
do
    if [ "$confirmed" == "n" -o "$confirmed" == "N" ]; then
        getModuleName
    fi
    read -p "是否确认处理? (y/n):" confirmed
done


echo "================================================"
echo "  执行指令 git subtree ${pullOrPush} --prefix=Module/${moduleName} ${gitAddress}/${moduleName}.git master --squash"
echo "================================================\n"

#cd ..
git status
git subtree "${pullOrPush}" --prefix="Module"/"${moduleName}" "${gitAddress}"/"${moduleName}".git master --squash
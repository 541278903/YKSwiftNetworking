pullOrPush="pull"
gitAddress="https://gitee.com/Edwrard"
moduleName="-1"
confirmed="n"
name=""


function getsum(){

	name=$@
	echo ${name}

	git status
	git subtree "${pullOrPush}" --prefix="Module"/"${name}" "${gitAddress}"/"${name}".git master --squash
}

getActionName(){

    moduleName=$1
    
    case $moduleName in
        1)
            getsum 'YKSwiftNetworking'
        ;;
        2)
            getsum 'YKNetWorking'
        ;;
        3)
            getsum 'YKSwiftBaseClass'
        ;;
        4)
            getsum 'YKSwiftBaseTools'
        ;;
        5)
            getsum 'YKSwiftCommandModule'
        ;;
        6)
            getsum 'YKSwiftDB'
        ;;
        7)
            getsum 'YKSwiftExectionModel'
        ;;
        8)
            getsum 'YKSwiftMediator'
        ;;
        9)
            getsum 'YKSwiftAlert'
        ;;
        10)
            getsum 'YKSwiftRefresh'
        ;;
        11)
            getsum 'YKSwiftSectionViewModel'
        ;;
        12)
            getsum 'YKSwiftViews'
        ;;
    esac
}

getAllModule(){
    int=1
    max=12
    while(( $int<=$max ))
    do
        getActionName $int
        let "int++"
    done
}

getAllModule

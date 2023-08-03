component=dispatch
source common.sh

func_apppreq
 echo -e "\e[36m>>>>>>>>>>>> go lang setup <<<<<<<<<<<<\e[0m"

go mod init dispatch
go get
go build



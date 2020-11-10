#!/bin/bash

major=""
minor=""
release=""
version_txt="/home/scripts/docker/version.txt"

arg_num=$#
prog_name=$(basename $0)
version="1.0"

function print_version(){
  echo "$prog_name $version"
  exit 0
}

function set_version(){
  echo "[NOTE] reading version info from $version_txt"
  if [ ! -e $version_txt ];then
    echo "[ERROR] ERR_NOT_FOUND_FILE : $version_txt not found"
    return 1
  elif [ ! -r $version_txt ];then
    echo "[ERROR] ERR_BAD_PRIV : $version_txt not be read"
    return 1
  fi
  
  major=$(cat $version_txt | grep major | awk -F "=" '{print $2}')
  minor=$(cat $version_txt | grep minor | awk -F "=" '{print $2}')
  
  return 0
}

if [ $arg_num = 1 ];then
  # User specify release only
  set_version
  if [ $? -ne 0 ];then
    echo "[ERROR] ERR_INTARNAL_ERROR"
    exit 1
  fi
  release=$1

elif [ $arg_num -eq 3 ];then
  # User specify major, minor, release
  major=$1
  minor=$2
  release=$3
else
  echo "[ERROR] ERR_BAD_ARGUMENT : this script "
  exit 1
fi

version=$(echo "$major.$minor.$release")
container_name="mysql$major$minor$release"
cmd="echo -e '[client]\nuser=root\npassword=root\nprompt=$container_name> ' > ~/.my.cnf"

echo "[NOTE] Your choice version MySQL $version"

for v in $(docker images | grep ^mysql | awk '{print $2}');do
  if [ "$v" = "$version" ];then
    echo "[NOTE] MySQL $version already exists. You can check it by using 'docker images'"
    docker start $container_name
    if [ $? -ne 0 ];then
      echo "[ERROR] ERR_DOCKER_CMD"
      exit 1
    fi
    docker exec -it $container_name bash -c "$cmd"
    echo "[SUCCESS] You can start docker with [ docker exec -it $container_name bash -p ] !"
    exit 0
  fi
done

echo "[NOTE] MySQL $version doesn't exist, We will get it..."
docker run -it --name $container_name -e MYSQL_ROOT_PASSWORD=root -d mysql:$version


if [ $? -ne 0 ];then
  echo "[ERROR] ERR_DOCKER_CMD"
  exit 1
fi

echo "[SUCCESS] Getting $contariner_name successfull!"
echo "[NOTE] We will setting my.cnf"

docker exec -it $container_name bash -c "$cmd"

if [ $? -ne 0 ];then
  echo "[ERROR] ERR_DOCKER_CMD"
  exit 1
fi

echo "[SUCCESS] All operation is done! you can login [ docker exec -it $container_name bash -p ]"

exit 0

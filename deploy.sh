#!/bin/bash
# ========= <CONFIG =========
# git url to clone repo.
repo_url=required*
# repo name, MUST be the same with the name in repo_url.
repo_name=required*
# branch with the code that will be deployed.
repo_branch=required*
# war name to be deployed.
war_name=required*
# this will replace the original configuration from repo
configuration_folder=required*
# server folder to be deployed
deploy_folder=required*
# server refresh rate
server_refresh=10s
# ========= CONFIG> =========
build_folder=deploying_war
build_root=$(pwd)
check_errors()
{
    if [[ $1 != 0 ]] ; then
        cd $build_root
        rm -r $build_folder
       exit 1
    fi
}
# make folder for deploying
echo "trying to remove older and unused folders"
rm -r $build_folder
mkdir $build_folder
# clone repo
echo "cloning repo $repo_url"
cd $build_folder
git clone -b $repo_branch --single-branch $repo_url
check_errors $?
cd $build_root
# replace configuration
cp -a $configuration_folder/. $build_folder/$repo_name/src/main/resources/
check_errors $?
# create a build
echo "creating build"
cd $build_folder/$repo_name
mvn clean install
check_errors $?
cd $build_root
# deploy build
echo "deploying"
rm $deploy_folder/$war_name
# waiting server
echo "waiting for server to take changes. $server_refresh"
sleep $server_refresh
cp $build_folder/$repo_name/target/*.war $deploy_folder/$war_name
check_errors $?
# removing build folder
cd $build_root
rm -r $build_folder
echo "DEPLOYED"

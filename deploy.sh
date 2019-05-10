#!/bin/bash
# ========= <CONFIG =========
# git url to clone repo.
repo_url=required*
# repo name, MUST be the same with the name in repo_url.
repo_name=required*
# branch or tag to be deployed.
repo_branch_or_tag=required*
# war name to be deployed without '.war' extension.
war_name=required*
# this will replace the original configuration from repo.
configuration_folder=required*
# build path; target for maven and build/libs for gradle.
build_path=required*
# script to build war (inside "").
build_script="required*"
# server folder to be deployed
deploy_folder=required*
# server refresh rate
server_refresh=10s
# ========= CONFIG> =========
temp_path=deploying_war
build_root=$(pwd)
check_errors()
{
    if [[ $1 != 0 ]] ; then
        cd $build_root
        rm -r $temp_path
       exit 1
    fi
}
# make folder for deploying
echo "Trying to remove older and unused folders"
rm -r $temp_path
mkdir $temp_path
# clone repo
echo "Cloning repo $repo_url"
cd $temp_path
git clone -b $repo_branch_or_tag --single-branch $repo_url
check_errors $?
cd $build_root
# replace configuration
echo "Replacing configuration files from $configuration_folder"
cp -a $configuration_folder/. $temp_path/$repo_name/src/main/resources/
check_errors $?
# create a build
echo "Creating build"
cd $temp_path/$repo_name
echo "Executing: $build_script"
eval $build_script
check_errors $?
cd $build_root
# deploy build
echo "Deploying to $deploy_folder"
rm $deploy_folder/${war_name}.war
# waiting server
echo "Waiting for server to undeploy previous version $server_refresh"
sleep $server_refresh
echo "Copying project from $build_path to deploy folder"
cp $temp_path/$repo_name/$build_path/*.war $deploy_folder/${war_name}.war
check_errors $?
# removing build folder
cd $build_root
rm -r $temp_path
echo "SUCCESS"

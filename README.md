[![](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/elbraulio)

# ghcd

Easy deployments for git projects. This supports __Maven and Gradle Java projects__.

# How to 

All you need to set the configuration in the beginning of the `deploy.sh` file. It looks like this is:

```bash
# ========= <CONFIG =========
... all variables to change are here
# ========= CONFIG> =========
```

## variables

| name                 | description                                                  | example                                 |
| :------------------- | ------------------------------------------------------------ | --------------------------------------- |
| repo_url             | url to clone git repo.                                       | `https://github.com/elbraulio/ghcd.git` |
| repo_name            | repo name that is included in `repo_url`.                    | `ghcd`                                  |
| repo_branch_or_tag   | branch or tag that you want to deploy.                       | `master` or `1.2.3`                     |
| war_name             | name with which the war will be deployed __without '.war' extension__. | `dev-api`                               |
| configuration_folder | contains the configurations files that will replace the original repo configuration files. | `/opt/configs/project1/config`          |
| build_path | where the build is placed. | `target` for maven and `build/libs` for gradle |
| build_script | script to build war (inside ""). | `"./gradle build"` |
| deploy_folder        | path to the folder where the war should be copied.           | `/opt/tomcat/webapps`                   |
| server_refresh       | the time that takes your server to refresh and deploy a new change. With a __s__ at the end. | `10s` (__with a 's' at the end__)       |

## execute

after you run this you must allow to execute the script doing this

```bash
$ chmod +x deploy.sh
```

now you can deploy your war using

```bash
$ ./deploy.sh
```

# Contribute

Follow this rule, after each action you must go to `$build_root`. So at the beginning of each action you can assume you are in `$build_root`.


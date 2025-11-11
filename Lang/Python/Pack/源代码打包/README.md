# 简介

在一台 `Windows PC` （`DEV_PC`）进行开发，在另一台 `Windows PC` （`TARGET_PC`）进行运行，`DEV_PC` 可以联网，`TARGET_PC` 不能联网。在开发中打包整个项目为EXE，在 `TARGET_PC` 上无法进行调试。所以转而打包项目的所有源代码以及运行环境，复制到 `TARGET_PC` 进行调试运行。

# 流程

1. 在 `DEV_PC` ，运行脚本 `download_requirements.bat` 下载依赖包。
2. 复制所有目录到 `TARGET_PC` 。
3. 在 `TARGET_PC` 修改 `venv` 配置，修改 `pyenv.cfg` 中的 `home` 为 `TARGET_PC` 的 `Python` 安装路径，修改 `script\activate.bat` 中的 `VIRTUAL_ENV` 为
   `TARGET_PC` 的`venv`路径。
4. 在 `TARGET_PC` 运行脚本 `setup.bat` 安装依赖包。

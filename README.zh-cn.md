# Dotfiles

[English](README.md) | [中文](README.zh-cn.md)

适用于 Linux 桌面环境的共享配置文件，专注于简约实用工具配置。

> [!WARNING]
> 这些配置文件在一些依赖，包括但不限于命令行、主题以及图片。请检查这些配置文件并自行修复。

## 使用方法

### 快速开始
```bash
# 查看可用配置
./sync.sh list

# 安装所有配置
./sync.sh install

# 安装特定配置
./sync.sh install sway waybar tmux
```

### 命令说明
- `./sync.sh list` - 显示可用配置
- `./sync.sh install [configs...]` - 从仓库安装配置到系统
- `./sync.sh backup [configs...]` - 备份系统配置到仓库
- `./sync.sh status [configs...]` - 检查同步状态
- `./sync.sh --dry-run` - 预览更改而不应用

### 使用示例
```bash
# 安装桌面环境
./sync.sh install sway waybar swaylock mako

# 安装终端设置
./sync.sh install tmux kitty zsh

# 备份当前配置
./sync.sh backup

# 预览安装内容
./sync.sh install --dry-run

# 备份时排除个人信息
./sync.sh backup --exclude-personal
```

## 配置

编辑 `sync_config.toml` 来自定义同步行为、添加/删除配置或更改路径。

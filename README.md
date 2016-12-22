# dotfiles

`.zshrc`:需要安装`oh-my-zsh`，请参考 [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)。

`minirc.dfl`:minicom的配置文件，默认连接`/dev/ttyUSB0`。

`10-monitor.conf`:当外接vga或者HDMI时，对应屏幕的分辨率信息，请将此文件放置于`/usr/share/X11/xorg.conf.d/`之下

`desktop_files`:文件夹放一些第三方软件所编写的desktop文件。

`.gitconfig`:我的git配置

`.tmux.conf`:我的tmux配置(tmux 2.1或者以上)


# 安装

请到[relase链接](https://github.com/tracyone/dotfiles/releases)下载最新稳定版本，或者通过下面的命令来获取最新稳定版本:

```
git clone https://github.com/tracyone/dotfiles && cd dotfiles && git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
```

然后在dotfiles文件夹下执行：

```bash
./install.sh
```

上面脚本会帮你安装`tmux`、`zsh`、`git`和`xclip`等必要软件。然后会帮你装[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)以及其插件还有tmux的插件，最后将相关文件链接到相关目录下，完成安装。


# zsh配置说明

用了oh-my-zsh之外的一个插件:[zshmarks](https://github.com/jocelynmallon/zshmarks)，作用是标记书签然后跳转，详细用法请看链接，我另外alias了一下：

```bash
# 保存当前路劲为书签
b <书签名>
```

```bash
# 跳转到指定书签路劲上面，支持tab补全。
j <书签名>
```

# tmux配置说明

主要是参考大神[Val Markovic](https://github.com/Valloric)的[配置](https://github.com/Valloric/dotfiles/blob/master/tmux/tmux-main.conf)，然后做了一些修改，解决了一些痛点。

* 本配置支持tmux 1.8以上包括2.1以上。支持Mac OS X系统，支持Windows下的msys2，支持所有linux发行版本。
* 支持复制到三个操作系统的系统剪贴板上面。
* **prefix**按键是**Ctrl-a**。
* **prefix +  -**是水平分屏
* **prefix +  \**是垂直分屏
* **prefix + m**是开启鼠标功能
* **prefix + M**是关闭鼠标功能，默认关闭。
* **prefix + Ctrl-K**是关闭当前session并跳到下一个。
* 按**prefix + [**进入复制模式的时候，是使用vi模式的快捷键进行选中、复制、搜索和移动。
* **prefix +  r**重新加载tmux配置文件
* **prefix +  +**当前pannel最大化**prefix +  _**恢复。
* **prefix + (**和**prefix + )**用于切换前后session。
* **prefix + h**、**prefix + j**、**prefix + k**和**prefix + l**用于Pane之间的移动，遵循vim的hjkl的方向。
* **prefix + H**、**prefix + J**、**prefix + K**和**prefix + L**用于微调pane的大小。
* 使用插件管理器[tpm](https://github.com/tmux-plugins/tpm)来管理插件，按**prefix + I**执行插件的安装。
* 使用插件[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)用于保存当前session的布局以及打开的文件然后下次可以迅速的恢复，按**prefix + Ctrl-s**  进行保存，按**prefix + Ctrl-r** 进行恢复。
* 使用插件[tmux-copycat](https://github.com/tmux-plugins/tmux-copycat)用于更复杂的搜索，支持正则表达式搜索。按**prefix + /**进行搜索。

**截图**

![zsh和tmux的结合](https://cloud.githubusercontent.com/assets/4246425/11912547/06507e76-a67c-11e5-9a46-946c1aa9b545.png)

由于有了vim+tmux+zsh，所以用什么终端对我来说差别不大，所以我用的是Mac OSX自带terminal，主题的话使用solarized，请在这个链接中找[solarized](https://github.com/altercation/solarized)，里面有各种工具的solarized主题配置文件，包括Mac自带终端，iterm2，vim，gnome终端等等。

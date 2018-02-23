# Brangelina.vim

## Installation instructions
- install vim8 with python3 support
    `brew install vim --without-python --with-python3`
- [Install Neovim, along with the Python2, Python3, and Ruby modules](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- Run `:CheckHealth` to ensure everything is working correctly
- [Install vim-plug](https://github.com/junegunn/vim-plug#installation)
- Clone the brangelina repository
- Create an `init.vim` file that sources `branglina.vim` in your cloned repo.
  You can use `init.example.vim` as a template or example.
- Run `:PlugInstall`
- Run `:UpdateRemotePlugins`

## Usage

### Linting
Brangeline comes with [ale](https://github.com/w0rp/ale), a plugin that will automatically look for linters you have install and run them on the proper files.

### Theming
Brangelina doesn't come with a theme, you can install one yourself. Check `init.example.vim` for an example.

### Custom plugins
Brangeline used [vim-plug](https://github.com/junegunn/vim-plug) as a plugin manager. You can easily add additional plugins to those that come with Brangelina. Check `init.example.vim` to see how it's done.

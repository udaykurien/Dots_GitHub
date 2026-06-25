{ config, pkgs, pkgs-unstable, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      nodejs        # required by coc.nvim
      wl-clipboard  # for clipboard=unnamedplus on Wayland
      python3       # for g:python3_host_prog
    ];

    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withAllGrammars)
      vim-devicons
      vim-snippets
      nerdtree
      nerdcommenter
      vim-startify
      coc-nvim
      vim-polyglot

      # Themes
      kanagawa-nvim
      neovim-ayu
      rose-pine
      vscode-nvim
      onedark-nvim
      kanagawa-nvim
      dracula-vim
      gruvbox
      gruvbox-material
      tokyonight-nvim
      catppuccin-nvim
      onedark-vim
      nord-vim
    ];

    initLua = ''
      vim.filetype.add({
        extension = {
          kdl = 'kdl',
        },
      })

    require('nvim-treesitter').setup()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
    
    vim.cmd.colorscheme("kanagawa-dragon")
  '';

    extraConfig = ''
      let g:python3_host_prog = '${pkgs.python3}/bin/python3'
      set clipboard=unnamedplus
      
      set indentexpr=v:lua.vim.treesitter.indentexpr()

      set nocompatible
      set showmatch
      set ignorecase
      set hlsearch
      set incsearch
      set tabstop=4
      set softtabstop=4
      set expandtab
      set shiftwidth=4
      set autoindent
      set number
      set wildmode=longest,list
      filetype plugin indent on
      syntax on
      set mouse=a
      filetype plugin on
      set cursorline
      set cursorcolumn
      set ttyfast

      nnoremap <C-n> :NERDTreeToggle<CR>
    '';
  };
}

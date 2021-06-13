{ neovim-unwrapped
, neovimUtils
, vimPlugins
, wrapNeovimUnstable
}:

let
  config = neovimUtils.makeNeovimConfig {
    configure.customRC = ''
      set clipboard+=unnamedplus
      " set completeopt=menu,longest,preview
      set completeopt=menuone,noinsert,noselect
      set conceallevel=0
      set cursorline
      set expandtab
      set formatoptions=croqj
      " set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
      set hidden
      set list
      set listchars=tab:>-,trail:-,extends:>,precedes:>,conceal:*,nbsp:+
      set mouse=a
      set relativenumber
      set scrolloff=5
      set shiftwidth=0
      set shortmess=aoOtTIF
      set sidescrolloff=5
      set softtabstop=-1
      set splitbelow
      set splitright
      set switchbuf=useopen,usetab
      set tabstop=2
      set textwidth=78
      set tildeop
      set timeoutlen=500
      set title
      set titlestring=nvim\ %F
      set wildignore&
      " set wildignore+=*/.git/objects/*
      " set wildignore+=*/node_modules/*
      set wildmenu
      set wildmode=longest:full
      set winminheight=0

      " set nohlsearch
      set noshowmode
      set nowrap

      " Add the (homebrew-installed) fzf plugin to the search path.
      " set runtimepath+=/usr/local/opt/fzf

      colorscheme gruvbox

      let g:airline_powerline_fonts = 1

      let g:airline#extensions#tabline#buffer_min_count = 0
      let g:airline#extensions#tabline#buffer_nr_show = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#show_buffers = 1
      let g:airline#extensions#tabline#show_close_button = 0
      let g:airline#extensions#tabline#show_tab_nr = 0
      let g:airline#extensions#tabline#show_tab_count = 1
      let g:airline#extensions#tabline#tab_min_count = 0
      let g:airline#extensions#tabline#tab_nr_type = 1

      let g:completion_enable_auto_popup = 1

      let g:vim_markdown_folding_disabled = 1
      let g:vim_markdown_frontmatter = 1

      " let g:go_fmt_command = "goimports"

      " let g:LanguageClient_serverCommands = {}
      " let g:LanguageClient_serverCommands['nix'] = ['rnix-lsp']

      let g:mapleader = " "

      nnoremap <silent> <esc>      :nohlsearch<cr>
      nnoremap <silent> <leader>   :WhichKey '<space>'<cr>
      nnoremap          <leader>bd :bdelete<cr>
      nnoremap          <leader>bn :bnext<cr>
      nnoremap          <leader>bp :bprevious<cr>
      nnoremap          <leader>h  :vertical help<space>
      nnoremap          <leader>tt :NERDTreeToggleVCS<cr>
      nnoremap          <leader>tf :NERDTreeFind<cr>

      nnoremap <silent> <m-up>    :.move .-2<cr>
      nnoremap <silent> <m-down>  :.move .+1<cr>
      nnoremap <silent> <m-left>  :bprevious<cr>
      nnoremap <silent> <m-right> :bnext<cr>

      :lua << EOF
          local lspconfig = require('lspconfig')

          local on_attach = function(_, bufnr)
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
              require('completion').on_attach()
          end

          local servers = {'zls'}
          for _, lsp in ipairs(servers) do
              lspconfig[lsp].setup {
                  on_attach = on_attach,
              }
          end
      EOF
    '';

    configure.packages.all-the-stuff.start = with vimPlugins; [
      # vim-caddyfile

      completion-nvim
      gruvbox
      nerdtree
      nvim-lspconfig
      nvim-treesitter
      typescript-vim
      vim-airline
      vim-go
      vim-nix
      vim-terraform
      vim-toml
      vim-which-key
      zig-vim
    ];
  };

  neovim = wrapNeovimUnstable neovim-unwrapped config;
in
  neovim

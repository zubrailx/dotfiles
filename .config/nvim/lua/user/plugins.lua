return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    tag = 'nightly' -- optional, updated every week
  }
  use {
       'nvim-treesitter/nvim-treesitter',
       run = ':TSUpdate'
  }
  use 'neovim/nvim-lspconfig'
end)


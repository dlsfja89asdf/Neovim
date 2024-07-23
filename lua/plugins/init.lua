return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "prettier",
        "prettierd",
        "asm-lsp",
        "asmfmt",
        "cpplint",
        "cpptools",
        "csharpier",
        "clangd",
        "clang-format",
        "pyright",
        "typos",
        "typos-lsp",
        "powershell-editor-services",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "vim",
          "lua",
          "vimdoc",
          "c",
          "cpp",
          "asm",
          "c_sharp",
          "cmake",
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "graphql",
          "javascript",
          "json",
          "jsonc",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "xml",
          "groovy",
        },
        sync_install = false,
        auto_install = true,
        indent = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }

      local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      treesitter_parser_config.powershell = {
        install_info = {
          url = vim.fn.expand "$userprofile" .. "/AppData/Local/nvim-data/lazy/tree-sitter-powershell",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "main",
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
        filetype = "ps1",
      }
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = false,
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }
      require("telescope").load_extension "ui-select"
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    config = function()
      require("diffview").setup {
        default_args = {
          DiffviewOpen = { "--imply-local" },
        },
      }
      vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<CR>", { desc = "Show diff view" })
      vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diff view" })
      vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Close diff view" })

      -- gitsigns
      vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<CR>", { desc = "Show diff view" })
      vim.keymap.set(
        "n",
        "<leader>gl",
        "<cmd>Gitsigns toggle_current_line_blame<CR>",
        { desc = "Toggle current line blame" }
      )
    end,
  },
  {
    "coffebar/neovim-project",
    lazy = false,
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append "globals" -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
      -- reset nvim-tree
      require("nvim-tree").setup {
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      }
    end,
    config = function()
      -- setup
      require("neovim-project").setup {
        projects = { -- define project roots
          "C:/git/*",
          vim.fn.expand "$userprofile" .. "/AppData/Local/nvim",
        },
        last_session_on_startup = false,
        dashboard_mode = true,
      }
      -- mappings
      vim.keymap.set("n", "<leader>pp", "<cmd>Telescope neovim-project discover<CR>", { desc = "Discover projects" })
      vim.keymap.set(
        "n",
        "<leader>po",
        "<cmd>Telescope neovim-project history<CR>",
        { desc = "Discover projects history" }
      )
      vim.keymap.set("n", "<leader>pr", "<cmd>NeovimProjectLoadRecent<CR>", { desc = "Load recent project" })
      -- vim.keymap.set("n", "<leader>pi", "<cmd>NeovimProjectLoadHist<CR>")
      -- vim.keymap.set("n", "<leader>pl", "<cmd>NeovimProjectLoad<CR>")
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      { "Shatur/neovim-session-manager" },
    },
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Mandatory
      "nvim-tree/nvim-web-devicons", -- Optional but recommended
    },
    ft = "markdown",
    config = function()
      require("render-markdown").setup {}
    end,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      animate = {
        enabled = false,
      },
      bottom = {
        {
          ft = "fugitive",
          title = "Git",
        },
        {
          ft = "qf",
          title = "QuickFix",
        },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        {
          ft = "trouble",
          title = "Diagnostics",
          filter = function(buf, win)
            return (vim.w[win].trouble ~= nil) and vim.w[win].trouble.mode == "diagnostics"
          end,
          size = {
            height = 0.25,
          },
          open = "<cmd>Trouble diagnostics toggle<cr>",
        },
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "NvimTree",
          ft = "NvimTree",
          size = { width = 0.1 },
        },
      },
      right = {
        {
          ft = "trouble",
          title = "Symbols",
          filter = function(buf, win)
            return (vim.w[win].trouble ~= nil) and vim.w[win].trouble.mode == "symbols"
          end,
          size = {
            width = 0.25,
          },
          pinned = true,
          open = "<cmd>Trouble symbols toggle focus=false<cr>",
        },
        {
          ft = "trouble",
          title = "LSP",
          filter = function(buf, win)
            return (vim.w[win].trouble ~= nil) and vim.w[win].trouble.mode == "lsp"
          end,
          size = {
            width = 0.25,
          },
          pinned = true,
          open = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        },
      },
    },
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    config = function()
      require("trouble").setup {}
      -- local actions = require("telescope.actions")
      local open_with_trouble = require("trouble.sources.telescope").open
      -- Use this to add more results without clearing the trouble list
      -- local add_to_trouble = require("trouble.sources.telescope").add

      local telescope = require "telescope"

      telescope.setup {
        defaults = {
          mappings = {
            i = { ["<c-t>"] = open_with_trouble },
            n = { ["<c-t>"] = open_with_trouble },
          },
        },
      }
    end,
    cmd = "Trouble",
    keys = {
      {
        "<leader>cx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>cX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>cL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>cQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = "<leader>/",
    event = "VeryLazy",
    config = function()
      require("Comment").setup {
        ignore = "^$",
        toggler = {
          line = "<leader>/",
        },
      }
      local ft = require "Comment.ft"
      ft({ "c", "cpp", "h", "hpp" }, "//%s", "/*%s*/")
      ft({ "python" }, "#%s")
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    cmd = "Telescope frecency",
    keys = {
      {
        "<C-p>",
        "<cmd>Telescope frecency workspace=CWD<cr>",
        desc = "Open file picker",
      },
    },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = { ".*\\.git.*" },
        },
        extensions = {
          frecency = {
            db_safe_mode = false,
            show_unindexed = true,
            ignore_patterns = { ".*\\.git.*" },
            default_workspace = "CWD",
            workspace_scan_cmd = { "fd", "-Htf" },
          },
        },
      }
    end,
  },
  {
    "onsails/lspkind.nvim",
    lazy = false,
  },
  {
    "tpope/vim-abolish",
    lazy = false,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
      }
      local cmp = require "cmp"
      cmp.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- For luasnip users.
        }, {
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "bufname" },
          { name = "buffer-lines" },
          { name = "calc" },
          { name = "nvim_lsp_signature_help" },
        }),
      }

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline({ "/", "?" }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = "buffer" },
      --   },
      -- })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(":", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --   }, {
      --     { name = "cmdline" },
      --   }),
      --   matching = { disallow_symbol_nonprefix_matching = false },
      -- })
    end,
    dependencies = {
      { "rasulomaroff/cmp-bufname" },
      { "amarakon/nvim-cmp-buffer-lines" },
      { "hrsh7th/cmp-calc" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
    dependencies = {
      { "lewis6991/gitsigns.nvim" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    cmd = { "TodoTelescope" },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
    },
    config = function()
      require("todo-comments").setup()
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("illuminate").configure()
    end,
  },
  {
    "airbus-cert/tree-sitter-powershell",
    lazy = true,
    -- Skip this file
    build = "git update-index --skip-worktree Cargo.toml",
  },
  {
    "TheLeoP/powershell.nvim",
    opts = {
      bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
      shell = "powershell",
    },
  },
  {
    "chentoast/marks.nvim",
    lazy = false,
    opts = {
      -- whether to map keybinds or not. default true
      default_mappings = true,
      -- which builtin marks to show. default {}
      builtin_marks = { ".", "<", ">", "^" },
      -- whether movements cycle back to the beginning/end of buffer. default true
      cyclic = true,
      -- whether the shada file is updated after modifying uppercase marks. default false
      force_write_shada = false,
      -- how often (in ms) to redraw signs/recompute mark positions.
      -- higher values will have better performance but may cause visual lag,
      -- while lower values may cause performance penalties. default 150.
      refresh_interval = 250,
      -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
      -- marks, and bookmarks.
      -- can be either a table with all/none of the keys, or a single number, in which case
      -- the priority applies to all marks.
      -- default 10.
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      -- disables mark tracking for specific filetypes. default {}
      excluded_filetypes = {},
      -- disables mark tracking for specific buftypes. default {}
      excluded_buftypes = {},
      -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
      -- sign/virttext. Bookmarks can be used to group together positions and quickly move
      -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
      -- default virt_text is "".
      bookmark_0 = {
        sign = "⚑",
        virt_text = "hello world",
        -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
        -- defaults to false.
        annotate = false,
      },
      mappings = {},
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      vim.opt.updatetime = 100
      vim.diagnostic.config { virtual_text = false }
      vim.cmd.HideVirtualText()
      require("tiny-inline-diagnostic").setup()
    end,
  },
  {
    "Badhi/nvim-treesitter-cpp-tools",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "c", "cpp", "h", "hpp" },
    config = function()
      require("nt-cpp-tools").setup()
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "h", "hpp" },
    config = function()
      require("clangd_extensions").setup()
    end,
  },
  {
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    config = function()
      require("overseer").setup()
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
  },
  {
    "gorbit99/codewindow.nvim",
    event = "BufEnter",
    config = function()
      local codewindow = require "codewindow"
      codewindow.setup {
        auto_enable = true,
        minimap_width = 10,
        -- screen_bounds = "background",
      }
      codewindow.apply_default_keybinds()
      -- Set the highlights
      vim.api.nvim_set_hl(0, "CodewindowBorder", { fg = "#222222" })
      -- vim.api.nvim_set_hl(0, "CodewindowUnderline", { fg = "#aaaaaa" })
    end,
  },
  -- {
  --   "gh-liu/fold_line.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     -- change the char of the line, see the `Appearance` section
  --     vim.g.fold_line_char_open_start = "╭"
  --     vim.g.fold_line_char_open_end = "╰"
  --   end,
  -- },
}

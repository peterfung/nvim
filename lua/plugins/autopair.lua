return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup {}
    -- config autopairs
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local nvim_cmp = require('cmp')
    nvim_cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end
}

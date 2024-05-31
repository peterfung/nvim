return {
 'akinsho/toggleterm.nvim', 
 version = "*", 
 config = function()
  require('toggleterm').setup({
   -- 快捷键 ctrl + \
   open_mapping = [[<c-\>]],
   -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
   direction =  'float'
  })
 end
}

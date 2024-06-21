return {
 'akinsho/toggleterm.nvim', 
 version = "*", 
 config = function()
  require('toggleterm').setup({
   -- 快捷键 ctrl + 1
   open_mapping = [[<c-1>]],
   -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
   direction =  'float'
  })
 end
}

local M = {
  fps = 10,
}

local matrix_chars = {
  -- Half-width katakana
  "ｱ",
  "ｲ",
  "ｳ",
  "ｴ",
  "ｵ",
  "ｶ",
  "ｷ",
  "ｸ",
  "ｹ",
  "ｺ",
  "ｻ",
  "ｼ",
  "ｽ",
  "ｾ",
  "ｿ",
  "ﾀ",
  "ﾁ",
  "ﾂ",
  "ﾃ",
  "ﾄ",
  "ﾅ",
  "ﾆ",
  "ﾇ",
  "ﾈ",
  "ﾉ",
  "ﾊ",
  "ﾋ",
  "ﾌ",
  "ﾍ",
  "ﾎ",
  "ﾏ",
  "ﾐ",
  "ﾑ",
  "ﾒ",
  "ﾓ",
  "ﾔ",
  "ﾕ",
  "ﾖ",
  "ﾗ",
  "ﾘ",
  "ﾙ",
  "ﾚ",
  "ﾛ",
  "ﾜ",
  "ｦ",
  "ﾝ",
  -- Numbers
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  -- Special characters
  "!",
  "@",
  "#",
  "$",
  "%",
  "^",
  "&",
  "*",
  "(",
  ")",
  "-",
  "_",
  "=",
  "+",
  "[",
  "]",
  "{",
  "}",
  "|",
  "\\",
  ":",
  ";",
  '"',
  "'",
  "<",
  ">",
  ",",
  ".",
  "?",
  "/",
  "~",
  "`",
}

vim.api.nvim_set_hl(0, "MatrixGreen", { fg = "#138c13" })
vim.api.nvim_set_hl(0, "MatrixDark1", { fg = "#274e30" })
vim.api.nvim_set_hl(0, "MatrixDark2", { fg = "#0d1c11" })
vim.api.nvim_set_hl(0, "MatrixGlitch", { fg = "#93c9a1" })
vim.api.nvim_set_hl(0, "MatrixHead", { fg = "#8ed1cb" })
vim.api.nvim_set_hl(0, "MatrixTail", { fg = "#425842" })
local all_matrix_hls = { "MatrixGreen", "MatrixDark1", "MatrixDark2", "MatrixGlitch", "MatrixHead", "MatrixTail" }
local core_matrix_hls = { "MatrixGreen", "MatrixDark1", "MatrixDark2" }
local function cell_matrix_hl(hls, cell)
  for i = 1, #hls do
    if hls[i] == cell.hl_group then
      return true
    end
  end
  return false
end

M.update = function(grid)
  for col = 1, #grid[1] do
    for row = #grid, 2, -1 do
      local cell = grid[row][col]
      local up_cell = grid[row - 1][col]

      if up_cell.hl_group == "MatrixHead" then -- update head
        cell.char = matrix_chars[math.random(#matrix_chars)]
        cell.hl_group = "MatrixHead"
        up_cell.hl_group = core_matrix_hls[math.random(#core_matrix_hls)]
      elseif up_cell.hl_group == "MatrixTail" then -- delete after tail
        cell.hl_group = "MatrixTail"
        up_cell.char = " "
        up_cell.hl_group = nil
      elseif cell.hl_group == "MatrixGlitch" then -- reset glitch
        cell.hl_group = core_matrix_hls[math.random(#core_matrix_hls)]
      elseif grid[#grid][col].hl_group == "MatrixHead" then -- remove head at bottom
        grid[#grid][col].hl_group = core_matrix_hls[math.random(#core_matrix_hls)]
      elseif grid[#grid][col].hl_group == "MatrixTail" then -- remove tail at bottom
        grid[#grid][col].char = " "
        grid[#grid][col].hl_group = nil
      elseif cell_matrix_hl(all_matrix_hls, cell) then -- random events
        if math.random() < 0.01 then -- randomly change char
          cell.char = matrix_chars[math.random(#matrix_chars)]
        elseif math.random() < 0.01 then -- randomly glitch
          cell.hl_group = "MatrixGlitch"
        end
      end
    end

    if math.random() < 0.005 then
      grid[1][col].char = matrix_chars[math.random(#matrix_chars)]
      grid[1][col].hl_group = "MatrixHead"
    end

    local hard_term = math.min(50, #grid)
    local term_row = math.random(hard_term - 20, hard_term)
    if grid[term_row][col].char ~= " " and cell_matrix_hl(all_matrix_hls, grid[term_row][col]) then
      grid[1][col].char = " "
      grid[2][col].hl_group = "MatrixTail"
    end
  end
  return true
end

return M

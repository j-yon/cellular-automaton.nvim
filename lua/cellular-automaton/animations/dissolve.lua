local M = {
  fps = 50,
}

M.update = function(grid)
  for i = 1, #grid do
    for j = 1, #grid[i] do
      if math.random() < 0.05 and grid[i][j].char ~= " " then
        grid[i][j].char = " "
      end
    end
  end
  return true
end

return M

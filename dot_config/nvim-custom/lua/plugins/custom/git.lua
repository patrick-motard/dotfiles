local openPullRequest = function(commit)
  local cmd = 'gh pr list --search ' .. commit .. '  --json url'
  -- local cmd = 'gh pr list --search ' .. commit .. '  --state merged --json url'
  local handle = io.popen(cmd)
  if handle then
    local output = handle:read '*all' -- Read all output
    handle:close()
    local table = vim.json.decode(output)
    if #table == 0 then
      vim.notify('No pull request found for commit: ' .. commit)
      return
    end
    local pr_url = table[1].url

    vim.notify(pr_url)
    os.execute('open ' .. pr_url)
  else
    vim.notify('Error executing command: ' .. cmd)
  end
end
-- openPullRequest '98'
local M = {}
M.openPullRequest = openPullRequest
return M

local openPullRequest = function(commit)
  local cmd = 'gh pr list --search ' .. commit .. '  --state merged --json url'
  local handle = io.popen(cmd)
  if handle then
    local output = handle:read '*all' -- Read all output
    handle:close()
    local table = vim.json.decode(output)
    local pr_url = table[1].url

    os.execute('open ' .. pr_url)
  else
    vim.notify('Error executing command: ' .. cmd)
  end
end

M = {}
M.openPullRequest = openPullRequest
return M

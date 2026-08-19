return {
  'Olical/conjure',
  ft = { 'clojure', 'edn' },
  config = function()
    vim.g['conjure#mapping#prefix'] = '<localleader>'
    vim.g['conjure#log#wrap'] = true
    vim.g['conjure#log#hud#width'] = 0.8
    vim.g['conjure#log#hud#height'] = 0.4
    vim.g['conjure#log#hud#anchor'] = 'SE'
    require('conjure.main').main()
    require('conjure.mapping')['on-filetype']()

    local clojure_host = '127.0.0.1'
    local clojure_port = 5555
    local clojure_launcher = vim.fn.expand '~/code/dotfiles-private/bin/clojure-repl'
    local clojure_job
    local clojure_starting = false

    local function server_is_available(callback)
      local socket = vim.uv.new_tcp()
      if not socket then
        callback(false)
        return
      end

      socket:connect(clojure_host, clojure_port, function(err)
        socket:close()
        vim.schedule(function()
          callback(err == nil)
        end)
      end)
    end

    local function connect_to_clojure()
      vim.cmd(('ConjureConnect %s %d'):format(clojure_host, clojure_port))
    end

    local function wait_for_server(attempt)
      server_is_available(function(available)
        if available then
          clojure_starting = false
          connect_to_clojure()
        elseif attempt >= 50 then
          clojure_starting = false
          vim.notify('Clojure nREPL did not start on 127.0.0.1:5555', vim.log.levels.ERROR)
        else
          vim.defer_fn(function()
            wait_for_server(attempt + 1)
          end, 100)
        end
      end)
    end

    local function start_clojure()
      if clojure_starting then
        vim.notify 'Clojure nREPL is already starting'
        return
      end

      clojure_starting = true
      server_is_available(function(available)
        if available then
          clojure_starting = false
          connect_to_clojure()
          return
        end

        if clojure_job and vim.fn.jobwait({ clojure_job }, 0)[1] == -1 then
          wait_for_server(1)
          return
        end

        if vim.fn.executable(clojure_launcher) ~= 1 then
          clojure_starting = false
          vim.notify('Clojure launcher not found: ' .. clojure_launcher, vim.log.levels.ERROR)
          return
        end

        clojure_job = vim.fn.jobstart({ clojure_launcher }, {
          stdin = 'null',
          stdout_buffered = true,
          stderr_buffered = true,
          on_exit = function(job, code)
            if clojure_job == job then
              clojure_job = nil
            end
            if code ~= 0 then
              vim.schedule(function()
                vim.notify(('Clojure launcher exited with status %d'):format(code), vim.log.levels.ERROR)
              end)
            end
          end,
        })

        if clojure_job <= 0 then
          clojure_job = nil
          clojure_starting = false
          vim.notify('Failed to start the Clojure launcher', vim.log.levels.ERROR)
          return
        end

        wait_for_server(1)
      end)
    end

    pcall(vim.api.nvim_del_user_command, 'ClojureStart')
    vim.api.nvim_create_user_command('ClojureStart', start_clojure, {
      desc = 'Start and connect to the Clojure nREPL',
    })

    local doc_win

    local function decode_result(result)
      local ok, decoded = pcall(vim.json.decode, result)
      if ok and type(decoded) == 'string' then
        return decoded
      end
      return result
    end

    local function format_docs(output)
      local entries = {}
      local current = {}

      local function add_entry()
        if #current > 0 then
          table.insert(entries, current)
          current = {}
        end
      end

      for _, line in ipairs(vim.split(output, '\n', { plain = true })) do
        local normalized = line:gsub('%s+$', '')
        if normalized ~= '' and normalized:match '^%-+$' then
          add_entry()
        elseif normalized ~= '' then
          table.insert(current, normalized)
        end
      end
      add_entry()

      local markdown = {}
      for _, entry in ipairs(entries) do
        local title = table.remove(entry, 1)
        table.insert(markdown, '## `' .. title .. '`')
        table.insert(markdown, '')

        local signatures = {}
        while entry[1] and entry[1]:match '^%(' do
          table.insert(signatures, table.remove(entry, 1))
        end
        if #signatures > 0 then
          table.insert(markdown, '```clojure')
          vim.list_extend(markdown, signatures)
          table.insert(markdown, '```')
          table.insert(markdown, '')
        end

        for _, line in ipairs(entry) do
          table.insert(markdown, (line:gsub('^%s+', '')))
        end
        table.insert(markdown, '')
      end

      if #markdown == 0 then
        return { '_No matching documentation found._' }
      end
      return markdown
    end

    local function show_docs(result)
      if doc_win and vim.api.nvim_win_is_valid(doc_win) then
        vim.api.nvim_win_close(doc_win, true)
      end

      local output = decode_result(result)
      local buf, win = vim.lsp.util.open_floating_preview(
        format_docs(output),
        'markdown',
        {
          border = 'rounded',
          focusable = true,
          max_width = math.floor(vim.o.columns * 0.8),
          max_height = math.floor(vim.o.lines * 0.6),
          wrap = true,
        }
      )
      doc_win = win
      vim.keymap.set('n', 'q', function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end, { buffer = buf, silent = true })
      vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
    end

    local function find_clojure_doc()
      vim.ui.input({ prompt = 'Clojure docs: ' }, function(query)
        if not query or query == '' then
          return
        end
        local form = ('(do (require \'clojure.repl) (with-out-str (clojure.repl/find-doc %s)))'):format(vim.json.encode(query))
        require('conjure.eval')['eval-str'] {
          code = form,
          origin = 'command',
          ['passive?'] = true,
          ['suppress-hud?'] = true,
          ['on-result'] = function(result)
            vim.schedule(function()
              show_docs(result)
            end)
          end,
        }
      end)
    end

    pcall(vim.api.nvim_del_user_command, 'ClojureFindDoc')
    vim.api.nvim_create_user_command('ClojureFindDoc', find_clojure_doc, {
      desc = 'Search Clojure documentation by text',
    })

    local function setup_doc_search_mapping(buf)
      vim.keymap.set('n', '<localleader>fd', find_clojure_doc, {
        buffer = buf,
        desc = 'Search Clojure documentation',
      })
    end

    setup_doc_search_mapping(0)
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('conjure-documentation', { clear = true }),
      pattern = { 'clojure', 'edn' },
      callback = function(event)
        setup_doc_search_mapping(event.buf)
      end,
    })
  end,
}

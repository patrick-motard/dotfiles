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

    local function find_clojure_doc()
      vim.ui.input({ prompt = 'Clojure docs: ' }, function(query)
        if not query or query == '' then
          return
        end
        local form = ('(do (require \'clojure.repl) (clojure.repl/find-doc %s))'):format(vim.json.encode(query))
        vim.cmd('ConjureEval ' .. form)
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

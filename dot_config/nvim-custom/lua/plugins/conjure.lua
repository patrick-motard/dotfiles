return {
  'Olical/conjure',
  ft = { 'clojure', 'edn' },
  config = function()
    vim.g['conjure#mapping#prefix'] = '<localleader>'
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
  end,
}

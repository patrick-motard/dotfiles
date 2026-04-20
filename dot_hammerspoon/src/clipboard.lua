local M = {}

-- hyper+r: refine current clipboard via Claude Haiku, then auto-paste
hs.hotkey.bind(hyper, "r", "Refine clipboard (Handy)", function()
    hs.notify.new({
        title = "Refining clipboard",
        informativeText = "Sending to Claude Haiku...",
        withdrawAfter = 2,
    }):send()

    -- true = source user shell profile so PATH picks up ~/.local/bin
    local output, status = hs.execute("refine-clipboard 2>&1", true)

    if status then
        hs.notify.new({
            title = "Refined",
            informativeText = "Clipboard updated; pasting",
            withdrawAfter = 2,
        }):send()
        -- Small delay to let the focused app settle before paste
        hs.timer.doAfter(0.05, function()
            hs.eventtap.keyStroke({ "cmd" }, "v", 0)
        end)
    else
        hs.notify.new({
            title = "Refine failed",
            informativeText = (output and output ~= "") and output or "unknown error",
            withdrawAfter = 5,
        }):send()
    end
end)

return M

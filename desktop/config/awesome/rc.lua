-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- {{{ Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys.firefox")

-- External dependencies
package.path = package.path .. ";"
    .. gears.filesystem.get_configuration_dir() .. "plugins/?.lua;"
    .. gears.filesystem.get_configuration_dir() .. "plugins/?/init.lua"

local lain = require("lain")
local scrlocker = "betterlockscreen -l --show-layout &"
local freedesktop = require("freedesktop")

-- }}}

-- {{{ Plugins

-- {{{ Awesome switcher
local switcher = require("awesome-switcher")

switcher.settings.preview_box = false                                     -- display preview-box
switcher.settings.preview_box_bg = "#dddddd88"                            -- background color
switcher.settings.preview_box_border = "#222222aa"                        -- border-color
switcher.settings.preview_box_fps = 30                                    -- refresh framerate
switcher.settings.preview_box_delay = 2000000000                          -- delay in ms (big delay because small panel appears)
switcher.settings.preview_box_title_font = { "sans", "italic", "normal" } -- the font for cairo
switcher.settings.preview_box_title_font_size_factor = 0.8                -- the font sizing factor
switcher.settings.preview_box_title_color = { 0, 0, 0, 0 }                -- the font color

switcher.settings.client_opacity = false                                  -- opacity for unselected clients
switcher.settings.client_opacity_value = 0.5                              -- alpha-value for any client
switcher.settings.client_opacity_value_in_focus = 0.5                     -- alpha-value for the client currently in focus
switcher.settings.client_opacity_value_selected = 1                       -- alpha-value for the selected client

switcher.settings.cycle_raise_client = true                               -- raise clients on cycle
-- }}}

-- }}}

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })

    in_error = false
  end)
end

-- }}}

--- {{{ Variable / Function definitions

local chosen_theme = "powerarrow-dark"
local modkey = "Mod4"
local altkey = "Mod1"
local ctrl = "Control"
local shift = "Shift"
local terminal = "alacritty"
local vi_focus = false  -- vi-like client focus https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev = true -- cycle with only the previously focused client or all https://github.com/lcpz/awesome-copycats/issues/274
local editor = os.getenv("EDITOR") or "nvim"

local function s_width()
  return awful.screen.focused().geometry.width
end

local function s_height()
  return awful.screen.focused().geometry.height
end

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  --awful.layout.suit.tile.bottom,
  --awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  --awful.layout.suit.spiral,
  --awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.floating,
  --awful.layout.suit.max.fullscreen,
  --awful.layout.suit.magnifier,
  --awful.layout.suit.corner.nw,
  --awful.layout.suit.corner.ne,
  --awful.layout.suit.corner.sw,
  --awful.layout.suit.corner.se,
  --lain.layout.cascade,
  --lain.layout.cascade.tile,
  --lain.layout.centerwork,
  --lain.layout.centerwork.horizontal,
  --lain.layout.termfair,
  --lain.layout.termfair.center
}


lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

-- Actions with tags buttons
awful.util.taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then client.focus:move_to_tag(t) end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then client.focus:toggle_tag(t) end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Actions with opened tasks
awful.util.tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", { raise = true })
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function() awful.client.focus.byidx(1) end),
  awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))

-- }}}

-- {{{ Menu

-- Create a launcher widget and a main menu
local myawesomemenu = {
  { "Hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "Manual",      string.format("%s -e man awesome", terminal) },
  { "Edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
  { "Restart",     awesome.restart },
  { "Quit",        function() awesome.quit() end },
}


awful.util.mymainmenu = freedesktop.menu.build {
  before = {
    { "Awesome", myawesomemenu, beautiful.awesome_icon },
    -- other triads can be put here
  },
  after = {
    { "Open terminal", terminal },
    -- other triads can be put here
  }
}
-- }}}

-- {{{ Screen

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function(s)
  -- naughty.notify({ text = "arranging!" })

  for _, c in pairs(s.clients) do
    local border_width;

    local only_one = #s.tiled_clients == 1
    local layout_tiling = awful.layout.get(s) ~= awful.layout.suit.floating
    if (only_one and layout_tiling and not c.floating) or c.maximized or c.fullscreen then
      border_width = 0
    else
      border_width = beautiful.border_width
    end

    c.border_width = border_width
  end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- }}}

-- {{{ Mouse bindings

-- Actions with main screen frame
root.buttons(gears.table.join(
  awful.button({}, 3, function() awful.util.mymainmenu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))

-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
-- Destroy all notifications
  awful.key({ modkey, ctrl }, "x", function() naughty.destroy_all_notifications() end,
    { description = "destroy all notifications", group = "awesome" }),
  awful.key({ modkey, ctrl }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, ctrl }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),

  -- Show help
  awful.key({ modkey, shift }, "/", hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }),

  -- Menu
  awful.key({ modkey, }, "w", function() awful.util.mymainmenu:show() end,
    { description = "show main menu", group = "awesome" }),

  -- Show/hide wibox
  awful.key({ modkey }, "b", function()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
        if s.mybottomwibox then
          s.mybottomwibox.visible = not s.mybottomwibox.visible
        end
      end
    end,
    { description = "toggle wibox", group = "awesome" }),

  -- Prompt
  awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
    { description = "run prompt", group = "launcher" }),
  awful.key({ modkey }, "x",
    function()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    { description = "lua execute prompt", group = "awesome" }),


  -- Default client focus
  awful.key({ modkey, shift }, "l",
    function()
      awful.client.focus.byidx(1)
    end,
    { description = "focus next by index", group = "focus" }
  ),
  awful.key({ modkey, shift }, "h",
    function()
      awful.client.focus.byidx(-1)
    end,
    { description = "focus previous by index", group = "focus" }
  ),

  -- By-direction client focus
  awful.key({ modkey }, "j",
    function()
      awful.client.focus.global_bydirection("down")
      if client.focus then client.focus:raise() end
    end,
    { description = "focus down", group = "focus" }),
  awful.key({ modkey }, "k",
    function()
      awful.client.focus.global_bydirection("up")
      if client.focus then client.focus:raise() end
    end,
    { description = "focus up", group = "focus" }),
  awful.key({ modkey }, "h",
    function()
      awful.client.focus.global_bydirection("left")
      if client.focus then client.focus:raise() end
    end,
    { description = "focus left", group = "focus" }),
  awful.key({ modkey }, "l",
    function()
      awful.client.focus.global_bydirection("right")
      if client.focus then client.focus:raise() end
    end,
    { description = "focus right", group = "focus" }),

  -- Switch between clients in one tag like in windows but without preview
  awful.key({ altkey, }, "Tab",
    function()
      switcher.switch(1, altkey, { "Alt_L", "Alt_R" }, "Shift", "Tab")
    end),

  awful.key({ altkey, "Shift" }, "Tab",
    function()
      switcher.switch(-1, altkey, { "Alt_L", "Alt_R" }, "Shift", "Tab")
    end),

  -- Swap clients
  awful.key({ modkey, ctrl }, "l", function() awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, ctrl }, "h", function() awful.client.swap.byidx(-1) end,
    { description = "swap with previous client by index", group = "client" }),

  -- Restore client
  awful.key({ modkey, shift }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, { description = "restore minimized", group = "client" }), -- but actually it is not client


  -- Layout manipulation
  awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
    { description = "next layout", group = "layout" }),
  awful.key({ modkey, shift }, "space", function() awful.layout.inc(-1) end,
    { description = "previous layout", group = "layout" }),


  -- Screen
  awful.key({ modkey }, ",", function() awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey }, ".", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  -- awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
  --   { description = "jump to urgent client", group = "client" }),


  -- Gaps change
  -- awful.key({ modkey, ctrl }, "=", function() lain.util.useless_gaps_resize(1) end,
  --   { description = "increment useless gaps", group = "gaps" }),
  -- awful.key({ modkey, ctrl }, "-", function() lain.util.useless_gaps_resize(-1) end,
  --   { description = "decrement useless gaps", group = "gaps" }),


  -- ALSA volume control
  awful.key({}, "#121",
    function()
      os.execute("pactl set-sink-mute @DEFAULT_SINK@ toggle")
      beautiful.volume.update()
    end
  ),
  awful.key({}, "#122",
    function()
      os.execute("pactl set-sink-volume @DEFAULT_SINK@ -1%")
      beautiful.volume.update()
    end
  ),
  awful.key({}, "#123",
    function()
      os.execute("pactl set-sink-volume @DEFAULT_SINK@ +1%")
      beautiful.volume.update()
    end
  ),
  awful.key({}, "#198",
    function()
      os.execute("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
      beautiful.volume.update()
    end
  ),


  -- Copy primary to clipboard (terminals to gtk)
  awful.key({ modkey }, "c", function() awful.spawn.with_shell("xsel | xsel -i -b") end,
    { description = "copy terminal to gtk", group = "clipboard" }),
  -- Copy clipboard to primary (gtk to terminals)
  awful.key({ modkey }, "v", function() awful.spawn.with_shell("xsel -b | xsel") end,
    { description = "copy gtk to terminal", group = "clipboard" }),


  -- Take a screenshot
  awful.key(
    {}, "Print",
    function() awful.util.spawn_with_shell("import png:- | xclip -selection clipboard -t image/png", false) end,
    { description = "take screenshot", group = "clipboard" }
  ),
  awful.key(
    { "Shift" }, "Print",
    function() awful.util.spawn_with_shell("import -window root png:- | xclip -selection clipboard -t image/png", false) end
    ,
    { description = "take root screenshot", group = "clipboard" }
  ),
  -- greenclip
  awful.key({ modkey }, "p", function()
      awful.util.spawn_with_shell("rofi -modi \"clipboard:greenclip print\" -show clipboard -run-command '{cmd}'", false)
    end,
    { description = "list clipboard", group = "clipboard" }),
  -- clipmenu
  -- awful.key({ modkey }, "p", function()
  --   awful.util.spawn_with_shell("clipmenu", false)
  -- end, { description = "open clipmenu with rofi", group = "clipboard" }),


  -- Launch programs
  awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, }, "z", function() awful.screen.focused().quake:toggle() end,
    { description = "dropdown application", group = "launcher" }),
  awful.key({ modkey }, "q", function() awful.spawn("firefox") end,
    { description = "run browser", group = "launcher" }),
  awful.key({ modkey, shift }, "q", function() awful.spawn("firefox -P alternative") end,
    { description = "run browser", group = "launcher" }),
  -- screen locker
  awful.key({ altkey, ctrl }, "l", function() os.execute(scrlocker) end,
    { description = "lock screen", group = "launcher" }),
  -- rofi
  awful.key({ modkey }, "o",
    function() awful.util.spawn_with_shell("rofi -show combi -combi-modi \"drun,run\" -modi combi", false) end,
    { description = "launch desktop", group = "launcher" }),
  awful.key({ modkey }, "[",
    function() awful.util.spawn_with_shell("rofi -show window -modi \"window,windowcd\"", false) end,
    { description = "show windows", group = "launcher" }),
  -- explorer
  awful.key({ modkey }, "e", function()
      awful.util.spawn_with_shell("pcmanfm", false)
    end,
    { description = "file-manager", group = "launcher" }),
  -- neovide
  awful.key({ modkey }, "u", function()
      awful.spawn("neovide", {})
    end,
    { description = "neovide", group = "launcher" }),

  -- {{{ Tag browsing
  -- awful.key({ modkey, }, "Left", awful.tag.viewprev,
  --   { description = "[modkey] view previous", group = "tag" }),
  -- awful.key({ modkey, }, "Right", awful.tag.viewnext,
  --   { description = "[modkey] view next", group = "tag" }),

  -- Previous tab
  awful.key({ modkey, }, "Tab", awful.tag.history.restore,
    { description = "open previous tag [modkey]", group = "tag" })

-- Non-empty tag browsing
-- awful.key({ altkey }, "Left", function() lain.util.tag_view_nonempty(-1) end,
--   { description = "view previous nonempty", group = "tag" }),
-- awful.key({ altkey }, "Right", function() lain.util.tag_view_nonempty(1) end,
--   { description = "view previous nonempty", group = "tag" })

-- Dynamic tagging
-- awful.key({ modkey, "Shift" }, "n", function() lain.util.add_tag() end,
--   { description = "add new tag", group = "tag" }),
-- awful.key({ modkey, "Shift" }, "r", function() lain.util.rename_tag() end,
--   { description = "rename tag", group = "tag" }),
-- awful.key({ modkey, control }, "Left", function() lain.util.move_tag(-1) end,
--   { description = "move tag to the left", group = "tag" }),
-- awful.key({ modkey, control }, "Right", function() lain.util.move_tag(1) end,
-- { description = "move tag to the right", group = "tag" })
-- awful.key({ modkey, "Shift" }, "d", function() lain.util.delete_tag() end,
--   { description = "delete tag", group = "tag" }),
--
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
for i, v in ipairs(awful.util.tagnames) do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "[modkey] view tag #" .. v, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, shift }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "[modkey] toggle tag #" .. v, group = "tag" }),
    -- Move client to tag.
    awful.key({ modkey, ctrl }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "[modkey] move focused client to tag #" .. v, group = "tag" })

  -- Toggle tag on focused client.
  -- awful.key({ modkey, control, "Shift" }, "#" .. i + 9,
  --   function()
  --     if client.focus then
  --       local tag = client.focus.screen.tags[i]
  --       if tag then
  --         client.focus:toggle_tag(tag)
  --       end
  --     end
  --   end,
  --   { description = "toggle focused client on tag #" .. v, group = "tag" })
  )
end

-- }}}

-- Client (client as first argument)
local clientkeys = gears.table.join(
  awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }),
  awful.key({ modkey, ctrl }, "space", awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }),
  awful.key({ modkey }, "'", function(c) c.sticky = not c.sticky end,
    { description = "toggle sticky", group = "client" }),


  awful.key({ modkey, }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }),

  awful.key({ modkey, }, "n",
    function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end,
    { description = "minimize (down)", group = "client" }),

  -- Size
  awful.key({ modkey, }, "m",
    function(c)
      c.maximized = not c.maximized
      -- if c.maximized then
      --   c.border_width = 0
      -- else
      --   c.border_width = beautiful.border_width
      -- end
      c:raise()
    end,
    { description = "(un)maximize", group = "client" }),
  awful.key({ modkey, "Control" }, "m",
    function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    { description = "(un)maximize vertically", group = "client" }),
  awful.key({ modkey, "Shift" }, "m",
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    { description = "(un)maximize horizontally", group = "client" }),

  -- TODO: resize more precisely
  awful.key({ modkey, shift }, "Right",
    function(c)
      if c.floating then
        c:relative_move(0, 0, s_width() * 0.01, 0)
      else
        awful.tag.incmwfact(0.01)
      end
    end,
    { description = "increase width/tag.incmwfact", group = "client" }),
  awful.key({ modkey, shift }, "Left",
    function(c)
      if c.floating then
        c:relative_move(0, 0, s_width() * -0.01, 0)
      else
        awful.tag.incmwfact(-0.01)
      end
    end,
    { description = "decrease width/tag.incwfact", group = "client" }),
  awful.key({ modkey, shift }, "Up",
    function(c)
      if c.floating then
        c:relative_move(0, 0, 0, s_height() * 0.02)
      else
        awful.client.incwfact(0.02)
      end
    end,
    { description = "increase height/client.incwfact", group = "client" }),
  awful.key({ modkey, shift }, "Down",
    function(c)
      if c.floating then
        c:relative_move(0, 0, 0, s_height() * -0.02)
      else
        awful.client.incwfact(-0.02)
      end
    end,
    { description = "decrease height/client.incwfact", group = "client" }),

  -- Move client floating
  awful.key({ modkey }, "Right",
    function(c)
      c:relative_move(s_width() * 0.01, 0, 0, 0)
    end,
    { description = "move client", group = "client" }),
  awful.key({ modkey }, "Left",
    function(c)
      c:relative_move(s_width() * -0.01, 0, 0, 0)
    end,
    { description = "move client", group = "client" }),
  awful.key({ modkey }, "Up",
    function(c)
      c:relative_move(0, s_height() * -0.02, 0, 0)
    end,
    { description = "move client", group = "client" }),
  awful.key({ modkey }, "Down",
    function(c)
      c:relative_move(0, s_height() * 0.02, 0, 0)
    end,
    { description = "move client", group = "client" }),

  -- Toggle titlebar
  awful.key({ modkey, }, "i", function(c)
    awful.titlebar.toggle(c)
    -- naughty.notify({ text = c:titlebar_top(0).size })
  end, { description = 'toggle title bar', group = 'client' }),

  -- Kill
  awful.key({ modkey, shift }, "c", function(c) c:kill() end,
    { description = "close", group = "client" }),

  -- Screens
  awful.key({ modkey, shift }, "o", lain.util.magnify_client,
    { description = "magnify client", group = "client" }),
  awful.key({ modkey, shift }, "i", function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }),
  -- TODO: caclulate screen index based on current
  awful.key({ modkey, shift }, ",", function(c) c:move_to_screen(c.screen.index - 1) end,
    { description = "move to screen", group = "client" }),
  awful.key({ modkey, shift }, ".", function(c) c:move_to_screen(c.screen.index + 1) end,
    { description = "move to screen", group = "client" })
)
-- }}}

local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)

-- }}}

-- {{{ Rules

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      callback = awful.client.setslave,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false
    }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",   -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer"
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
        "zoom"
      },
      role = {
        "AlarmWindow",   -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  },


  -- Add titlebars to normal clients and dialogs
  {
    rule_any = { type = { "normal", "dialog" }
    },
    properties = { titlebars_enabled = true }
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}

-- }}}

-- {{{ Signals

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- Custom
  if beautiful.titlebar_fun then
    beautiful.titlebar_fun(c)
    return
  end

  -- Default
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal("request::activate", "titlebar", { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c, { size = 16 }):setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
  -- Always hide titlebar
  awful.titlebar.hide(c)
  -- c.floating = c.first_tag.layout == awful.layout.suit.floating
end)

-- Only show titlebar when floating
client.connect_signal("property::floating", function(c)
  -- awful.titlebar.show(c)
  -- c:relative_move(0, 0, 0, -16)
  -- awful.titlebar.hide(c)
  -- c:relative_move(0, 0, 0, 16)
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = vi_focus })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}

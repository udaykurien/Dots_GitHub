---------------------------
--- KEYBINDS / MAIN MAP ---
---------------------------
local main_mod = "SUPER"

return {
    ---------------
    ---- MAIN -----
    ---------------
    main_mod = main_mod,
    
    ---------------
    ---- HYPR -----
    ---------------
    hypr_exit = "SUPER + SHIFT + E",
    
    -------------------
    --- WORKSPACES ----
    -------------------
    ws_prev = "CTRL + " .. main_mod .. " + up",
    ws_next = "CTRL + " .. main_mod .. " + down",
    
    -------------------
    ------ FOCUS ------
    -------------------
    focus_left = main_mod .. " + left",
    focus_right = main_mod .. " + right",
    focus_up = main_mod .. " + up",
    focus_down = main_mod .. " + down",
    
    -------------------
    ------ VOLUME -----
    -------------------
    speaker_raise_volume_large = "XF86AudioRaiseVolume",
    speaker_raise_volume_small = "SHIFT + XF86AudioRaiseVolume",
    speaker_lower_volume_large = "XF86AudioLowerVolume",
    speaker_lower_volume_small = "SHIFT+XF86AudioLowerVolume",
    speaker_toggle_volume_mute = "XF86AudioMute",
    mic_toggle_volume_mute = "XF86AudioMicMute",
    
    -------------------
    ------ SCREEN -----
    -------------------
    screen_raise_brightness_large = "XF86MonBrightnessUp",
    screen_raise_brightness_small = "SHIFT+XF86MonBrightnessUp",
    screen_lower_brightness_large = "XF86MonBrightnessDown",
    screen_lower_brightness_small = "SHIFT+XF86MonBrightnessDown",
    screenshot = "XF86SelectiveScreenshot",

    -------------------
    ------ MEDIA ------
    -------------------
    -- TODO: Add media controls for stop
    media_next = "XF86AudioNext",
    media_pause = "XF86AudioPause",
    media_play = "XF86AudioPlay",
    media_previous = "XF86AudioPrev",

    -------------------
    ---- WINs MGMT ----
    -------------------
    win_close = main_mod .. " + Q",
    win_mv_to_prev_ws = "CTRL + SHIFT + " .. main_mod .. " + up",
    win_mv_to_next_ws = "CTRL + SHIFT + " .. main_mod .. " + down",
    win_mv_left = main_mod .. " + SHIFT + left",
    win_mv_right = main_mod .. " + SHIFT + right",
    win_mv_up = main_mod .. " + SHIFT + up",
    win_mv_down = main_mod .. " + SHIFT + down",
    win_fullscreen = main_mod .. " + SHIFT + F",
    win_maximize = main_mod .. " + F",
    win_split_direction_toggle =  main_mod .. " +J",

    -------------------
    ---- OPEN APPS ----
    -------------------
    terminal_open = main_mod .. " + T",
}

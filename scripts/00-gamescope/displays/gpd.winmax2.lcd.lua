-- colorimetry from edid
local gpd_winmax2_lcd_colorimetry = {
    r = { x = 0.6250, y = 0.3398 },
    g = { x = 0.2802, y = 0.5947 },
    b = { x = 0.1552, y = 0.0703 },
    w = { x = 0.2832, y = 0.2978 }
}

gamescope.config.known_displays.gpd_winmax2_lcd = {
    pretty_name = "GPD Win Max 2",
    dynamic_refresh_rates = {
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
        51, 52, 53, 54, 55, 56, 57, 58, 59, 60
    },
    hdr = {
        supported = false,
        force_enabled = false,
        eotf = gamescope.eotf.gamma22,
        max_content_light_level = 400,
        max_frame_average_luminance = 400,
        min_content_light_level = 0.5
    },
    colorimetry = gpd_winmax2_lcd_colorimetry,
    dynamic_modegen = function(base_mode, refresh)
        debug("Generating mode "..refresh.."Hz for GPD Win Max 2")
        local mode = base_mode

        gamescope.modegen.set_resolution(mode, 2560, 1600)

        -- Horizontal timings: Hfront, Hsync, Hback
        gamescope.modegen.set_h_timings(mode, 200, 32, 160)
        -- Vertical timings: Vfront, Vsync, Vback
        gamescope.modegen.set_v_timings(mode, 10, 3, 6)

        mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        return mode
    end,
    matches = function(display)
        -- There are multiple revisions of the GPD Win Max 2
        -- They all should have the same panel
        -- lcd_types is just in case there are different panels
        local lcd_types = {
            { vendor = "JDI", model = "GPD1001H" },
        }

        for index, value in ipairs(lcd_types) do
            if value.vendor == display.vendor and value.model == display.model then
                debug("[gpd_winmax2_lcd] Matched vendor: "..value.vendor.." model: "..value.model)
                return 5000
            end
        end

        return -1
    end
}
debug("Registered GPD Win Max 2 as a known display")
--debug(inspect(gamescope.config.known_displays.gpd_winmax2_lcd))

// Copyright (c) 2026 PhoronMC 
//Licensed under GNU General Public License Version 3

if (started <= 0)
{
    if (global.savedata_async_id >= 0)
        exit;
    
    started = -1;
    
    if (!trophy_init())
    {
        if (trophy_ts < 0)
            trophy_ts = current_time;
        
        exit;
    }
    
    ossafe_ini_open("config.ini");
    var lang = ini_read_string("General", "lang", "");
    var sb_i = ini_read_real("General", "sb", -1);
    var b0_i = ini_read_real("joypad1", "b0", -1);
    var b1_i = ini_read_real("joypad1", "b1", -1);
    var b2_i = ini_read_real("joypad1", "b2", -1);
    var as_i = ini_read_real("joypad1", "as", -1);
    var jd_i = ini_read_real("joypad1", "jd", -1);
    
    if (string_length(lang) > 0)
        global.language = lang;
    
    if (sb_i >= 0)
        global.screen_border_id = sb_i;
    
    if (b0_i >= 0)
        global.button0 = b0_i;
    
    if (b1_i >= 0)
        global.button1 = b1_i;
    
    if (b2_i >= 0)
        global.button2 = b2_i;
    
    if (as_i >= 0)
        global.analog_sense = as_i;
    
    if (jd_i >= 0)
        global.joy_dir = jd_i;
    
    ossafe_ini_close();
    scr_enable_screen_border(global.osflavor >= 4);
    
    if (global.osflavor >= 4)
    {
        global.analog_sense = 0.15;
        
        if (os_type == os_psvita)
            global.analog_sense = 0.9;
        
        global.joy_dir = 0;
    }
    
    ossafe_ini_open("undertale.ini");
    fskip = ini_read_real("FFFFF", "E", -1);
    ftime = ini_read_real("FFFFF", "F", -1);
    true_end = ini_read_real("EndF", "EndF", -1);
    ossafe_ini_close();
    sksk = 0;
    
    if (ftime == 1)
    {
        sksk = 1;
        room_goto(room_f_start);
    }
    
    if (true_end == 1 && sksk == 0)
    {
        sksk = 1;
        room_goto(room_flowey_regret);
    }
    
    if (fskip >= 1 && sksk == 0)
    {
        global.filechoice = 8;
        scr_load();
        
        if (fskip == 1)
            room_goto(room_flowey_endchoice);
        
        if (fskip == 2)
            room_goto(room_castle_exit);
    }
    else if (sksk == 0)
    {
        room_goto_next();
    }
    
    if (ossafe_file_exists("system_information_962") && !ossafe_file_exists("system_information_963"))
        room_goto(room_nothingness);
    
    started = 1;
    exit;
}

if (!paused)
    time += 1;

if (global.osflavor <= 2)
{
    if (jt == 0)
    {
        if (j_ch != 2)
        {
            if (joystick_exists(1))
                j_ch = 1;
            else if (j_ch == 1)
                j_ch = 0;
        }
    }
    
    if (jt == 4)
    {
        if (j_ch != 1)
        {
            if (joystick_exists(2))
                j_ch = 2;
            else if (j_ch == 2)
                j_ch = 0;
        }
    }
    
    jt += 1;
    
    if (jt >= 8)
        jt = 0;
}

control_update();

if (j_ch > 0)
{
    j_fr_p = j_fr;
    j_fl_p = j_fl;
    j_fu_p = j_fu;
    j_fd_p = j_fd;
    j_fr = 0;
    j_fl = 0;
    j_fu = 0;
    j_fd = 0;
    
    if (global.osflavor >= 4)
    {
        if (gamepad_button_check(j_ch - 1, gp_padu) || gamepad_button_check(j_ch - 1, gp_padd) || gamepad_button_check(j_ch - 1, gp_padl) || gamepad_button_check(j_ch - 1, gp_padr))
        {
            j_fu = gamepad_button_check(j_ch - 1, gp_padu);
            j_fd = gamepad_button_check(j_ch - 1, gp_padd);
            j_fl = gamepad_button_check(j_ch - 1, gp_padl);
            j_fr = gamepad_button_check(j_ch - 1, gp_padr);
        }
        else if (global.joy_dir != 2)
        {
            var j_xpos = gamepad_axis_value(j_ch - 1, gp_axislh);
            var j_ypos = gamepad_axis_value(j_ch - 1, gp_axislv);
            var analog_sense = global.analog_sense;
            
            if (sqrt(sqr(j_xpos) + sqr(j_ypos)) >= analog_sense)
            {
                var angle = darctan2(j_ypos, j_xpos);
                
                if (angle < 0)
                    angle += 360;
                
                if (angle < 67.5 || angle > 292.5)
                    j_fr = 1;
                
                if (angle > 22.5 && angle < 157.5)
                    j_fd = 1;
                
                if (angle > 112.5 && angle < 247.5)
                    j_fl = 1;
                
                if (angle > 202.5 && angle < 337.5)
                    j_fu = 1;
            }
        }
    }
    else
    {
        var j_xpos, j_ypos;
        
        if (global.joy_dir == 0 || global.joy_dir == 1)
        {
            j_xpos = joystick_xpos(j_ch);
            j_ypos = joystick_ypos(j_ch);
        }
        
        j_dir = joystick_direction(j_ch);
        
        if (global.joy_dir == 0 || global.joy_dir == 1)
        {
            if (j_dir == 101)
            {
                if (j_xpos >= global.analog_sense)
                    j_fr = 1;
                
                if (j_xpos <= -global.analog_sense)
                    j_fl = 1;
                
                if (j_ypos >= global.analog_sense)
                    j_fd = 1;
                
                if (j_ypos <= -global.analog_sense)
                    j_fu = 1;
            }
        }
        
        if (j_dir != 101)
        {
            if (j_dir == 100)
                j_fl = 1;
            
            if (j_dir == 98)
                j_fd = 1;
            
            if (j_dir == 102)
                j_fr = 1;
            
            if (j_dir == 104)
                j_fu = 1;
            
            if (j_dir == 99)
            {
                j_fr = 1;
                j_fd = 1;
            }
            
            if (j_dir == 97)
            {
                j_fd = 1;
                j_fl = 1;
            }
            
            if (j_dir == 103)
            {
                j_fu = 1;
                j_fl = 1;
            }
            
            if (j_dir == 105)
            {
                j_fu = 1;
                j_fr = 1;
            }
        }
        
        if (global.joy_dir == 0 || global.joy_dir == 2)
        {
            j_pov = joystick_pov(j_ch);
            
            if (j_pov == 0)
                j_fu = 1;
            
            if (j_pov == 270)
                j_fl = 1;
            
            if (j_pov == 90)
                j_fr = 1;
            
            if (j_pov == 180)
                j_fd = 1;
            
            if (j_pov == 315)
            {
                j_fu = 1;
                j_fl = 1;
            }
            
            if (j_pov == 45)
            {
                j_fu = 1;
                j_fr = 1;
            }
            
            if (j_pov == 225)
            {
                j_fd = 1;
                j_fl = 1;
            }
            
            if (j_pov == 135)
            {
                j_fd = 1;
                j_fr = 1;
            }
        }
    }
    
    if (j_fr != j_fr_p && j_fr == 1)
        keyboard_key_press(vk_right);
    
    if (j_fl != j_fl_p && j_fl == 1)
        keyboard_key_press(vk_left);
    
    if (j_fd != j_fd_p && j_fd == 1)
        keyboard_key_press(vk_down);
    
    if (j_fu != j_fu_p && j_fu == 1)
        keyboard_key_press(vk_up);
    
    if (j_fr != j_fr_p && j_fr == 0)
        keyboard_key_release(vk_right);
    
    if (j_fl != j_fl_p && j_fl == 0)
        keyboard_key_release(vk_left);
    
    if (j_fd != j_fd_p && j_fd == 0)
        keyboard_key_release(vk_down);
    
    if (j_fu != j_fu_p && j_fu == 0)
        keyboard_key_release(vk_up);
}

up = 0;
down = 0;
left = 0;
right = 0;

// TRY INPUT (WASD)

if (keyboard_check(ord("W")))
    try_up = 1;
if (keyboard_check_released(ord("W")))
    try_up = 0;

if (keyboard_check(ord("S")))
    try_down = 1;
if (keyboard_check_released(ord("S")))
    try_down = 0;

if (keyboard_check(ord("D")))
    try_right = 1;
if (keyboard_check_released(ord("D")))
    try_right = 0;

if (keyboard_check(ord("A")))
    try_left = 1;
if (keyboard_check_released(ord("A")))
    try_left = 0;

// ACTIVE INPUT (WASD)

if (global.osflavor == 1)
{
    if (try_up)
        up = keyboard_check_direct(ord("W"));
    if (try_down)
        down = keyboard_check_direct(ord("S"));
    if (try_left)
        left = keyboard_check_direct(ord("A"));
    if (try_right)
        right = keyboard_check_direct(ord("D"));
}
else
{
    if (try_up)
        up = keyboard_check(ord("W"));
    if (try_down)
        down = keyboard_check(ord("S"));
    if (try_left)
        left = keyboard_check(ord("A"));
    if (try_right)
        right = keyboard_check(ord("D"));
}

// RELEASE INPUT (WASD)

if (keyboard_check_released(ord("W")))
    up = 0;
if (keyboard_check_released(ord("S")))
    down = 0;
if (keyboard_check_released(ord("A")))
    left = 0;
if (keyboard_check_released(ord("D")))
    right = 0;

// Rest needs to be the Orginal Undertale Code

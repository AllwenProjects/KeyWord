local function make_keyboard(mod, mod_current_position)
	local keyboard = {}
	keyboard.inline_keyboard = {}
	if mod then --extra options for the mod
	    local list = {
                ['بن/مسدود کردن'] = 'banhammer',
                ['اطلاعات گروه'] ='info',
                ['فلود منیجر'] = 'flood',
                ['تنظیمات مدیا'] = 'media',
                ['تنظیمات خوش آمد گویی'] = 'welcome',
                ['تنظیمات ظاهری'] = 'settings',
                ['دستورات پیشرفته'] = 'extra',
                ['اخطار ها'] = 'warns',
                ['تنظیمات کاراکتر ها'] = 'char',
                ['لینک ها'] = 'links',
                ['زبان ها'] = 'lang'
        }
        local line = {}
        for k,v in pairs(list) do
            --if mod_current_position ~= v:gsub('!', '') then --(to remove the current tab button)
            if next(line) then
                local button = {text = '🎫'..k, callback_data = v}
                --change emoji if it's the current position button
                if mod_current_position == v then button.text = '✅ '..k end
                table.insert(line, button)
                table.insert(keyboard.inline_keyboard, line)
                line = {}
            else
                local button = {text = '🎫'..k, callback_data = v}
                --change emoji if it's the current position button
                if mod_current_position == v:gsub('!', '') then button.text = '✅  '..k end
                table.insert(line, button)
            end
            --end --(to remove the current tab button)
        end
        if next(line) then --if the numer of buttons is odd, then add the last button alone
            table.insert(keyboard.inline_keyboard, line)
        end
    end
    local bottom_bar
    if mod then
  bottom_bar = {{text = '👥 تمام اعضا', callback_data = 'user'}}
 else
     bottom_bar = {{text = '👤 ادمین های گروه', callback_data = 'mod'}}
 end
	table.insert(bottom_bar, {text = '🎲 دیگر', callback_data = '!home2'}) 
	table.insert(keyboard.inline_keyboard, bottom_bar)
	return keyboard
end

local function do_keyboard_private()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = '👥 افزودن من به گروه', url = 'https://telegram.me/'..bot.username..'?startgroup=new'},
    	     },
             {
      {text = '📣 کانال ما', url = 'https://telegram.me/SpamProofChannel'},
             },    	    
             {
    	    	{text = '📊 گروه پشتیبانی', url = 'https://telegram.me/joinchat/ChhotEDUZV-PIwZ5QJFX5g'},
    		{text = '📊 گروه پشتیبانی انگلیسی', url = 'https://telegram.me/joinchat/ChhotEAd7v63g4lTSodj0A'},
	     },
	     {
	     	{text = '📃 آموزش ها', callback_data = '!home'},
	     },
	     {
	        {text = '📕 راهنما', callback_data = 'user'}
        }
    }
    return keyboard
end

local function do_keyboard_startme()
    local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Start me', url = 'https://telegram.me/'..bot.username}
	    }
    }
    return keyboard
end

local action = function(msg, blocks)
    -- save stats
    if blocks[1] == 'start' then
        if msg.chat.type == 'private' then
            db:hincrby('bot:general', 'users', 1)
            local message = lang[msg.ln].help.private:compose(msg.from.first_name:mEscape())
            local keyboard = do_keyboard_private()
            api.sendKeyboard(msg.from.id, message, keyboard, true)
        end
        return
    end
    local keyboard = make_keyboard()
    if blocks[1] == 'help' then
        local res = api.sendKeyboard(msg.from.id, lang[msg.ln].help.initial, keyboard, true)
        if not misc.is_silentmode_on(msg.chat.id) then --send the responde in the group only if the silent mode is off
            if res then
                if msg.chat.type ~= 'private' then
                    api.sendMessage(msg.chat.id, lang[msg.ln].help.group_success, true)
                end
            else
                api.sendKeyboard(msg.chat.id, lang[msg.ln].help.group_not_success, do_keyboard_startme(), true)
            end
        end
    end
if msg.cb then
        local query = blocks[1]
        local msg_id = msg.message_id
        local text
if query == 'back' then
            local keyboard = do_keyboard_private()
		    api.editMessageText(msg.chat.id, msg.message_id, lang[msg.ln].help.private, keyboard, true)
end
        local with_mods_lines = true
        if query == 'user' then
            text = lang[msg.ln].help.all
            with_mods_lines = false
        elseif query == 'mod' then
            text = lang[msg.ln].help.kb_header
        end
        if query == 'info' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'banhammer' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'flood' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'media' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'welcome' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'extra' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'warns' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'char' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'links' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'lang' then
        	text = lang[msg.ln].help.mods[query]
        elseif query == 'settings' then
        	text = lang[msg.ln].help.mods[query]
        end
        keyboard = make_keyboard(with_mods_lines, query)
        local res, code = api.editMessageText(msg.chat.id, msg.message_id, text, keyboard, true)
        if not res and code and code == 111 then
            api.answerCallbackQuery(msg.cb_id, '❗️ نمی توانید دوباره وارد شوید')
        elseif query ~= 'user' and query ~= 'mod' and query ~= 'info_button' then
            api.answerCallbackQuery(msg.cb_id, '💡 '..lang[msg.ln].help.mods[query]:sub(1, string.find(lang[msg.ln].help.mods[query], '\n')):mEscape_hard())
        end
    end
end

return {
	action = action,
	admin_not_needed = true,
	triggers = {
	    config.cmd..'(start)$',
	    config.cmd..'(help)$',
	    '^###cb:(user)$',
	    '^###cb:!(back)$',	    
	    '^###cb:(mod)$',
	    '^###cb:(info)$',
	    '^###cb:(banhammer)$',
	    '^###cb:(flood)$',
	    '^###cb:(media)$',
	    '^###cb:(links)$',
	    '^###cb:(lang)$',
	    '^###cb:(welcome)$',
	    '^###cb:(extra)$',
	    '^###cb:(warns)$',
	    '^###cb:(char)$',
	    '^###cb:(settings)$',
    }
}

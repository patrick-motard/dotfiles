sound_file_path = '/Users/kevzheng/Library/Sounds/alarm.m4a'

function notify(title, info, image, sound)
	local notif = hs.notify.new({title=title, informativeText=info})
    
    if image then
        notif:setIdImage(image)
    end

	if sound then
		alarm_sound = hs.sound.getByFile(sound_file_path)
		alarm_sound:play()
	end 

	notif:send()
end
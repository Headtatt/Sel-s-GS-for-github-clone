--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--
--	Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
--
--	Editing this file will cause you to be unable to use Github Desktop to update!
--
--	Any changes you wish to make in this file you should be able to make by overloading. That is Re-Defining the same variables or functions in another file, by copying and
--	pasting them to a file that is loaded after the original file, all of my library files, and then job files are loaded first.
--	The last files to load are the ones unique to you. User-Globals, Charactername-Globals, Charactername_Job_Gear, in that order, so these changes will take precedence.
--
--	You may wish to "hook" into existing functions, to add functionality without losing access to updates or fixes I make, for example, instead of copying and editing
--	status_change(), you can instead use the function user_status_change() in the same manner, which is called by status_change() if it exists, most of the important 
--  gearswap functions work like this in my files, and if it's unique to a specific job, user_job_status_change() would be appropriate instead.
--
--  Variables and tables can be easily redefined just by defining them in one of the later loaded files: autofood = 'Miso Ramen' for example.
--  States can be redefined as well: state.HybridMode:options('Normal','PDT') though most of these are already redefined in the gear files for editing there.
--	Commands can be added easily with: user_self_command(commandArgs, eventArgs) or user_job_self_command(commandArgs, eventArgs)
--
--	If you're not sure where is appropriate to copy and paste variables, tables and functions to make changes or add them:
--		User-Globals.lua - 			This file loads with all characters, all jobs, so it's ideal for settings and rules you want to be the same no matter what.
--		Charactername-Globals.lua -	This file loads with one character, all jobs, so it's ideal for gear settings that are usable on all jobs, but unique to this character.
--		Charactername_Job_Gear.lua-	This file loads only on one character, one job, so it's ideal for things that are specific only to that job and character.
--
--
--	If you still need help, feel free to contact me on discord or ask in my chat for help: https://discord.gg/ug6xtvQ
--  !Please do NOT message me in game about anything third party related, though you're welcome to message me there and ask me to talk on another medium.
--
--  Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    ExtraSongsMode may take one of three values: None, Dummy, FullLength

    You can set these via the standard 'set' and 'cycle' self-commands.  EG:
    gs c cycle ExtraSongsMode
    gs c set ExtraSongsMode Dummy

    The Dummy state will equip the bonus song instrument and ensure non-duration gear is equipped.
    The FullLength state will simply equip the bonus song instrument on top of standard gear.


    Simple macro to cast a dummy Daurdabla song:
    /console gs c set ExtraSongsMode Dummy
    /ma "Mage's Ballad" <me>

    To use a Terpander rather than Daurdabla, set the info.ExtraSongInstrument variable to
    'Terpander', and info.ExtraSongs to 1.
--]]

-- Initialization function for this job file.
function get_sets()
    -- Load and initialize the include file.
    include('Sel-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    state.ExtraSongsMode = M{['description']='Extra Songs','None','Dummy','DummyLock','FullLength','FullLengthLock'}
	-- Whether to use Carn (or song daggers in general) under a certain threshhold even when weapons are locked.
	state.CarnMode = M{'Always','300','1000','Never'}

	state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false
    state.Buff['Pianissimo'] = buffactive['Pianissimo'] or false
	state.Buff['Nightingale'] = buffactive['Nightingale'] or false
	state.RecoverMode = M('35%', '60%', 'Always', 'Never')

	autows = "Savage Blade"
	autofood = 'Pear Crepe'
	
	state.AutoSongMode = M(false, 'Auto Song Mode')

	update_melee_groups()
	init_job_states({"Capacity","AutoRuneMode","AutoTrustMode","AutoNukeMode","AutoWSMode","AutoShadowMode","AutoFoodMode","AutoStunMode","AutoDefenseMode","AutoSongMode",},{"AutoBuffMode","AutoSambaMode","Weapons","OffenseMode","WeaponskillMode","IdleMode","Passive","RuneElement","ExtraSongsMode","CastingMode","CarnMode","TreasureMode",})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.

function job_filtered_action(spell, eventArgs)
	if spell.type == 'WeaponSkill' then
		local available_ws = S(windower.ffxi.get_abilities().weapon_skills)
		-- WS 112 is Double Thrust, meaning a Spear is equipped.
		if available_ws:contains(32) then
            if spell.english == "Rudra's Storm" then
				windower.chat.input('/ws "Savage Blade" '..spell.target.raw)
                cancel_spell()
				eventArgs.cancel = true
            end
        end
	end
end

function job_pretarget(spell, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.targets.Enemy then
		if state.Buff['Pianissimo'] and spell.target.raw == '<t>' and (player.target.type == 'NONE' or spell.target.type == 'MONSTER') then
			eventArgs.cancel = true
			windower.chat.input('/ma "'..spell.name..'" <stpt>')
		elseif spell.target.raw == '<t>' and (player.target.type == 'NONE' or player.target.type == "MONSTER") and not state.Buff['Pianissimo'] then
			change_target('<me>')
			return
		end
    end
end

function job_precast(spell, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		if spell.english:contains('Honor March') then
			equip({range="Marsyas"})
		end
		if spell.english:contains('Aria of Passion') then
			equip({range="Loughnashade"})
		end
		if not sets.precast.FC[spell.english] and (spell.type == 'BardSong' and spell.targets.Enemy) then
			classes.CustomClass = 'SongDebuff'
		end
	end
end

function job_filter_precast(spell, spellMap, eventArgs)
    if spell.type == 'BardSong' and not spell.targets.Enemy then
		local spell_recasts = windower.ffxi.get_spell_recasts()
		
        -- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC')) and spell.target.in_party and not state.Buff['Pianissimo'] then
            if spell_recasts[spell.recast_id] < 1.5 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.1; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
			if generalClass and sets.midcast[generalClass] then
				if sets.midcast[generalClass][state.CastingMode.value] then
					equip(sets.midcast[generalClass][state.CastingMode.value])
				else
					equip(sets.midcast[generalClass])
				end
            end
			if state.CarnMode.value ~= 'Never' and (state.CarnMode.value == 'Always' or tonumber(state.CarnMode.value) > player.tp) then
				if sets.midcast[generalClass].main and sets.midcast[generalClass].main ~= player.equipment.main then
					enable('main')
					equip({main=sets.midcast[generalClass].main})
				end
				if sets.midcast[generalClass].sub and sets.midcast[generalClass].sub ~= player.equipment.sub then
					enable('sub')
					equip({sub=sets.midcast[generalClass].sub})
				end
			end
        end
    end
end

function job_post_precast(spell, spellMap, eventArgs)
	if spell.type == 'BardSong' then

		local generalClass = get_song_class(spell)
	
		if state.Buff['Nightingale'] then
		
			-- Replicate midcast in precast for nightingale including layering.
			if generalClass and sets.midcast[generalClass] then
				if sets.midcast[generalClass][state.CastingMode.value] then
					equip(sets.midcast[generalClass][state.CastingMode.value])
				else 
					equip(sets.midcast[generalClass])
				end
            end

			if sets.midcast[spell.english] then
				if sets.midcast[spell.english][state.CastingMode.value] then
					equip(sets.midcast[spell.english][state.CastingMode.value])
				else
					equip(sets.midcast[spell.english])
				end
			elseif sets.midcast[get_spell_map(spell, default_spell_map)] then
				if sets.midcast[get_spell_map(spell, default_spell_map)][state.CastingMode.Value]
					then equip(sets.midcast[get_spell_map(spell, default_spell_map)][state.CastingMode.Value])
				else
					equip(sets.midcast[get_spell_map(spell, default_spell_map)])
				end
			end
			
			if not spell.targets.Enemy and state.ExtraSongsMode.value:contains('FullLength') then
				equip(sets.midcast.Daurdabla)
			end
		
		end

		if state.CarnMode.value ~= 'Never' and (state.CarnMode.value == 'Always' or tonumber(state.CarnMode.value) > player.tp) then
			if sets.precast.FC.BardSong.main and sets.precast.FC.BardSong.main ~= player.equipment.main then
				enable('main')
				equip({main=sets.precast.FC.BardSong.main})
			end
			if sets.precast.FC.BardSong.sub and sets.precast.FC.BardSong.sub ~= player.equipment.sub then
				enable('sub')
				equip({sub=sets.precast.FC.BardSong.sub})
			end
		end

	elseif spell.type == 'WeaponSkill' then
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
					equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
				elseif sets.MaxTP then
					equip(sets.MaxTP[spell.english] or sets.MaxTP)
				else
				end
			end
		end
	end
end

function job_post_midcast(spell, spellMap, eventArgs)
    if spell.type == 'BardSong' then
		if spell.targets.Enemy then
			if sets.midcast[spell.english] then
				if sets.midcast[spell.english][state.CastingMode.value] then
					equip(sets.midcast[spell.english][state.CastingMode.value])
				else
					equip(sets.midcast[spell.english])
				end
			elseif sets.midcast[spellMap] then
				if sets.midcast[spellMap][state.CastingMode.value] then
					equip(sets.midcast[spellMap][state.CastingMode.value])
				else
					equip(sets.midcast[spellMap])
				end
			end
			
			if can_dual_wield and sets.midcast.SongDebuff.DW then
				equip(sets.midcast.SongDebuff.DW)
			end
		else
			if can_dual_wield and sets.midcast.SongEffect.DW then
				equip(sets.midcast.SongEffect.DW)
			end
		end
		
		if state.ExtraSongsMode.value:contains('FullLength') then
            equip(sets.midcast.Daurdabla)
        end

        if not state.ExtraSongsMode.value:contains('Lock') then
			state.ExtraSongsMode:reset()
		end

		if state.DisplayMode.value then update_job_states()	end

    elseif spell.skill == 'Elemental Magic' and default_spell_map ~= 'ElementalEnfeeble' then
        if state.MagicBurstMode.value ~= 'Off' then equip(sets.MagicBurst) end
		if spell.element == world.weather_element or spell.element == world.day_element then
			if state.CastingMode.value == 'Fodder' then
				if spell.element == world.day_element then
					if item_available('Zodiac Ring') then
						sets.ZodiacRing = {ring2="Zodiac Ring"}
						equip(sets.ZodiacRing)
					end
				end
			end
		end

		if spell.element == 'Wind' and sets.WindNuke then
			equip(sets.WindNuke)
		elseif spell.element == 'Ice' and sets.IceNuke then
			equip(sets.IceNuke)
		end

		if state.RecoverMode.value ~= 'Never' and (state.RecoverMode.value == 'Always' or tonumber(state.RecoverMode.value:sub(1, -2)) > player.mpp) then
			equip(sets.RecoverMP)
		end
    end
end

-- Set eventArgs.handled to true if we don't want automatic gear equipping to be done.
function job_aftercast(spell, spellMap, eventArgs)
	
	if spell.type == 'BardSong' and not spell.interrupted then
		if state.CarnMode.value ~= 'Never' then
			local generalClass = get_song_class(spell)
			if sets.midcast[generalClass].main and sets.weapons[state.Weapons.value] then
				if sets.weapons[state.Weapons.value].main then
					equip({main=sets.weapons[state.Weapons.value].main})
					disable('main')
				end
				if sets.weapons[state.Weapons.value].sub then
					equip({sub=sets.weapons[state.Weapons.value].sub})
					disable('sub')
				end
			end
		end

	elseif spell.skill == 'Elemental Magic' and state.MagicBurstMode.value == 'Single' then
		state.MagicBurstMode:reset()
		if state.DisplayMode.value then update_job_states()	end
    end
end

function job_buff_change(buff, gain)
	update_melee_groups()
end

function job_get_spell_map(spell, default_spell_map)

	if  default_spell_map == 'Cure' or default_spell_map == 'Curaga'  then
		if world.weather_element == 'Light' then
                return 'LightWeatherCure'
		elseif world.day_element == 'Light' then
                return 'LightDayCure'
        end

	elseif spell.skill == "Enfeebling Magic" then
		if spell.english:startswith('Dia') then
			return "Dia"
		elseif spell.type == "WhiteMagic" or spell.english:startswith('Frazzle') or spell.english:startswith('Distract') then
			return 'MndEnfeebles'
		else
			return 'IntEnfeebles'
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_zone_change(new_id,old_id)
	state.AutoSongMode:reset()
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	update_melee_groups()
end


-- Modify the default idle set after it was constructed.
function job_customize_idle_set(idleSet)
    if buffactive['Sublimation: Activated'] then
        if (state.IdleMode.value == 'Normal' or state.IdleMode.value:contains('Sphere')) and sets.buff.Sublimation then
            idleSet = set_combine(idleSet, sets.buff.Sublimation)
        elseif state.IdleMode.value:contains('DT') and sets.buff.DTSublimation then
            idleSet = set_combine(idleSet, sets.buff.DTSublimation)
        end
    end

    if state.IdleMode.value == 'Normal' or state.IdleMode.value:contains('Sphere') then
		if player.mpp < 51 then
			if sets.latent_refresh then
				idleSet = set_combine(idleSet, sets.latent_refresh)
			end
			
			if (state.Weapons.value == 'None' or state.UnlockWeapons.value) and idleSet.main then
				local main_table = get_item_table(idleSet.main)

				if  main_table and main_table.skill == 12 and sets.latent_refresh_grip then
					idleSet = set_combine(idleSet, sets.latent_refresh_grip)
				end
				
				if player.tp > 10 and sets.TPEat then
					idleSet = set_combine(idleSet, sets.TPEat)
				end
			end
		end
   end

    return idleSet
end


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if spell.targets.Enemy then
		return 'SongDebuff'
    elseif state.ExtraSongsMode.value:contains('Dummy') then
        return 'DaurdablaDummy'
    else
        return 'SongEffect'
    end
end

-- Examine equipment to determine what our current TP weapon is.
function update_melee_groups()
	if player.equipment.main then
		classes.CustomMeleeGroups:clear()

		if player.equipment.main == "Carnwenhan" and state.Buff['Aftermath: Lv.3'] then
				classes.CustomMeleeGroups:append('AM')
		end
	end
end

    -- Allow jobs to override this code
function job_self_command(commandArgs, eventArgs)

end

function job_tick()
	if check_song() then return true end
	if check_buff() then return true end
	if check_buffup() then return true end
	return false
end

function check_song()
	if state.AutoSongMode.value then
		if not buffactive.march then
			windower.chat.input('/ma "Honor March" <me>')
			tickdelay = os.clock() + 2
			return true
		elseif not buffactive.minuet then
			windower.chat.input('/ma "Valor Minuet V" <me>')
			tickdelay = os.clock() + 2
			return true
		elseif not buffactive.madrigal then
			windower.send_command('gs c set ExtraSongsMode FullLength;input /ma "Blade Madrigal" <me>')
			tickdelay = os.clock() + 2
			return true
		else
			return false
		end
	else
		return false
	end
end

function check_buff()
	if state.AutoBuffMode.value ~= 'Off' and not data.areas.cities:contains(world.area) then
		local spell_recasts = windower.ffxi.get_spell_recasts()
		for i in pairs(buff_spell_lists[state.AutoBuffMode.Value]) do
			if not buffactive[buff_spell_lists[state.AutoBuffMode.Value][i].Buff] and (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Always' or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Combat' and (player.in_combat or being_attacked)) or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Engaged' and player.status == 'Engaged') or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'Idle' and player.status == 'Idle') or (buff_spell_lists[state.AutoBuffMode.Value][i].When == 'OutOfCombat' and not (player.in_combat or being_attacked))) and spell_recasts[buff_spell_lists[state.AutoBuffMode.Value][i].SpellID] < spell_latency and silent_can_use(buff_spell_lists[state.AutoBuffMode.Value][i].SpellID) then
				windower.chat.input('/ma "'..buff_spell_lists[state.AutoBuffMode.Value][i].Name..'" <me>')
				tickdelay = os.clock() + 2
				return true
			end
		end
	else
		return false
	end
end

function check_buffup()
	if buffup ~= '' then
		local needsbuff = false
		for i in pairs(buff_spell_lists[buffup]) do
			if not buffactive[buff_spell_lists[buffup][i].Buff] and silent_can_use(buff_spell_lists[buffup][i].SpellID) then
				needsbuff = true
				break
			end
		end
	
		if not needsbuff then
			add_to_chat(217, 'All '..buffup..' buffs are up!')
			buffup = ''
			return false
		end
		
		local spell_recasts = windower.ffxi.get_spell_recasts()
		
		for i in pairs(buff_spell_lists[buffup]) do
			if not buffactive[buff_spell_lists[buffup][i].Buff] and silent_can_use(buff_spell_lists[buffup][i].SpellID) and spell_recasts[buff_spell_lists[buffup][i].SpellID] < spell_latency then
				windower.chat.input('/ma "'..buff_spell_lists[buffup][i].Name..'" <me>')
				tickdelay = os.clock() + 2
				return true
			end
		end
		
		return false
	else
		return false
	end
end

buff_spell_lists = {
	Auto = {--Options for When are: Always, Engaged, Idle, OutOfCombat, Combat
		{Name='Refresh',			Buff='Refresh',			SpellID=109,	When='Idle'},
		{Name='Phalanx',			Buff='Phalanx',			SpellID=106,	When='Idle'},
		{Name='Stoneskin',			Buff='Stoneskin',		SpellID=54,		When='Idle'},
		{Name='Blink',				Buff='Blink',			SpellID=53,		When='Idle'},
	},
	Default = {
		{Name='Refresh',			Buff='Refresh',			SpellID=109,	Reapply=false},
		{Name='Phalanx',			Buff='Phalanx',			SpellID=106,	Reapply=false},
		{Name='Stoneskin',			Buff='Stoneskin',		SpellID=54,		Reapply=false},
		{Name='Blink',				Buff='Blink',			SpellID=53,		Reapply=false},
	},
}

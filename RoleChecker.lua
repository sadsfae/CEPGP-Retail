local CEPGP_SendAddonMsg, CEPGP_role_check_popup, CEPGP_debugMsg, CEPGP_getRealtimeRoster, ROLE_CHECK_COMMAND_SEND_ROLE, CEPGP_print, ROLE_CHECK_COMMAND_BEGIN, ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD = CEPGP_SendAddonMsg, CEPGP_role_check_popup, CEPGP_debugMsg, CEPGP_getRealtimeRoster, ROLE_CHECK_COMMAND_SEND_ROLE, CEPGP_print, ROLE_CHECK_COMMAND_BEGIN, ROLE_TANK, ROLE_HEAL, ROLE_MDD, ROLE_RDD
local UnitClass, ShowUIPanel, HideUIPanel = UnitClass, ShowUIPanel, HideUIPanel
local pairs = pairs

local CHANNEL_RAID = 'RAID'
local CHANNEL_WHISPER = 'WHISPER'

local ROLE_NAMES = {
    [ROLE_TANK] = 'Танк',
    [ROLE_HEAL] = 'Хил',
    [ROLE_MDD] = 'Мили ДД',
    [ROLE_RDD] = 'Рейндж ДД',
}

local function sendRoleToRaid(role)
    local command = ROLE_CHECK_COMMAND_SEND_ROLE .. ';' .. role;
    CEPGP_SendAddonMsg(command, CHANNEL_RAID);
end


function CEPGP_ShowRoleCheckWindow(allowedRoles)
    CEPGP_debugMsg('Running show role check window');
    for i = 1, 4 do
        local role = allowedRoles[i];
        if role == nil then
		    _G["CEPGP_check_role_button_" .. i]:Hide();
            CEPGP_debugMsg('Role is nil');
        else
            CEPGP_debugMsg('Role is ' .. role);
            local text = ROLE_NAMES[role];
		    _G["CEPGP_check_role_button_" .. i]:SetText(text);
            _G["CEPGP_check_role_button_" .. i]:SetScript(
                'OnClick',
                function()
                    sendRoleToRaid(role);
                    HideUIPanel(CEPGP_role_check_popup);
                end
            );
        end
    end
    ShowUIPanel(CEPGP_role_check_popup);
end


function CEPGP_RoleCheckEventHandler()
    CEPGP_debugMsg('Running role check event handler');
    local _, class  = UnitClass("player");
    CEPGP_debugMsg('Class is ' .. class);
    if class == 'ROGUE' then
        sendRoleToRaid(ROLE_MDD);
        CEPGP_print('Вам была назначена роль МДД');
    elseif class == 'WARLOCK' or class == 'MAGE' then
        sendRoleToRaid(ROLE_RDD);
        CEPGP_print('Вам была назначена роль РДД');
    elseif class == 'WARRIOR' then
        CEPGP_ShowRoleCheckWindow({ROLE_MDD, ROLE_TANK});
    elseif class == 'HUNTER' then
        CEPGP_ShowRoleCheckWindow({ROLE_MDD, ROLE_RDD});
    elseif class == 'PALADIN' then
        CEPGP_ShowRoleCheckWindow({ROLE_MDD, ROLE_TANK, ROLE_HEAL});
    elseif class == 'PRIEST' then
        CEPGP_ShowRoleCheckWindow({ROLE_RDD, ROLE_HEAL});
    elseif class == 'DRUID' then
        CEPGP_ShowRoleCheckWindow({ROLE_MDD, ROLE_RDD, ROLE_TANK, ROLE_HEAL});
    end
end


function CEPGP_RoleSetEventHandler(player, role)
    CEPGP_debugMsg('Setting players ' .. player .. ' role to ' .. role);
    CEPGP_RaidRoles[player] = role;
end


function CEPGP_StartRaidRoleCheck()
    CEPGP_debugMsg('Started role check');
	for name, _ in pairs(CEPGP_getRealtimeRoster()) do
        CEPGP_debugMsg('Checking role for ' .. name);
        if CEPGP_RaidRoles[name] == nil then
            CEPGP_debugMsg('Sending msg to him');
            CEPGP_SendAddonMsg(ROLE_CHECK_COMMAND_BEGIN, CHANNEL_WHISPER, name);
        else
            CEPGP_debugMsg('Ooops, he is in the list');
		end
	end
    CEPGP_debugMsg('End of role check');
end


function CEPGP_getPlayerRole(name)
    if name == nil then
        return 'Unknown';
    end

    CEPGP_debugMsg('Getting player role for ' .. name);
    local role = CEPGP_RaidRoles[name];
    if role == nil then
        return 'Unknown';
    end
    return ROLE_NAMES[role];
end

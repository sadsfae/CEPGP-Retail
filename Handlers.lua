local L = CEPGP_Locale:GetLocale("CEPGP")

function CEPGP_handleComms(event, arg1, arg2)
	--arg1 = message; arg2 = sender
	if event == "CHAT_MSG_WHISPER" and string.lower(arg1) == string.lower(CEPGP_keyword) and CEPGP_distributing then
		local duplicate = false;
		for i = 1, table.getn(CEPGP_responses) do
			if CEPGP_responses[i] == arg2 then
				duplicate = true;
				if CEPGP_debugMode then
					CEPGP_print("Duplicate entry. " .. arg2 .. " not registered (" .. CEPGP_keyword .. ")");
				end
			end
		end
		if not duplicate then
			if CEPGP_debugMode then
				CEPGP_print(arg2 .. " registered (" .. CEPGP_keyword .. ")");
			end
			local _, _, _, _, _, _, _, _, slot = GetItemInfo(CEPGP_DistID);
			if not slot and CEPGP_itemExists(CEPGP_DistID) then
				local item = Item:CreateFromItemID(CEPGP_DistID);
				item:ContinueOnItemLoad(function()
					local _, _, _, _, _, _, _, _, slot = GetItemInfo(CEPGP_DistID)
					local EP, GP = nil;
					local inGuild = false;
					if CEPGP_tContains(CEPGP_roster, arg2, true) then
						EP, GP = CEPGP_getEPGP(CEPGP_roster[arg2][5]);
						if CEPGP_minEP[1] and CEPGP_minEP[2] > EP then
							CEPGP_print(arg2 .. " is interested in this item but doesn't have enough EP.");
							return;
						end
						class = CEPGP_roster[arg2][2];
						inGuild = true;
					end
					CEPGP_SendAddonMsg(arg2..";distslot;"..CEPGP_distSlot, "RAID");
					if CEPGP_distributing then
						if inGuild and not CEPGP_suppress_announcements then
							CEPGP_sendChatMessage(arg2 .. " (" .. class .. ") needs. (" .. math.floor((EP/GP)*100)/100 .. " PR)", CEPGP_lootChannel);
							
						elseif not CEPGP_suppress_announcements then
							local total = GetNumGroupMembers();
							for i = 1, total do
								if arg2 == GetRaidRosterInfo(i) then
									_, _, _, _, class = GetRaidRosterInfo(i);
								end
							end
								CEPGP_sendChatMessage(arg2 .. " (" .. class .. ") needs. (Non-guild member)", CEPGP_lootChannel);
						end
						if CEPGP_isML() == 0 then --If you are the master looter
							CEPGP_SendAddonMsg("!need;"..arg2..";"..CEPGP_DistID, "RAID"); --!need;playername;itemID (of the item being distributed) is sent for sharing with raid assist
							CEPGP_itemsTable[arg2] = {};
						end
					end
					CEPGP_UpdateLootScrollBar();
				end);
			else
				--	Sends an addon message to the person who whispered !need to me
				--	See Communications.lua:2 to continue this chain
				local EP, GP = nil;
				local inGuild = false;
				if CEPGP_tContains(CEPGP_roster, arg2, true) then
					EP, GP = CEPGP_getEPGP(CEPGP_roster[arg2][5]);
					if CEPGP_minEP[1] and CEPGP_minEP[2] > EP then
						CEPGP_print(arg2 .. " is interested in this item but doesn't have enough EP.");
						return;
					end
					class = CEPGP_roster[arg2][2];
					inGuild = true;
				end
				CEPGP_SendAddonMsg(arg2..";distslot;"..CEPGP_distSlot, "RAID");
				if CEPGP_distributing then
					if inGuild and not CEPGP_suppress_announcements then
						CEPGP_sendChatMessage(arg2 .. " (" .. class .. ") needs. (" .. math.floor((EP/GP)*100)/100 .. " PR)", CEPGP_lootChannel);
					elseif not CEPGP_suppress_announcements then
						local total = GetNumGroupMembers();
						for i = 1, total do
							if arg2 == GetRaidRosterInfo(i) then
								_, _, _, _, class = GetRaidRosterInfo(i);
							end
						end
						CEPGP_sendChatMessage(arg2 .. " (" .. class .. ") needs. (Non-guild member)", CEPGP_lootChannel);
					end
					if CEPGP_isML() == 0 then --If you are the master looter
						CEPGP_SendAddonMsg("!need;"..arg2..";"..CEPGP_DistID, "RAID"); --!need;playername;itemID (of the item being distributed) is sent for sharing with raid assist
						CEPGP_itemsTable[arg2] = {};
					end
				end
				CEPGP_UpdateLootScrollBar();
			end
		end
	elseif event == "CHAT_MSG_WHISPER" and string.lower(arg1) == "!info" then
		if CEPGP_getGuildInfo(arg2) ~= nil then
			local EP, GP = CEPGP_getEPGP(CEPGP_roster[arg2][5]);
			if not CEPGP_vInfo[arg2] then
				SendChatMessage("EPGP Standings - EP: " .. EP .. " / GP: " .. GP .. " / PR: " .. math.floor((EP/GP)*100)/100, "WHISPER", CEPGP_LANGUAGE, arg2);
			else
				CEPGP_SendAddonMsg("!info;" .. arg2 .. ";EPGP Standings - EP: " .. EP .. " / GP: " .. GP .. " / PR: " .. math.floor((EP/GP)*100)/100, "GUILD");
			end
		end
	elseif event == "CHAT_MSG_WHISPER" and (string.lower(arg1) == "!infoguild" or string.lower(arg1) == "!inforaid" or string.lower(arg1) == "!infoclass") then
		if CEPGP_getGuildInfo(arg2) ~= nil then
			sRoster = {};
			CEPGP_updateGuild();
			local gRoster = {};
			local rRoster = {};
			local name, _, class, oNote, EP, GP;
			for i = 1, GetNumGuildMembers() do
				gRoster[i] = {};
				name , _, _, _, class, _, _, oNote = GetGuildRosterInfo(i);
				EP, GP = CEPGP_getEPGP(oNote);
				if string.find(name, "-") then
					name = string.sub(name, 0, string.find(name, "-")-1);
				end
				gRoster[i] = {
					[1] = name,
					[2] = EP,
					[3] = GP,
					[4] = math.floor((EP/GP)*100)/100,
					[5] = class
				};
			end
			if string.lower(arg1) == "!infoguild" then
				if CEPGP_critReverse then
					gRoster = CEPGP_tSort(gRoster, 4);
					for i = 1, CEPGP_ntgetn(gRoster) do
						if gRoster[i][1] == arg2 then
							if not CEPGP_vInfo[arg2] then
								SendChatMessage("EP: " .. gRoster[i][2] .. " / GP: " .. gRoster[i][3] .. " / PR: " .. gRoster[i][4] .. " / PR rank in guild: #" .. i, "WHISPER", CEPGP_LANGUAGE, arg2);
							else
								CEPGP_SendAddonMsg("!info;" .. arg2 .. ";EP: " .. gRoster[i][2] .. " / GP: " .. gRoster[i][3] .. " / PR: " .. gRoster[i][4] .. " / PR rank in guild: #" .. i, "GUILD");
							end
						end
					end
				else
					CEPGP_critReverse = true;
					gRoster = CEPGP_tSort(gRoster, 4);
					for i = 1, table.getn(gRoster) do
						if gRoster[i][1] == arg2 then
							if not CEPGP_vInfo[arg2] then
								SendChatMessage("EP: " .. gRoster[i][2] .. " / GP: " .. gRoster[i][3] .. " / PR: " .. gRoster[i][4] .. " / PR rank in guild: #" .. i, "WHISPER", CEPGP_LANGUAGE, arg2);
							else
								CEPGP_SendAddonMsg("!info;" .. arg2 .. ";EP: " .. gRoster[i][2] .. " / GP: " .. gRoster[i][3] .. " / PR: " .. gRoster[i][4] .. " / PR rank in guild: #" .. i, "GUILD");
							end
						end
					end
					CEPGP_critReverse = false;
				end
			else
				local count = 0;
				local compClass; -- Comparative Class
				if string.lower(arg1) == "!infoclass" then
					local name;
					count = 1;
					for i = 1, GetNumGroupMembers() do
						if GetRaidRosterInfo(i) == arg2 then
							name = GetRaidRosterInfo(i);
							compClass = UnitClass("raid"..i);
							break;
						end
					end
					EP, GP = CEPGP_getEPGP(CEPGP_roster[name][5]);
					class = CEPGP_roster[name][2];
					rRoster[count] = {
						[1] = arg2,
						[2] = EP,
						[3] = GP,
						[4] = math.floor((EP/GP))*100/100,
						[5] = compClass
					};
					for i = 1, GetNumGroupMembers() do
						name = GetRaidRosterInfo(i);
						if string.find(name, "-") then
							name = string.sub(name, 0, string.find(name, "-")-1);
						end
						if not CEPGP_roster[name] then
							EP, GP = 0, BASEGP;
							class = UnitClass("raid"..i);
						else
							EP, GP = CEPGP_getEPGP(CEPGP_roster[name][5]);
							class = CEPGP_roster[name][2];
						end
						if class == compClass and name ~= arg2 then
							count = count + 1;
							rRoster[count] = {
								[1] = name,
								[2] = EP,
								[3] = GP,
								[4] = math.floor((EP/GP)*100)/100,
								[5] = class
							};
						end
					end
				else --Raid
					for i = 1, GetNumGroupMembers() do
						name = GetRaidRosterInfo(i);
						if string.find(name, "-") then
							name = string.sub(name, 0, string.find(name, "-")-1);
						end
						if not CEPGP_roster[name] then
							EP, GP = 0, BASEGP;
							class = UnitClass("raid"..i);
						else
							EP, GP = CEPGP_getEPGP(CEPGP_roster[name][5]);
							class = CEPGP_roster[name][2];
						end
						count = count + 1;
						rRoster[count] = {
							[1] = name,
							[2] = EP,
							[3] = GP,
							[4] = math.floor((EP/GP)*100)/100,
							[5] = class
						};
					end
				end
				if CEPGP_critReverse then
					rRoster = CEPGP_tSort(rRoster, 4);
				else
					CEPGP_critReverse = true;
					rRoster = CEPGP_tSort(rRoster, 4);
					CEPGP_critReverse = false;
				end
				if count >= 1 then
					for i = 1, #rRoster do
						if rRoster[i][1] == arg2 then
							if string.lower(arg1) == "!infoclass" then
								if not CEPGP_vInfo[arg2] then
									SendChatMessage("EP: " .. rRoster[i][2] .. " / GP: " .. rRoster[i][3] .. " / PR: " .. rRoster[i][4] .. " / PR rank among " .. compClass .. "s in raid: #" .. i, "WHISPER", CEPGP_LANGUAGE, arg2);
								else
									CEPGP_SendAddonMsg("!info;" .. arg2 .. ";EP: " .. rRoster[i][2] .. " / GP: " .. rRoster[i][3] .. " / PR: " .. rRoster[i][4] .. " / PR rank among " .. compClass .. "s in raid: #" .. i, "GUILD");
								end
							else
								if not CEPGP_vInfo[arg2] then
									SendChatMessage("EP: " .. rRoster[i][2] .. " / GP: " .. rRoster[i][3] .. " / PR: " .. rRoster[i][4] .. " / PR rank in raid: #" .. i, "WHISPER", CEPGP_LANGUAGE, arg2);
								else
									CEPGP_SendAddonMsg("!info;" .. arg2 .. ";EP: " .. rRoster[i][2] .. " / GP: " .. rRoster[i][3] .. " / PR: " .. rRoster[i][4] .. " / PR rank in raid: #" .. i, "GUILD");
								end
							end
						end
					end
				end
			end
		end
	end
end

function CEPGP_handleCombat(name, except)
	if name == L["The Prophet Skeram"] or name == L["Majordomo Executus"] and not except then return; end
	local EP;
	local isLead;
	for i = 1, GetNumGroupMembers() do
		if UnitName("player") == GetRaidRosterInfo(i) then
			_, isLead = GetRaidRosterInfo(i);
		end
	end
	if (((GetLootMethod() == "master" and CEPGP_isML() == 0) or (GetLootMethod() == "group" and isLead == 2)) and CEPGP_ntgetn(CEPGP_roster) > 0) or CEPGP_debugMode then
		local success = CEPGP_getCombatModule(name);
		if name == L["Zealot Zath"] or name == L["Zealot Lor'Khan"] then
			name = L["High Priest Thekal"];
		elseif name == L["Flamewaker Elite"] or name == L["Flamewaker Healer"] then
			name = L["Majordomo Executus"];
		end
		EP = tonumber(EPVALS[name]);
		if AUTOEP[name] and EP > 0 and success then
			local plurals = CEPGP_combatModule == L["The Four Horsemen"] or CEPGP_combatModule == L["The Bug Trio"] or CEPGP_combatModule == L["The Twin Emperors"]
			local message = format(L["%s " .. (plurals and "have" or "has") .. " been defeated! %d EP has been awarded to the raid"], CEPGP_combatModule, EP);
			CEPGP_AddRaidEP(EP, message, CEPGP_combatModule);
			if STANDBYEP and tonumber(STANDBYPERCENT) > 0 then
				CEPGP_addStandbyEP(EP*(tonumber(STANDBYPERCENT)/100), CEPGP_combatModule);
			end
		end
		CEPGP_UpdateStandbyScrollBar();
	end
end

function CEPGP_getCombatModule(name)
	--Majordomo Executus
	if name == L["Flamewaker Elite"] or name == L["Flamewaker Healer"] then
		CEPGP_kills = CEPGP_kills + 1;
		if CEPGP_kills == 8 then
			CEPGP_combatModule = L["Majordomo Executus"];
			return true;
		else
			return false;
		end
	end

	--Razorgore the Untamed
	if name == L["Razorgore the Untamed"] then
		if CEPGP_kills == 30 then --For this encounter, CEPGP_kills is used for the eggs
			CEPGP_combatModule = L["Razorgore the Untamed"];
			return true;
		else
			return false;
		end
	end

	-- High Priest Thekal
	if name == L["Zealot Lor'Khan"] or name == L["Zealot Zath"] or name == L["High Priest Thekal"] then
		CEPGP_combatModule = L["High Priest Thekal"];
		if CEPGP_THEKAL_PARAMS["LOR'KHAN_DEAD"] and CEPGP_THEKAL_PARAMS["ZATH_DEAD"] and CEPGP_THEKAL_PARAMS["THEKAL_DEAD"] then
			return true;
		else
			if name == L["Zealot Lor'Khan"] then
			CEPGP_THEKAL_PARAMS["LOR'KHAN_DEAD"] = true;
		elseif name == L["Zealot Zath"] then
			CEPGP_THEKAL_PARAMS["ZATH_DEAD"] = true;
		else
			CEPGP_THEKAL_PARAMS["THEKAL_DEAD"] = true;
		end
			return false;
		end
	end

	-- The Edge of Madness
	if name == L["Gri'lek"] or name == L["Hazza'rah"] or name == L["Renataki"] or name == L["Wushoolay"] then
		CEPGP_combatModule = L["The Edge of Madness"];
		return true;
	end

	-- Bug Trio
	if name == L["Princess Yauj"] or name == L["Vem"] or name == L["Lord Kri"] then
		CEPGP_combatModule = L["The Bug Trio"];
		CEPGP_kills = CEPGP_kills + 1;
		if CEPGP_kills == 3 then
			return true;
		else
			return false;
		end
	end

	-- Twin Emperors
	if name == L["Emperor Vek'lor"] or name == L["Emperor Vek'nilash"] then
		CEPGP_combatModule = L["The Twin Emperors"];
		CEPGP_kills = CEPGP_kills + 1;
		if CEPGP_kills == 2 then
			return true;
		else
			return false;
		end
	end

	-- The Four Horseman
	if name == L["Highlord Mograine"] or name == L["Thane Korth'azz"] or name == L["Lady Blaumeux"] or name == L["Sir Zeliek"] then
		CEPGP_combatModule = L["The Four Horsemen"];
		CEPGP_kills = CEPGP_kills + 1;
		if CEPGP_kills == 4 then
			return true;
		else
			return false;
		end
	end
	
	CEPGP_combatModule = name;
	return name;
end

function CEPGP_handleLoot(event, arg1, arg2)
	if event == "LOOT_CLOSED" then
		if CEPGP_isML() == 0 then
			CEPGP_SendAddonMsg("LootClosed;", "RAID");
		end
		CEPGP_distributing = false;
		CEPGP_distItemLink = nil;
		_G["distributing"]:Hide();
		if CEPGP_mode == "loot" then
			CEPGP_cleanTable();
			if CEPGP_isML() == 0 then
				CEPGP_SendAddonMsg("RaidAssistLootClosed", "RAID");
			end
			HideUIPanel(CEPGP_frame);
		end
		HideUIPanel(CEPGP_distribute_popup);
		--HideUIPanel(CEPGP_button_loot_dist);
		HideUIPanel(CEPGP_loot);
		HideUIPanel(CEPGP_distribute);
		HideUIPanel(CEPGP_loot_CEPGP_distributing);
		HideUIPanel(CEPGP_button_loot_dist);
		if UnitInRaid("player") then
			CEPGP_toggleFrame(CEPGP_raid);
		elseif GetGuildRosterInfo(1) then
			CEPGP_toggleFrame(CEPGP_guild);
		else
			HideUIPanel(CEPGP_frame);
			if CEPGP_isML() == 0 then
				distributing:Hide();
			end
		end
		
		if CEPGP_distribute:IsVisible() == 1 then
			HideUIPanel(CEPGP_distribute);
			ShowUIPanel(CEPGP_loot);
			CEPGP_responses = {};
			CEPGP_UpdateLootScrollBar();
		end
	elseif event == "LOOT_OPENED" then --and (UnitInRaid("player") or CEPGP_debugMode) then
		CEPGP_LootFrame_Update();
		ShowUIPanel(CEPGP_button_loot_dist);

	elseif event == "LOOT_SLOT_CLEARED" then
		if CEPGP_isML() == 0 then
			CEPGP_SendAddonMsg("RaidAssistLootClosed", "RAID");
		end
		if CEPGP_distributing and arg1 == CEPGP_lootSlot then --Confirms that an item is currently being distributed and that the item taken is the one in question
			if CEPGP_distPlayer ~= "" and CEPGP_award then
				CEPGP_distributing = false;
				if CEPGP_distGP then
					SendChatMessage("Awarded " .. _G["CEPGP_distribute_item_name"]:GetText() .. " to ".. CEPGP_distPlayer .. " for " .. CEPGP_distribute_GP_value:GetText() .. " GP", CHANNEL, CEPGP_LANGUAGE);
					CEPGP_addGP(CEPGP_distPlayer, CEPGP_distribute_GP_value:GetText(), CEPGP_DistID, CEPGP_distItemLink);
				else
					SendChatMessage("Awarded " .. _G["CEPGP_distribute_item_name"]:GetText() .. " to ".. CEPGP_distPlayer .. " for free", CHANNEL, CEPGP_LANGUAGE);
				end
				CEPGP_distPlayer = "";
				CEPGP_distribute_popup:Hide();
				CEPGP_distribute:Hide();
				_G["distributing"]:Hide();
				CEPGP_loot:Show();
			else
				CEPGP_distributing = false;
				SendChatMessage(_G["CEPGP_distribute_item_name"]:GetText() .. " has been distributed without EPGP", CHANNEL, CEPGP_LANGUAGE);
				CEPGP_distribute_popup:Hide();
				CEPGP_distribute:Hide();
				_G["distributing"]:Hide();
				CEPGP_loot:Show();
			end
		end
		CEPGP_LootFrame_Update();
	end	
end
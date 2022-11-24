function CEPGP_IncAddonMsg(message, sender)
	CEPGP_debugMsg('message '.. message .. ' sender ' .. sender);
	local args = CEPGP_split(message); -- The broken down message, delimited by semi-colons
	
	if args[1] == "CEPGP_setDistID" then
		CEPGP_DistID = args[2];
	
	elseif args[1] == UnitName("player") and args[2] == "distslot" then
		--Recipient should see this
		local slot = args[3];
		if slot then --string.len(slot) > 0 and slot ~= nil then
			local slotName = string.sub(slot, 9);
			local slotid, slotid2 = CEPGP_SlotNameToID(slotName);
			local currentItem;
			local currentItem2;
			local itemID;
			local itemID2;
			
			if slotid then
				currentItem = GetInventoryItemLink("player", slotid);
			end
			if slotid2 then
				currentItem2 = GetInventoryItemLink("player", slotid2);
			end
			
			if currentItem then
				itemID = CEPGP_getItemID(CEPGP_getItemString(currentItem));
			else
				itemID = "noitem";
			end
			
			if currentItem2 then
				itemID2 = CEPGP_getItemID(CEPGP_getItemString(currentItem2));
			else
				itemID2 = "noitem";
			end
			
			if itemID2 then
				CEPGP_SendAddonMsg(sender..";receiving;"..itemID..";"..itemID2);
			else
				CEPGP_SendAddonMsg(sender..";receiving;"..itemID);
			end
			
		elseif slot == "" then
			CEPGP_SendAddonMsg(sender..";receiving;noslot");
		elseif itemID == "noitem" then
			CEPGP_SendAddonMsg(sender..";receiving;noitem");
		end
		
		
	elseif args[2] == "receiving" then
		table.insert(CEPGP_responses, sender);
		local itemID = args[3];
		local itemID2 = args[4];
		CEPGP_itemsTable[sender] = {
			[1] = itemID,
			[2] = itemID2,
		};
		CEPGP_UpdateLootScrollBar();
	end
		
	if args[1] == UnitName("player") and args[2] == "versioncheck" then
		local index = CEPGP_ntgetn(CEPGP_groupVersion);
		if not index then index = 0; end
		for i=1, index do
			if CEPGP_groupVersion[i][1] == sender then
				CEPGP_groupVersion[i][2] = args[3];
				if CEPGP_roster[sender] then
					CEPGP_groupVersion[i][3] = CEPGP_roster[sender][2];
				else
					for x = 1, GetNumGroupMembers() do
						if GetRaidRosterInfo(x) == sender then
							_, _, _, _, CEPGP_groupVersion[i][3], CEPGP_groupVersion[i][4] = GetRaidRosterInfo(x);
							print(CEPGP_groupVersion[i][4]);
							break;
						end
					end
				end
				break;
			end
		end
		CEPGP_vInfo[sender] = args[3];
		CEPGP_checkVersion(message);
		CEPGP_UpdateVersionScrollBar();
		
		
	elseif message == "version-check" then
		if not sender then return; end
		CEPGP_updateGuild();
		if CEPGP_roster[sender] then
			CEPGP_SendAddonMsg(sender .. ";versioncheck;" .. CEPGP_VERSION, "GUILD");
		else
			CEPGP_SendAddonMsg(sender .. ";versioncheck;" .. CEPGP_VERSION, "RAID");
		end
	end
		
		
	if strfind(message, "RaidAssistLoot") and sender ~= UnitName("player")	then
		if args[1] == "RaidAssistLootDist" then
			if args[4] == "true" then
				CEPGP_RaidAssistLootDist(args[2], args[3], true);
			else
				CEPGP_RaidAssistLootDist(args[2], args[3], false);
			end
		else
			CEPGP_RaidAssistLootClosed();
		end
		
		
		--Raid assists receiving !need responses in the format of !need;playername;itemID (of item being distributed)
	elseif args[1] == "!need" and args[2] == UnitName("player") and sender ~= UnitName("player") then
		CEPGP_itemsTable[args[2]] = {};
		
	elseif args[1] == "LootClosed" then
		_G["CEPGP_respond"]:Hide();		
		
	elseif args[1] == "STANDBYEP" and args[2] == UnitName("player") then
		CEPGP_print(args[3]);
		
	elseif args[1] == "StandbyListAdd" and (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) and sender ~= UnitName("player") then
		for _, t in pairs(CEPGP_standbyRoster) do -- Is the player already in the standby roster?
			if t[1] == args[2] then
				return;
			end
		end
		for _, v in ipairs(CEPGP_raidRoster) do -- Is the player part of your raid group?
			if args[2] == v[1] then
				return;
			end
		end
		if not CEPGP_roster[args[2]] then -- Player might not be part of your guild. This could happen if you're pugging with another guild and they use CEPGP
			return;
		end
		local player, class, rank, rankIndex, EP, GP, classFile = args[2], args[3], args[4], args[5], args[6], args[7], args[8];
		CEPGP_standbyRoster[#CEPGP_standbyRoster+1] = {
			[1] = player,
			[2] = class,
			[3] = rank,
			[4] = rankIndex,
			[5] = EP,
			[6] = GP,
			[7] = math.floor((tonumber(EP)/tonumber(GP))*100)/100,
			[8] = classFile
		};
		CEPGP_UpdateStandbyScrollBar();
		
	elseif args[1] == "StandbyListRemove" and (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) and sender ~= UnitName("player") then
		for i, v in ipairs(CEPGP_standbyRoster) do
			if v[1] == args[2] then
				table.remove(CEPGP_standbyRoster, i);
			end
			break;
		end
	
	elseif (args[1] == "StandbyRemoved" or args[1] == "StandbyAdded") and args[2] == UnitName("player") then
		CEPGP_print(args[3]);	
		
	elseif args[1] == "!info" and args[2] == UnitName("player") then--strfind(message, "!info"..UnitName("player")) then
		CEPGP_print(args[3]);
		
	elseif (args[1] == UnitName("player") or args[1] == "?forceSync") and args[2] == "import" then
		local lane = "GUILD";
		if args[1] == "?forceSync" then
			local _, _, _, rIndex = CEPGP_getGuildInfo(sender); --rank index
			if not rIndex then return; end
			if rIndex + 1 <= CEPGP_force_sync_rank then --Index obtained by GetGuildRosterInfo starts at 0 whereas GuildControlGetRankName starts at 1 for some reason
				CEPGP_print(sender .. " is synchronising your settings with theirs");
			end
		end
		CEPGP_SendAddonMsg(sender..";impresponse;CHANNEL;"..CHANNEL, lane);
		CEPGP_SendAddonMsg(sender..";impresponse;MOD;"..MOD, lane);
		CEPGP_SendAddonMsg(sender..";impresponse;COEF;"..COEF, lane);
		CEPGP_SendAddonMsg(sender..";impresponse;MOD_COEF;"..MOD_COEF, lane);
		CEPGP_SendAddonMsg(sender..";impresponse;BASEGP;"..BASEGP, lane);
		CEPGP_SendAddonMsg(sender..";impresponse;WHISPERMSG;"..CEPGP_standby_whisper_msg, lane);
		CEPGP_SendAddonMsg(sender..";impresponse;KEYWORD;"..CEPGP_keyword, lane);
		if STANDBYEP then
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYEP;1", lane);
		else
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYEP;0", lane);
		end
		if STANDBYOFFLINE then
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYOFFLINE;1", lane);
		else
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYOFFLINE;0", lane);
		end
		CEPGP_SendAddonMsg(sender..";impresponse;STANDBYPERCENT;"..STANDBYPERCENT, lane);
		for k, v in pairs(SLOTWEIGHTS) do
			CEPGP_SendAddonMsg(sender..";impresponse;SLOTWEIGHTS;"..k..";"..v, lane);
		end
		if CEPGP_standby_byrank then --Implies result for both byrank and manual standby designation
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYBYRANK;1", lane);
		else
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYBYRANK;0", lane);
		end
		if CEPGP_standby_accept_whispers then
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYALLOWWHISPERS;1", lane);
		else
			CEPGP_SendAddonMsg(sender..";impresponse;STANDBYALLOWWHISPERS;0", lane);
		end
		for k, v in pairs(STANDBYRANKS) do
			if STANDBYRANKS[k][2] then
				CEPGP_SendAddonMsg(sender..";impresponse;STANDBYRANKS;"..k..";1", lane);
			else
				CEPGP_SendAddonMsg(sender..";impresponse;STANDBYRANKS;"..k..";0", lane);
			end
		end
		for k, v in pairs(EPVALS) do
			CEPGP_SendAddonMsg(sender..";impresponse;EPVALS;"..k..";"..v, lane);
		end
		for k, v in pairs(AUTOEP) do
			if AUTOEP[k] then
				CEPGP_SendAddonMsg(sender..";impresponse;AUTOEP;"..k..";1", lane);
			else
				CEPGP_SendAddonMsg(sender..";impresponse;AUTOEP;"..k..";0", lane);
			end
		end
		for k, v in pairs(OVERRIDE_INDEX) do
			CEPGP_SendAddonMsg(sender..";impresponse;OVERRIDE;"..k..";"..v, lane);
		end
		CEPGP_SendAddonMsg(sender..";impresponse;COMPLETE;", lane);
		
	elseif args[1] == UnitName("player") and args[2] == "impresponse" then
		local option = args[3];
		
		if option == "SLOTWEIGHTS" or option == "STANDBYRANKS" or option == "EPVALS" or option == "AUTOEP" or option == "OVERRIDE" then
			local field = args[4];
			local val = args[5];
			
			if option == "SLOTWEIGHTS" then
				SLOTWEIGHTS[field] = tonumber(val);
			elseif option == "STANDBYRANKS" then
				if val == "1" then
					STANDBYRANKS[tonumber(field)][2] = true;
				else
					STANDBYRANKS[tonumber(field)][2] = false;
				end
			elseif option == "EPVALS" then
				EPVALS[field] = tonumber(val);
			elseif option == "AUTOEP" then
				if val == "1" then
					AUTOEP[field] = true;
				else
					AUTOEP[field] = false;
				end
			elseif option == "OVERRIDE" then
				OVERRIDE_INDEX[field] = val;
			end
		else
			local val = args[4];
			if option == "CHANNEL" then
				CHANNEL = val;
			elseif option == "KEYWORD" then
				CEPGP_keyword = val;
			elseif option == "MOD" then
				MOD = tonumber(val);
			elseif option == "COEF" then
				COEF = tonumber(val);
			elseif option == "MOD_COEF" then
				MOD_COEF = tonumber(val);
			elseif option == "BASEGP" then
				BASEGP = tonumber(val);
			elseif option == "STANDBYBYRANK" then
				if val == "1" then
					CEPGP_standby_byrank = true;
					CEPGP_standby_manual = false;
				else
					CEPGP_standby_byrank = false;
					CEPGP_standby_manual = true;
				end
			elseif option == "STANDBYALLOWWHISPERS" then
				if val == "1" then
					CEPGP_standby_accept_whispers = true;
					CEPGP_options_standby_ep_accept_whispers_check:SetChecked(true);
				else
					CEPGP_standby_accept_whispers = false;
					CEPGP_options_standby_ep_accept_whispers_check:SetChecked(false);
				end
			elseif option == "WHISPERMSG" then
				CEPGP_standby_whisper_msg = val;
				CEPGP_options_standby_ep_message_val:SetText(val);
			elseif option == "STANDBYEP" then
				if tonumber(val) == 1 then
					STANDBYEP = true;
				else
					STANDBYEP = false;
				end
			elseif option == "STANDBYOFFLINE" then
				if tonumber(val) == 1 then
					STANDBYOFFLINE = true;
				else
					STANDBYOFFLINE = false;
				end
			elseif option == "STANDBYPERCENT" then
				STANDBYPERCENT = tonumber(val);		
			elseif option == "COMPLETE" then
				CEPGP_UpdateOverrideScrollBar();
				CEPGP_print("Import complete");
				CEPGP_button_options_OnClick();
			end
		end
		
		CEPGP_button_options_OnClick();
		
	elseif args[1] == "?IgnoreUpdates" and sender ~= UnitName("player") then
		if args[2] == "true" then
			CEPGP_ignoreUpdates = true;
		else
			CEPGP_ignoreUpdates = false;
			CEPGP_rosterUpdate("GUILD_ROSTER_UPDATE");
		end
	
	elseif args[1] == "CallItem" and sender ~= UnitName("player") then
		local id = args[2];
		local gp = args[3];
		CEPGP_callItem(id, gp);
		
	elseif strfind(message, "MainSpec") then
		CEPGP_handleComms("CHAT_MSG_WHISPER", CEPGP_keyword, sender);
		
	
	elseif args[1] == "CEPGP_TRAFFIC" then
		if string.find(sender, "-") then
			sender = string.sub(sender, 0, string.find(sender, "-")-1);
		end
		if sender == UnitName("player") then return; end
		local player = args[2];
		local issuer = args[3];
		local action = args[4];
		local EPB = args[5];
		local EPA = args[6];
		local GPB = args[7];
		local GPA = args[8];
		local itemID = args[9];
		if itemID == "" then itemID = 0; end
		local tStamp = args[10];
		if not tStamp or tStamp == "" then
			tStamp = time();
		end
		if CEPGP_itemExists(tonumber(itemID)) then
			local itemLink = CEPGP_getItemLink(itemID);
			if not itemLink then
				local item = Item:CreateFromItemID(tonumber(itemID));
				item:ContinueOnItemLoad(function()
					itemLink = CEPGP_getItemLink(itemID);
					TRAFFIC[CEPGP_ntgetn(TRAFFIC)+1] = {
					[1] = player,
					[2] = issuer,
					[3] = action,
					[4] = EPB,
					[5] = EPA,
					[6] = GPB,
					[7] = GPA,
					[8] = itemLink,
					[9] = tStamp
				};
				end);
			elseif itemLink then
				TRAFFIC[CEPGP_ntgetn(TRAFFIC)+1] = {
					[1] = player,
					[2] = issuer,
					[3] = action,
					[4] = EPB,
					[5] = EPA,
					[6] = GPB,
					[7] = GPA,
					[8] = itemLink,
					[9] = tStamp
				};
			end
		else
			TRAFFIC[CEPGP_ntgetn(TRAFFIC)+1] = {
				[1] = player,
				[2] = issuer,
				[3] = action,
				[4] = EPB,
				[5] = EPA,
				[6] = GPB,
				[7] = GPA,
				[9] = tStamp
			};
		end
		CEPGP_UpdateTrafficScrollBar();
	elseif args[1] == ROLE_CHECK_COMMAND_BEGIN then
		CEPGP_RoleCheckEventHandler();
	elseif args[1] == ROLE_CHECK_COMMAND_SEND_ROLE then
		CEPGP_RoleSetEventHandler(sender, args[2]);
	elseif args[1] == SHOW_MESSAGE_COMMAND then
		DEFAULT_CHAT_FRAME:AddMessage(args[2]);
	end
end

function CEPGP_SendAddonMsg(message, channel, person)
	local prefix = 'CEPGP';
	if channel == "GUILD" and IsInGuild() then
		C_ChatInfo.SendAddonMessage(prefix, message, "GUILD");
	elseif channel == 'WHISPER' then
		if person ~= nil then
			CEPGP_debugMsg('Sending message ' .. message .. ' to ' .. person);
			C_ChatInfo.SendAddonMessage(prefix, message, channel, person);
		end;
	elseif (channel == "RAID" or not channel) and IsInRaid("player") then --Player is in a raid group
		C_ChatInfo.SendAddonMessage(prefix, message, "RAID");
	elseif GetNumGroupMembers() > 0 and not IsInRaid("player") then --Player is in a party but not a raid
		C_ChatInfo.SendAddonMessage(prefix, message, "PARTY");
	elseif IsInGuild() then --If channel is not specified then assume guild
		C_ChatInfo.SendAddonMessage(prefix, message, "GUILD");
	end
end

function CEPGP_ShareTraffic(player, issuer, action, EPB, EPA, GPB, GPA, itemID)
	if not player or not action then return; end
	if not itemID then
		itemID = "";
	end
	if not issuer then
		issuer = "";
	end
	if not EPB then
		EPB = "";
	end
	if not EPA then
		EPA = "";
	end
	if not GPB then
		GPB = "";
	end
	if not GPA then
		GPA = "";
	end
	if CanEditOfficerNote() then
		CEPGP_SendAddonMsg("CEPGP_TRAFFIC;" .. player .. ";" .. issuer .. ";" .. action .. ";" .. EPB .. ";" .. EPA .. ";" .. GPB .. ";" .. GPA .. ";" .. itemID, "GUILD");
	end
end
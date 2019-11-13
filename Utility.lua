function CEPGP_initialise()
	_, _, _, CEPGP_ElvUI = GetAddOnInfo("ElvUI");
	if not CEPGP_ElvUI then CEPGP_ElvUI = GetAddOnInfo("TukUI"); end
	_G["CEPGP_version_number"]:SetText("Running Version: " .. CEPGP_VERSION);
	local ver2 = string.gsub(CEPGP_VERSION, "%.", ",");
	if not CEPGP_notice then
		CEPGP_notice = false;
	end
	if CHANNEL == nil then
		CHANNEL = "GUILD";
	end
	if MOD == nil then
		MOD = 1;
	end
	if COEF == nil then
		COEF = 4.83;
	end
	if MOD_COEF == nil then
		MOD_COEF = 2;
	end
	if BASEGP == nil then
		BASEGP = 1;
	end
	if CEPGP_min_threshold == nil then
		CEPGP_min_threshold = 2;
	end
	if CEPGP_keyword == nil then
		CEPGP_keyword = "!need";
	end
	if CEPGP_ntgetn(AUTOEP) == 0 then
		for k, v in pairs(bossNameIndex) do
			AUTOEP[k] = true;
		end
	end
	if CEPGP_ntgetn(EPVALS) == 0 then
		for k, v in pairs(bossNameIndex) do
			EPVALS[k] = v;
		end
	end
	if CEPGP_ntgetn(SLOTWEIGHTS) == 0 then
		SLOTWEIGHTS = {
			["2HWEAPON"] = 2,
			["WEAPONMAINHAND"] = 1.5,
			["WEAPON"] = 1.5,
			["WEAPONOFFHAND"] = 0.5,
			["HOLDABLE"] = 0.5,
			["SHIELD"] = 0.5,
			["RANGED"] = 0.5,
			["RANGEDRIGHT"] = 0.5,
			["THROWN"] = 0.5,
			["RELIC"] = 0.5,
			["HEAD"] = 1,
			["NECK"] = 0.5,
			["SHOULDER"] = 0.75,
			["CLOAK"] = 0.5,
			["CHEST"] = 1,
			["ROBE"] = 1,
			["WRIST"] = 0.5,
			["HAND"] = 0.75,
			["WAIST"] = 0.75,
			["LEGS"] = 1,
			["FEET"] = 0.75,
			["FINGER"] = 0.5,
			["TRINKET"] = 0.75,
			["EXCEPTION"] = 1
		}
	end
	if STANDBYPERCENT ==  nil then
		STANDBYPERCENT = 0;
	end
	if CEPGP_ntgetn(STANDBYRANKS) == 0 then
		for i = 1, 10 do
			STANDBYRANKS[i] = {};
			STANDBYRANKS[i][1] = GuildControlGetRankName(i);
			STANDBYRANKS[i][2] = false;
		end
	end
	if UnitInRaid("player") then
		CEPGP_rosterUpdate("GROUP_ROSTER_UPDATE");
	end
	if CEPGP_force_sync_rank == nil then
		CEPGP_force_sync_rank = 1;
	end
	tinsert(UISpecialFrames, "CEPGP_frame");
	tinsert(UISpecialFrames, "CEPGP_context_popup");
	tinsert(UISpecialFrames, "CEPGP_save_guild_logs");
	tinsert(UISpecialFrames, "CEPGP_restore_guild_logs");
	tinsert(UISpecialFrames, "CEPGP_settings_import");
	tinsert(UISpecialFrames, "CEPGP_override");
	tinsert(UISpecialFrames, "CEPGP_traffic");
	
	C_ChatInfo.RegisterAddonMessagePrefix("CEPGP"); --Registers CEPGP for use in the addon comms environment
	CEPGP_SendAddonMsg("version-check", "GUILD");
	DEFAULT_CHAT_FRAME:AddMessage("|c00FFC100Classic EPGP Version: " .. CEPGP_VERSION .. " Loaded|r");
	DEFAULT_CHAT_FRAME:AddMessage("|c00FFC100CEPGP: Currently reporting to channel - " .. CHANNEL .. "|r");
	
	if not CEPGP_notice then
		CEPGP_notice_frame:Show();
	elseif not CEPGP_1120_notice then
		_G["CEPGP_update_notice"]:Show();
	end
	
	if IsInRaid("player") and CEPGP_isML() == 0 then
		_G["CEPGP_confirmation"]:Show();
	end
	
	CEPGP_updateGuild();
	GameTooltip:HookScript("OnTooltipSetItem", CEPGP_addGPTooltip);
	hooksecurefunc("ChatFrame_OnHyperlinkShow", CEPGP_addGPHyperlink);
end

function CEPGP_calcGP(link, quantity, id)	
	local name, rarity, ilvl, itemType, subType, slot, classID, subClassID;
	if id then
		name, link, rarity, ilvl, itemType, subType, _, _, slot, _, _, classID, subClassID = GetItemInfo(id);
	elseif link then
		name, _, rarity, ilvl, itemType, subType, _, _, slot, _, _, classID, subClassID = GetItemInfo(link);
	else
		return 0;
	end
	if not name and CEPGP_itemExists(id) then
		local item = Item:CreateFromItemID(id);
		item:ContinueOnItemLoad(function()
			name, link, rarity, ilvl, itemType, subType, _, _, slot, _, _, classID, subClassID = GetItemInfo(id);
			for k, v in pairs(OVERRIDE_INDEX) do
				if k == link then
					return v;
				end
				local temp = string.lower(string.gsub(name, " ", ""));
				k = string.lower(string.gsub(k, " ", ""));
				if string.lower(temp) == string.lower(k) then
					return v;
				end
			end	
			local found = false;
			--Tier 3 slots
			if strfind(name, "desecrated") and rarity == 4 then
				if (name == "desecratedshoulderpads" or name == "desecratedspaulders" or name == "desecratedpauldrons") then slot = "INVTYPE_SHOULDER";
				elseif (name == "desecratedsandals" or name == "desecratedboots" or name == "desecratedsabatons") then slot = "INVTYPE_FEET";
				elseif (name == "desecratedbindings" or name == "desecratedwristguards" or name == "desecratedbracers") then slot = "INVTYPE_WRIST";
				elseif (name == "desecratedgloves" or name == "desecratedhandguards" or name == "desecratedgauntlets") then slot = "INVTYPE_HAND";
				elseif (name == "desecratedbelt" or name == "desecratedwaistguard" or name == "desecratedgirdle") then slot = "INVTYPE_WAIST";
				elseif (name == "desecratedleggings" or name == "desecratedlegguards" or name == "desecratedlegplates") then slot = "INVTYPE_LEGS";
				elseif (name == "desecratedcirclet" or name == "desecratedheadpiece" or name == "desecratedhelmet") then slot = "INVTYPE_HEAD";
				elseif name == "desecratedrobe" then slot = "INVTYPE_ROBE";
				elseif (name == "desecratedtunic" or name == "desecratedbreastplate") then slot = "INVTYPE_CHEST";
				end
				
			elseif strfind(name, "primalhakkari") and rarity == 4 then
				if (name == "primalhakkari bindings" or name == "primalhakkari armsplint" or name == "primalhakkari stanchion") then slot = "INVTYPE_WRIST";
				elseif (name == "primalhakkari girdle" or name == "primalhakkari sash" or name == "primalhakkari shawl") then slot = "INVTYPE_WAIST";
				elseif (name == "primalhakkari tabard" or name == "primalhakkari kossack" or name == "primalhakkari aegis") then slot = "INVTYPE_CHEST";
				end
			
			elseif strfind(name, "qiraji") then
				if (name == "qirajispikedhilt" or name == "qirajiornatehilt") then slot = "INVTYPE_WEAPONMAINHAND";
				elseif (name == "qirajiregaldrape" or name == "qirajimartialdrape") then slot = "INVTYPE_CLOAK";
				elseif (name == "qirajimagisterialring" or name == "qirajiceremonialring") then slot = "INVTYPE_FINGER";
				elseif (name == "imperialqirajiarmaments" or name == "imperialqirajiregalia") then slot = "INVTYPE_2HWEAPON";
				elseif (name == "qirajibindingsofcommand" or name == "qirajibindingsofdominance") then slot = "INVTYPE_WRIST";
				end
				
			elseif name == "headofossiriantheunscarred" or name == "headofonyxia" or name == "headofnefarian" or name == "eyeofcthun" then
				slot = "INVTYPE_NECK";
			elseif name == "thephylacteryofkel'thuzad" or name == "heartofhakkar" then
				slot = "INVTYPE_TRINKET";
			elseif name == "huskoftheoldgod" or name == "carapaceoftheoldgod" then
				slot = "INVTYPE_CHEST";
			elseif name == "ourosintacthide" or name == "skinofthegreatsandworm" then
				slot = "INVTYPE_LEGS";
					
			--Exceptions: Items that should not carry GP but still need to be distributed
			elseif name == "splinterofatiesh"
				or name == "tomeoftranquilizingshot"
				or name == "bindingsofthewindseeker"
				or name == "resilienceofthescourge"
				or name == "fortitudeofthescourge"
				or name == "mightofthescourge" 
				or name == "powerofthescourge"
				or name == "sulfuroningot"
				or name == "matureblackdragonsinew"
				or name == "nightmareengulfedobject"
				or name == "ancientpetrifiedleaf" then
				slot = "INVTYPE_EXCEPTION";
			else
				slot = "INVTYPE_EXCEPTION";
			end
		
			if slot == "INVTYPE_ROBE" then slot = "INVTYPE_CHEST"; end
			if slot == "INVTYPE_WEAPON" then slot = "INVTYPE_WEAPONOFFHAND"; end
			if CEPGP_debugMode then
				local quality = rarity == 0 and "Poor" or rarity == 1 and "Common" or rarity == 2 and "Uncommon" or rarity == 3 and "Rare" or rarity == 4 and "Epic" or "Legendary";
				CEPGP_print("Name: " .. name);
				CEPGP_print("Rarity: " .. quality);
				CEPGP_print("Item Level: " .. ilvl);
				CEPGP_print("Class ID: " .. classID);
				CEPGP_print("Subclass ID: " .. subClassID);
				CEPGP_print(GetItemSubClassInfo(classID, subClassID), false);
				CEPGP_print("Item Type: " .. itemType);
				CEPGP_print("Subtype: " .. subType);
				CEPGP_print("Slot: " .. slot);
			end
			slot = strsub(slot,strfind(slot,"INVTYPE_")+8,string.len(slot));
			slot = SLOTWEIGHTS[slot];
			if ilvl and rarity and slot then
				return math.floor((((COEF * (MOD_COEF^((ilvl/26) + (rarity-4))) * slot)*MOD)*quantity));
			else
				return 0;
			end
		end);
	else
		if not ilvl then ilvl = 0; end
		for k, v in pairs(OVERRIDE_INDEX) do
			if k == link then
				return v;
			end
			local temp = string.lower(string.gsub(name, " ", ""));
			k = string.lower(string.gsub(k, " ", ""));
			if string.lower(temp) == string.lower(k) then
				return v;
			end
		end	
		local found = false;
		if slot == "" or slot == nil then
			--Tier 3 slots
			if strfind(name, "desecrated") and rarity == 4 then
				if (name == "desecratedshoulderpads" or name == "desecratedspaulders" or name == "desecratedpauldrons") then slot = "INVTYPE_SHOULDER";
				elseif (name == "desecratedsandals" or name == "desecratedboots" or name == "desecratedsabatons") then slot = "INVTYPE_FEET";
				elseif (name == "desecratedbindings" or name == "desecratedwristguards" or name == "desecratedbracers") then slot = "INVTYPE_WRIST";
				elseif (name == "desecratedgloves" or name == "desecratedhandguards" or name == "desecratedgauntlets") then slot = "INVTYPE_HAND";
				elseif (name == "desecratedbelt" or name == "desecratedwaistguard" or name == "desecratedgirdle") then slot = "INVTYPE_WAIST";
				elseif (name == "desecratedleggings" or name == "desecratedlegguards" or name == "desecratedlegplates") then slot = "INVTYPE_LEGS";
				elseif (name == "desecratedcirclet" or name == "desecratedheadpiece" or name == "desecratedhelmet") then slot = "INVTYPE_HEAD";
				elseif name == "desecratedrobe" then slot = "INVTYPE_ROBE";
				elseif (name == "desecratedtunic" or name == "desecratedbreastplate") then slot = "INVTYPE_CHEST";
				end
				
			elseif strfind(name, "primalhakkari") and rarity == 4 then
				if (name == "primalhakkari bindings" or name == "primalhakkari armsplint" or name == "primalhakkari stanchion") then slot = "INVTYPE_WRIST";
				elseif (name == "primalhakkari girdle" or name == "primalhakkari sash" or name == "primalhakkari shawl") then slot = "INVTYPE_WAIST";
				elseif (name == "primalhakkari tabard" or name == "primalhakkari kossack" or name == "primalhakkari aegis") then slot = "INVTYPE_CHEST";
				end
			
			elseif strfind(name, "qiraji") then
				if (name == "qirajispikedhilt" or name == "qirajiornatehilt") then slot = "INVTYPE_WEAPONMAINHAND";
				elseif (name == "qirajiregaldrape" or name == "qirajimartialdrape") then slot = "INVTYPE_CLOAK";
				elseif (name == "qirajimagisterialring" or name == "qirajiceremonialring") then slot = "INVTYPE_FINGER";
				elseif (name == "imperialqirajiarmaments" or name == "imperialqirajiregalia") then slot = "INVTYPE_2HWEAPON";
				elseif (name == "qirajibindingsofcommand" or name == "qirajibindingsofdominance") then slot = "INVTYPE_WRIST";
				end
				
			elseif name == "headofossiriantheunscarred" or name == "headofonyxia" or name == "headofnefarian" or name == "eyeofcthun" then
				slot = "INVTYPE_NECK";
			elseif name == "thephylacteryofkel'thuzad" or name == "heartofhakkar" then
				slot = "INVTYPE_TRINKET";
			elseif name == "huskoftheoldgod" or name == "carapaceoftheoldgod" then
				slot = "INVTYPE_CHEST";
			elseif name == "ourosintacthide" or name == "skinofthegreatsandworm" then
				slot = "INVTYPE_LEGS";
					
			--Exceptions: Items that should not carry GP but still need to be distributed
			elseif name == "splinterofatiesh"
				or name == "tomeoftranquilizingshot"
				or name == "bindingsofthewindseeker"
				or name == "resilienceofthescourge"
				or name == "fortitudeofthescourge"
				or name == "mightofthescourge" 
				or name == "powerofthescourge"
				or name == "sulfuroningot"
				or name == "matureblackdragonsinew"
				or name == "nightmareengulfedobject"
				or name == "ancientpetrifiedleaf" then
				slot = "INVTYPE_EXCEPTION";
			else
				slot = "INVTYPE_EXCEPTION";
			end
		end
		
		if slot == "INVTYPE_ROBE" then slot = "INVTYPE_CHEST"; end
		if slot == "INVTYPE_WEAPON" then slot = "INVTYPE_WEAPONOFFHAND"; end
		if CEPGP_debugMode then
			local quality = rarity == 0 and "Poor" or rarity == 1 and "Common" or rarity == 2 and "Uncommon" or rarity == 3 and "Rare" or rarity == 4 and "Epic" or "Legendary";
			CEPGP_print("Name: " .. name);
			CEPGP_print("Rarity: " .. quality);
			CEPGP_print("Item Level: " .. ilvl);
			CEPGP_print("Class ID: " .. classID);
			CEPGP_print("Subclass ID: " .. subClassID);
			CEPGP_print(GetItemSubClassInfo(classID, subClassID), false);
			CEPGP_print("Item Type: " .. itemType);
			CEPGP_print("Subtype: " .. subType);
			CEPGP_print("Slot: " .. slot);
		end
		slot = strsub(slot,strfind(slot,"INVTYPE_")+8,string.len(slot));
		slot = SLOTWEIGHTS[slot];
		if ilvl and rarity and slot then
			return math.floor((((COEF * (MOD_COEF^((ilvl/26) + (rarity-4))) * slot)*MOD)*quantity));
		else
			return 0;
		end
	end
end

function CEPGP_addGPTooltip(self)
	if not CEPPG_gp_tooltips or not self:GetItem() or self:GetItem() == nil or self:GetItem() == "" then return; end
	local _, link = self:GetItem();
	local id = CEPGP_getItemID(CEPGP_getItemString(link));
	if not CEPGP_itemExists(tonumber(id)) then return; end
	local name = GetItemInfo(id);
	if not name and CEPGP_itemExists(tonumber(id)) then
		local item = Item:CreateFromItemID(tonumber(id));
		item:ContinueOnItemLoad(function()
			local gp = CEPGP_calcGP(_, 1, id);
			GameTooltip:AddLine("GP Value: " .. gp, {1,1,1});	
		end);
	else
		local gp = CEPGP_calcGP(_, 1, id);
		GameTooltip:AddLine("GP Value: " .. gp, {1,1,1});
	end
	
end

function CEPGP_addGPHyperlink(self, iString)
	if not string.find(iString, "item:") or not CEPPG_gp_tooltips then return; end
	local id = CEPGP_getItemID(iString);
	if not CEPGP_itemExists(tonumber(id)) then return; end
	local gp = CEPGP_calcGP(_, 1, id);
	ItemRefTooltip:AddLine("GP Value: " .. gp, {1,1,1});
	ItemRefTooltip:Show();
end

function CEPGP_populateFrame(CEPGP_criteria, items)
	local sorting = nil;
	local subframe = nil;
	if CEPGP_criteria == "name" or CEPGP_criteria == "rank" then
		SortGuildRoster(CEPGP_criteria);
	elseif CEPGP_criteria == "group" or CEPGP_criteria == "EP" or CEPGP_criteria == "GP" or CEPGP_criteria == "PR" then
		sorting = CEPGP_criteria;
	else
		sorting = "group";
	end
	if CEPGP_mode == "loot" then
		CEPGP_cleanTable();
	elseif CEPGP_mode ~= "loot" then
		CEPGP_cleanTable();
	end
	local tempItems = {};
	local total;
	if CEPGP_mode == "guild" and _G["CEPGP_guild"]:IsVisible() then
		CEPGP_UpdateGuildScrollBar();
	elseif CEPGP_mode == "raid" and _G["CEPGP_raid"]:IsVisible() then
		CEPGP_UpdateRaidScrollBar();
	elseif CEPGP_mode == "loot" then
		subframe = CEPGP_loot;
		local count = 0;
		if not items then
			total = 0;
		else
			local i = 1;
			for _,value in pairs(items) do 
				tempItems[i] = value;
				i = i + 1;
				count = count + 1;
			end
			i = nil;
		end
		total = count;
	end
	if CEPGP_mode == "loot" then 
		for i = 1, total do
			local texture, name, quality, gp, colour, iString, link, slot, x, quantity;
			x = i;
			texture = tempItems[i][1];
			name = tempItems[i][2];
			colour = ITEM_QUALITY_COLORS[tempItems[i][3]];
			link = tempItems[i][4];
			iString = tempItems[i][5];
			slot = tempItems[i][6];
			quantity = tempItems[i][7];
			gp = CEPGP_calcGP(link, quantity, CEPGP_getItemID(iString));
			if _G[CEPGP_mode..'item'..i] ~= nil then
				_G[CEPGP_mode..'announce'..i]:Show();
				_G[CEPGP_mode..'announce'..i]:SetWidth(20);
				_G[CEPGP_mode..'announce'..i]:SetScript('OnClick', function() CEPGP_announce(link, x, slot, quantity) CEPGP_distribute:SetID(_G[CEPGP_mode..'announce'..i]:GetID()) end);
				_G[CEPGP_mode..'announce'..i]:SetID(slot);
				
				_G[CEPGP_mode..'icon'..i]:Show();
				_G[CEPGP_mode..'icon'..i]:SetScript('OnEnter', function() GameTooltip:SetOwner(_G[CEPGP_mode..'icon'..i], "ANCHOR_BOTTOMLEFT") GameTooltip:SetHyperlink(iString) GameTooltip:Show() end);
				_G[CEPGP_mode..'icon'..i]:SetScript('OnLeave', function() GameTooltip:Hide() end);
				
				_G[CEPGP_mode..'texture'..i]:Show();
				_G[CEPGP_mode..'texture'..i]:SetTexture(texture);
				
				_G[CEPGP_mode..'item'..i]:Show();
				_G[CEPGP_mode..'item'..i].text:SetText(link);
				_G[CEPGP_mode..'item'..i].text:SetTextColor(colour.r, colour.g, colour.b);
				_G[CEPGP_mode..'item'..i].text:SetPoint('CENTER',_G[CEPGP_mode..'item'..i]);
				_G[CEPGP_mode..'item'..i]:SetWidth(_G[CEPGP_mode..'item'..i].text:GetStringWidth());
				_G[CEPGP_mode..'item'..i]:SetScript('OnClick', function() SetItemRef(link, iString) end);
				
				_G[CEPGP_mode..'itemGP'..i]:SetText(gp);
				_G[CEPGP_mode..'itemGP'..i]:SetTextColor(colour.r, colour.g, colour.b);
				_G[CEPGP_mode..'itemGP'..i]:SetWidth(35);
				_G[CEPGP_mode..'itemGP'..i]:SetScript('OnEnterPressed', function() _G[CEPGP_mode..'itemGP'..i]:ClearFocus() end);
				_G[CEPGP_mode..'itemGP'..i]:SetAutoFocus(false);
				_G[CEPGP_mode..'itemGP'..i]:Show();
			else
				subframe.announce = CreateFrame('Button', CEPGP_mode..'announce'..i, subframe, 'UIPanelButtonTemplate');
				subframe.announce:SetHeight(20);
				subframe.announce:SetWidth(20);
				subframe.announce:SetScript('OnClick', function() CEPGP_announce(link, x, slot, quantity) CEPGP_distribute:SetID(_G[CEPGP_mode..'announce'..i]:GetID()); end);
				subframe.announce:SetID(slot);
	
				subframe.icon = CreateFrame('Button', CEPGP_mode..'icon'..i, subframe);
				subframe.icon:SetHeight(20);
				subframe.icon:SetWidth(20);
				subframe.icon:SetScript('OnEnter', function() GameTooltip:SetOwner(_G[CEPGP_mode..'icon'..i], "ANCHOR_BOTTOMLEFT") GameTooltip:SetHyperlink(link) GameTooltip:Show() end);
				subframe.icon:SetScript('OnLeave', function() GameTooltip:Hide() end);
				
				local tex = subframe.icon:CreateTexture(CEPGP_mode..'texture'..i, "BACKGROUND");
				tex:SetAllPoints();
				tex:SetTexture(texture);
				
				subframe.itemName = CreateFrame('Button', CEPGP_mode..'item'..i, subframe);
				subframe.itemName:SetHeight(20);
				
				subframe.itemGP = CreateFrame('EditBox', CEPGP_mode..'itemGP'..i, subframe, 'InputBoxTemplate');
				subframe.itemGP:SetHeight(20);
				subframe.itemGP:SetWidth(35);
				
				if i == 1 then
					subframe.announce:SetPoint('CENTER', _G['CEPGP_'..CEPGP_mode..'_announce'], 'BOTTOM', -10, -20);
					subframe.icon:SetPoint('LEFT', _G[CEPGP_mode..'announce'..i], 'RIGHT', 10, 0);
					tex:SetPoint('LEFT', _G[CEPGP_mode..'announce'..i], 'RIGHT', 10, 0);
					subframe.itemName:SetPoint('LEFT', _G[CEPGP_mode..'icon'..i], 'RIGHT', 10, 0);
					subframe.itemGP:SetPoint('CENTER', _G['CEPGP_'..CEPGP_mode..'_GP'], 'BOTTOM', 10, -20);
				else
					subframe.announce:SetPoint('CENTER', _G[CEPGP_mode..'announce'..(i-1)], 'BOTTOM', 0, -20);
					subframe.icon:SetPoint('LEFT', _G[CEPGP_mode..'announce'..i], 'RIGHT', 10, 0);
					tex:SetPoint('LEFT', _G[CEPGP_mode..'announce'..i], 'RIGHT', 10, 0);
					subframe.itemName:SetPoint('LEFT', _G[CEPGP_mode..'icon'..i], 'RIGHT', 10, 0);
					subframe.itemGP:SetPoint('CENTER', _G[CEPGP_mode..'itemGP'..(i-1)], 'BOTTOM', 0, -20);
				end
				
				subframe.icon:SetScript('OnClick', function() SetItemRef(link, iString) end);
				
				subframe.itemName.text = subframe.itemName:CreateFontString(CEPGP_mode..'EPGP_i'..name..'text', 'OVERLAY', 'GameFontNormal');
				subframe.itemName.text:SetPoint('CENTER', _G[CEPGP_mode..'item'..i]);
				subframe.itemName.text:SetText(link);
				subframe.itemName.text:SetTextColor(colour.r, colour.g, colour.b);
				subframe.itemName:SetWidth(subframe.itemName.text:GetStringWidth());
				subframe.itemName:SetScript('OnClick', function() SetItemRef(link, iString) end);
				
				subframe.itemGP:SetText(gp);
				subframe.itemGP:SetTextColor(colour.r, colour.g, colour.b);
				subframe.itemGP:SetWidth(35);
				subframe.itemGP:SetScript('OnEnterPressed', function() _G[CEPGP_mode..'itemGP'..i]:ClearFocus() end);
				subframe.itemGP:SetAutoFocus(false);
				subframe.itemGP:Show();
			end
		end
		texture, name, colour, link, iString, slot, quantity, gp, tempItems = nil;
	end
end

function CEPGP_print(str, err)
	if not str then return; end;
	if err == nil then
		DEFAULT_CHAT_FRAME:AddMessage("|c006969FFCEPGP: " .. tostring(str) .. "|r");
	else
		DEFAULT_CHAT_FRAME:AddMessage("|c006969FFCEPGP:|r " .. "|c00FF0000Error|r|c006969FF - " .. tostring(str) .. "|r");
	end
end

function CEPGP_debugMsg(message)
	if CEPGP_debugMode then
		CEPGP_print(message)
	end
end

function CEPGP_cleanTable()
	local i = 1;
	while _G[CEPGP_mode..'member_name'..i] ~= nil do
		_G[CEPGP_mode..'member_group'..i].text:SetText("");
		_G[CEPGP_mode..'member_name'..i].text:SetText("");
		_G[CEPGP_mode..'member_rank'..i].text:SetText("");
		_G[CEPGP_mode..'member_EP'..i].text:SetText("");
		_G[CEPGP_mode..'member_GP'..i].text:SetText("");
		_G[CEPGP_mode..'member_PR'..i].text:SetText("");
		i = i + 1;
	end
	
	
	i = 1;
	while _G[CEPGP_mode..'item'..i] ~= nil do
		_G[CEPGP_mode..'announce'..i]:Hide();
		_G[CEPGP_mode..'icon'..i]:Hide();
		_G[CEPGP_mode..'texture'..i]:Hide();
		_G[CEPGP_mode..'item'..i].text:SetText("");
		_G[CEPGP_mode..'itemGP'..i]:Hide();
		i = i + 1;
	end
end

function CEPGP_toggleFrame(frame)
	for i = 1, table.getn(CEPGP_frames) do
		if CEPGP_frames[i]:GetName() == frame then
			CEPGP_frames[i]:Show();
		else
			CEPGP_frames[i]:Hide();
		end
	end
end

function CEPGP_rosterUpdate(event)
	if CEPGP_ignoreUpdates or not IsInGuild() then return; end
	if event == "GUILD_ROSTER_UPDATE" then
		local numGuild = GetNumGuildMembers();
		CEPGP_roster = {};
		if CanEditOfficerNote() then
			ShowUIPanel(CEPGP_guild_add_EP);
			ShowUIPanel(CEPGP_guild_decay);
			ShowUIPanel(CEPGP_guild_reset);
			ShowUIPanel(CEPGP_raid_add_EP);
			ShowUIPanel(CEPGP_raid_add_pull_EP);
			ShowUIPanel(CEPGP_button_guild_restore);
		else --[[ Hides context sensitive options if player cannot edit officer notes ]]--
			HideUIPanel(CEPGP_guild_add_EP);
			HideUIPanel(CEPGP_guild_decay);
			HideUIPanel(CEPGP_guild_reset);
			HideUIPanel(CEPGP_raid_add_EP);
			ShowUIPanel(CEPGP_raid_add_pull_EP);
			HideUIPanel(CEPGP_button_guild_restore);
		end
		for i = 1, numGuild do
			local name, rank, rankIndex, _, class, _, _, officerNote, online, _, classFileName = GetGuildRosterInfo(i);
			if string.find(name, "-") then
				name = string.sub(name, 0, string.find(name, "-")-1);
			end
			if name then
				local EP, GP = CEPGP_getEPGP(officerNote, i, name);
				local PR = math.floor((EP/GP)*100)/100;
				CEPGP_roster[name] = {
					[1] = i,
					[2] = class,
					[3] = rank,
					[4] = rankIndex,
					[5] = officerNote,
					[6] = PR,
					[7] = classFileName,
					[8] = online
				};
				if online and CEPGP_vSearch == "GUILD" then
					CEPGP_groupVersion[i] = {
						[1] = name,
						[2] = "Addon not enabled",
						[3] = class,
						[4] = classFileName
					};
				elseif CEPGP_vSearch == "GUILD" then
					CEPGP_groupVersion[i] = {
						[1] = name,
						[2] = "Offline",
						[3] = class,
						[4] = classFileName
					};
				end
			end
		end
		CEPGP_groupVersion = CEPGP_tSort(CEPGP_groupVersion, 1);
		if CEPGP_mode == "guild" and _G["CEPGP_guild"]:IsVisible() then
			CEPGP_UpdateGuildScrollBar();
		elseif CEPGP_mode == "raid" and _G["CEPGP_raid"]:IsVisible() then
			CEPGP_UpdateRaidScrollBar();
		end
		if not UnitInRaid("player") then
			CEPGP_standbyRoster = {};
		end
		CEPGP_UpdateStandbyScrollBar();
		
	elseif event == "GROUP_ROSTER_UPDATE" then
		if IsInRaid("player") and CEPGP_isML() == 0 then
			if not CEPGP_use then
				_G["CEPGP_confirmation"]:Show();
			end
		end
		if IsInRaid("player") then
			_G["CEPGP_button_raid"]:Show();
		else
			_G["CEPGP_button_raid"]:Hide();
		end
		CEPGP_raidRoster = {};
		for i = 1, GetNumGroupMembers() do
			local name = GetRaidRosterInfo(i);
			if not name then break; end
			if not UnitInRaid("player") then
				CEPGP_standbyRoster = {};
				CEPGP_UpdateStandbyScrollBar();
			else
				for k, v in ipairs(CEPGP_standbyRoster) do
					if v[1] == name then
						table.remove(CEPGP_standbyRoster, k); --Removes player from standby list if they have joined the raid
						CEPGP_SendAddonMsg("StandbyRemoved;" .. name .. ";You have been removed from the standby list because you have joined the raid.", "RAID");
						CEPGP_UpdateStandbyScrollBar();
					end
				end
			end
			local rank;
			local _, _, _, _, class, classFileName = GetRaidRosterInfo(i);
			if CEPGP_roster[name] then
				rank = CEPGP_roster[name][3];
				local EP, GP, BP = CEPGP_getEPGPBP(CEPGP_roster[name][5], _, name);
				local rankIndex = CEPGP_roster[name][4];
				CEPGP_raidRoster[i] = {
					[1] = name,
					[2] = class,
					[3] = rank,
					[4] = rankIndex,
					[5] = EP,
					[6] = GP,
					[7] = tonumber(EP)/tonumber(GP),
					[8] = classFileName,
					[9] = BP
				};
			else
				rank = "Not in Guild";
				CEPGP_raidRoster[i] = {
					[1] = name,
					[2] = class,
					[3] = rank,
					[4] = 0,
					[5] = 0,
					[6] = 0,
					[7] = 0,
					[8] = classFileName,
					[9] = 0
				};
			end
		end
		if UnitInRaid("player") then
			ShowUIPanel(CEPGP_button_raid);
		else --[[ Hides the raid and loot distribution buttons if the player is not in a raid group ]]--
			CEPGP_mode = "guild";
			CEPGP_toggleFrame("CEPGP_guild");
			
		end
		if _G["CEPGP_guild"]:IsVisible() then
			CEPGP_UpdateRaidScrollBar();
		end
	end
end

function CEPGP_addToStandby(player)
	if not player then return; end
	if not UnitInRaid("player") then
		CEPGP_print("You cannot add players to the standby list while not in a raid group.", true);
		return;
	end
	if player == UnitName("player") then
		CEPGP_print("You cannot add yourself to the standby list.", true);
		return;
	end
	if not CEPGP_roster[player] then
		CEPGP_print(player .. " is not a guild member", true);
		return;
	end
	for _, v in pairs(CEPGP_standbyRoster) do
		if string.lower(v[1]) == string.lower(player) then
			CEPGP_print(player .. " is already in the standby roster", true);
			return;
		end
	end
	for _, v in ipairs(CEPGP_raidRoster) do
		if string.lower(player) == string.lower(v[1]) then
			CEPGP_print(player .. " is part of the raid", true);
			return;
		end
	end	
	local _, class, rank, rankIndex, oNote, _, classFile = CEPGP_getGuildInfo(player);
	local EP,GP = CEPGP_getEPGP(oNote);
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
	CEPGP_standbyRoster = CEPGP_tSort(CEPGP_standbyRoster, 1);
	if CEPGP_standby_share then CEPGP_SendAddonMsg("StandbyListAdd;"..player..";"..class..";"..rank..";"..rankIndex..";"..EP..";"..GP..";"..classFile, "RAID"); end
	CEPGP_SendAddonMsg("StandbyAdded;" .. player .. ";You have been added to the standby list.", "GUILD");
	CEPGP_UpdateStandbyScrollBar();
end

function CEPGP_standardiseString(str)
	--Returns the string with proper nouns capitalised
	if not str then return; end
	local words = {};
	
	local count = 0;
	for i in (str .. " "):gmatch("([^ ]*) ") do
		if count == 0 then
			if string.lower(i) == "the" then
				count = count + 1;
				words[count] = "The";
			else
				count = count + 1;
				words[count] = string.upper(string.sub(i, 1, 1)) .. string.lower(string.sub(i, 2, string.len(i)));
			end
		else
			if string.lower(i) == "the" or string.lower(i) == "of" then
				count = count + 1;
				words[count] = string.lower(i);
			else
				count = count + 1;
				words[count] = string.upper(string.sub(i, 1, 1)) .. string.lower(string.sub(i, 2, string.len(i)));
			end
		end
	end
	local result = "";
	for i = 1, count do
		if i == 1 then
			result = words[i];
		elseif i <= count then
			result = result .. " " .. words[i];
		end
	end
	
	return result;
end

function CEPGP_split(str, delim, iters) --String to be split, delimiter, number of iterations
	local frags = {};
	local remainder = str;
	local count = 1;
	for i = 1, iters+1 do
		if string.find(remainder, delim) then
			frags[count] = string.sub(remainder, 1, string.find(remainder, delim)-1);
			remainder = string.sub(remainder, string.find(remainder, delim)+1, string.len(remainder));
		else
			frags[count] = string.sub(remainder, 1, string.len(remainder));
		end
		count = count + 1;
	end
	return frags;
end

function CEPGP_toggleStandbyRanks(show)
	if show and CEPGP_ntgetn(STANDBYRANKS) > 0 then
		for i = 1, 10 do
			STANDBYRANKS[i][1] = GuildControlGetRankName(i);
		end
		for i = 1, 10 do
			if STANDBYRANKS[i][1] then
				_G["CEPGP_options_standby_ep_rank_"..i]:Show();
				_G["CEPGP_options_standby_ep_rank_"..i]:SetText(tostring(STANDBYRANKS[i][1]));
				_G["CEPGP_options_standby_ep_check_rank_"..i]:Show();
				if STANDBYRANKS[i][2] == true then
					_G["CEPGP_options_standby_ep_check_rank_"..i]:SetChecked(true);
				else
					_G["CEPGP_options_standby_ep_check_rank_"..i]:SetChecked(false);
				end
			else
				_G["CEPGP_options_standby_ep_rank_"..i]:Hide();
				_G["CEPGP_options_standby_ep_check_rank_"..i]:Hide();
			end
			if GuildControlGetRankName(i) == "" then
				_G["CEPGP_options_standby_ep_rank_"..i]:Hide();
				_G["CEPGP_options_standby_ep_check_rank_"..i]:Hide();
				_G["CEPGP_options_standby_ep_check_rank_"..i]:SetChecked(false);
			end
		end
		CEPGP_options_standby_ep_list_button:Hide();
		CEPGP_options_standby_ep_accept_whispers_check:Hide();
		CEPGP_options_standby_ep_accept_whispers:Hide();
		CEPGP_options_standby_ep_message_val:Hide();
		CEPGP_options_standby_ep_whisper_message:Hide();
		CEPGP_options_standby_ep_byrank_check:SetChecked(true);
		CEPGP_options_standby_ep_manual_check:SetChecked(false);
	else
		for i = 1, 10 do
			_G["CEPGP_options_standby_ep_rank_"..i]:Hide();
			_G["CEPGP_options_standby_ep_check_rank_"..i]:Hide();
		end
		CEPGP_options_standby_ep_list_button:Show();
		CEPGP_options_standby_ep_accept_whispers_check:Show();
		CEPGP_options_standby_ep_accept_whispers:Show();
		CEPGP_options_standby_ep_message_val:Show();
		CEPGP_options_standby_ep_byrank_check:SetChecked(false);
		CEPGP_options_standby_ep_manual_check:SetChecked(true);
	end
end

function CEPGP_getGuildInfo(name)
	if CEPGP_tContains(CEPGP_roster, name, true) then
		return CEPGP_roster[name][1], CEPGP_roster[name][2], CEPGP_roster[name][3], CEPGP_roster[name][4], CEPGP_roster[name][5], CEPGP_roster[name][6], CEPGP_roster[name][7];  -- index, class, Rank, RankIndex, OfficerNote, PR, className in English
	else
		return nil;
	end
end

function CEPGP_getVal(str)
	local val = nil;
	val = strsub(str, strfind(str, " ")+1, string.len(str));
	return val;
end

function CEPGP_getIndex(name, index)
	if index then
		local temp = string.sub(GetGuildRosterInfo(index), 0, string.find(GetGuildRosterInfo(index), "-")-1);
		if temp == name then
			return index;
		else
			for i = 1, GetNumGuildMembers() do
				local temp = string.sub(GetGuildRosterInfo(i), 0, string.find(GetGuildRosterInfo(i), "-")-1);
				if temp == name then
					return i;
				end
			end
		end
	else
		for i = 1, GetNumGuildMembers() do
			local temp = string.sub(GetGuildRosterInfo(i), 0, string.find(GetGuildRosterInfo(i), "-")-1);
			if temp == name then
				return i;
			end
		end
	end
end

function CEPGP_indexToName(index)
	for name,value in pairs(CEPGP_roster) do
		if value[1] == index then
			return name;
		end
	end
end

function CEPGP_nameToIndex(name)
	for key,index in pairs(CEPGP_roster) do
		if key == name then
			return index[1];
		end
	end
end
function CEPGP_checkEPGPBP(offNote)

	local data = {};
	for i in offNote:gmatch("([^,%s]+)") do
		data[#data + 1] = i
	end

	local EP = tonumber(data[1]);
	local GP = tonumber(data[2]);
	local BP = tonumber(data[3]);

	if EP ~= nil and GP ~= nil and BP ~= nil then
		return true;
	end
	return false;
end

function CEPGP_getEPGP(offNote, index, name)
	if not name then index = CEPGP_nameToIndex(name); end

	if offNote == "" then --Click here to set an officer note qualifies as blank, also occurs if the officer notes are not visible
		return 0, tonumber(BASEGP);
	end

	local data = {};
	for i in offNote:gmatch("([^,%s]+)") do
		data[#data + 1] = i
	end

	local EP = tonumber(data[1]);
	local GP = tonumber(data[2]);

	if EP == nil or GP == nil then
		CEPGP_print("An error was found with " .. name .. "'s EPGP. Their officer note has been set to " .. offNote);
		return 0, tonumber(BASEGP);
	end

	return EP, GP;
end

function CEPGP_getEPGPBP(offNote, index, name)
	if not name then index = CEPGP_nameToIndex(name); end
	
	if offNote == "" then --Click here to set an officer note qualifies as blank, also occurs if the officer notes are not visible
		return 0, tonumber(BASEGP), 0;
	end

	local data = {};
	for i in offNote:gmatch("([^,%s]+)") do
		data[#data + 1] = i
	end

	local EP = tonumber(data[1]);
	local GP = tonumber(data[2]);
	local BP = tonumber(data[3]);

	if BP == nil then
		BP = 0;
	end

	if EP == nil or GP == nil or BP == nil then
		CEPGP_print("An error was found with " .. name .. "'s EPGP. Their officer note has been set to " .. offNote);
		return 0, tonumber(BASEGP), 0;
	end

	return EP, GP, BP;
end

function CEPGP_getItemString(link)
	if not link then
		return nil;
	end
	local itemString = string.find(link, "item[%-?%d:]+");
	itemString = strsub(link, itemString, string.len(link)-(string.len(link)-2)-6);
	return itemString;
end

function CEPGP_getItemID(iString)
	if not iString then
		return nil;
	end
	local itemString = string.sub(iString, 6, string.len(iString)-1)--"^[%-?%d:]+");
	return string.sub(itemString, 1, string.find(itemString, ":")-1);
end

function CEPGP_getItemLink(id)
	local name, _, rarity = GetItemInfo(id);
	if rarity == 0 then -- Poor
		return "\124cff9d9d9d\124Hitem:" .. id .. "::::::::110:::::\124h[" .. name .. "]\124h\124r";
	elseif rarity == 1 then -- Common
		return "\124cffffffff\124Hitem:" .. id .. "::::::::110:::::\124h[" .. name .. "]\124h\124r";
	elseif rarity == 2 then -- Uncommon
		return "\124cff1eff00\124Hitem:" .. id .. "::::::::110:::::\124h[" .. name .. "]\124h\124r";
	elseif rarity == 3 then -- Rare
		return "\124cff0070dd\124Hitem:" .. id .. "::::::::110:::::\124h[" .. name .. "]\124h\124r";
	elseif rarity == 4 then -- Epic
		return "\124cffa335ee\124Hitem:" .. id .. "::::::::110:::::\124h[" .. name .. "]\124h\124r";
	elseif rarity == 5 then -- Legendary
		return "\124cffff8000\124Hitem:" .. id .. "::::::::110:::::\124h[" .. name .. "]\124h\124r";
	end
end

function CEPGP_SlotNameToID(name)
	if name == nil then
		return nil
	end
	if name == "HEAD" then
		return 1;
	elseif name == "NECK" then
		return 2;
	elseif name == "SHOULDER" then
		return 3;
	elseif name == "CHEST" or name == "ROBE" then
		return 5;
	elseif name == "WAIST" then
		return 6;
	elseif name == "LEGS" then
		return 7;
	elseif name == "FEET" then
		return 8;
	elseif name == "WRIST" then
		return 9;
	elseif name == "HAND" then
		return 10;
	elseif name == "FINGER" then
		return 11, 12;
	elseif name == "TRINKET" then
		return 13, 14;
	elseif name == "CLOAK" then
		return 15;
	elseif name == "2HWEAPON" or name == "WEAPON" or name == "WEAPONMAINHAND" or name == "WEAPONOFFHAND" or name == "SHIELD" or name == "HOLDABLE" then
		return 16, 17;
	elseif name == "RANGED" or name == "RANGEDRIGHT" or name == "RELIC" then
		return 18;
	end
end

function CEPGP_inOverride(itemName)
	itemName = string.gsub(string.gsub(string.gsub(string.lower(itemName), " ", ""), "'", ""), ",", "");
	for k, _ in pairs(OVERRIDE_INDEX) do
		if itemName == string.gsub(string.gsub(string.gsub(string.lower(k), " ", ""), "'", ""), ",", "") then
			return true;
		end
	end
	return false;
end

function CEPGP_tContains(t, val, bool)
	if not t then return; end
	if bool == nil then
		for _,value in pairs(t) do
			if value == val then
				return true;
			end
		end
	elseif bool == true then
		for index,_ in pairs(t) do 
			if index == val then
				return true;
			end
		end
	end
	return false;
end

function CEPGP_isNumber(num)
	return not (string.find(tostring(num), '[^-0-9.]+') or string.find(tostring(num), '[^-0-9.]+$'));
end

function CEPGP_isML()
	local _, isML = GetLootMethod();
	return isML;
end

function CEPGP_updateGuild()
	if not IsInGuild() then
		HideUIPanel(CEPGP_button_guild);
		HideUIPanel(CEPGP_guild);
		return;
	else
		ShowUIPanel(CEPGP_button_guild);
		if CEPGP_ntgetn(STANDBYRANKS) > 0 then
			for i = 1, 10 do
				STANDBYRANKS[i][1] = GuildControlGetRankName(i);
			end
		end
	end
	GuildRoster();
end

function CEPGP_tSort(t, index)
	if not t then return; end
	local t2 = {};
	table.insert(t2, t[1]);
	table.remove(t, 1);
	local tSize = table.getn(t);
	if tSize > 0 then
		for x = 1, tSize do
			local t2Size = table.getn(t2);
			for y = 1, t2Size do
				if y < t2Size and t[1][index] ~= nil then
					if CEPGP_critReverse then
						if (t[1][index] >= t2[y][index]) then
							table.insert(t2, y, t[1]);
							table.remove(t, 1);
							break;
						elseif (t[1][index] < t2[y][index]) and (t[1][index] >= t2[(y + 1)][index]) then
							table.insert(t2, (y + 1), t[1]);
							table.remove(t, 1);
							break;
						end
					else
						if (t[1][index] <= t2[y][index]) then
							table.insert(t2, y, t[1]);
							table.remove(t, 1);
							break;
						elseif (t[1][index] > t2[y][index]) and (t[1][index] <= t2[(y + 1)][index]) then
							table.insert(t2, (y + 1), t[1]);
							table.remove(t, 1);
							break;
						end
					end
				elseif y == t2Size and t[1][index] ~= nil then
					if CEPGP_critReverse then
						if t[1][index] > t2[y][index] then
							table.insert(t2, y, t[1]);
							table.remove(t, 1);
						else
							table.insert(t2, t[1]);
							table.remove(t, 1);
						end
					else
						if t[1][index] < t2[y][index] then
							table.insert(t2, y, t[1]);
							table.remove(t, 1);
						else
							table.insert(t2, t[1]);
							table.remove(t, 1);
						end
					end
				end
			end
		end
	end
	return t2;
end

function CEPGP_ntgetn(tbl)
	if tbl == nil then
		return 0;
	end
	local n = 0;
	for _,_ in pairs(tbl) do
		n = n + 1;
	end
	return n;
end

function CEPGP_setCriteria(x, disp)
	if CEPGP_criteria == x then
		CEPGP_critReverse = not CEPGP_critReverse
	end
	CEPGP_criteria = x;
	if not disp then return; end
	if disp == "Raid" then
		CEPGP_UpdateRaidScrollBar();
	elseif disp == "Guild" then
		CEPGP_UpdateGuildScrollBar();
	elseif disp == "Loot" then
		CEPGP_UpdateLootScrollBar();
	elseif disp == "Standby" then
		CEPGP_UpdateStandbyScrollBar();
	elseif disp == "Attendance" then
		CEPGP_UpdateAttendanceScrollBar();
	end
end

function CEPGP_toggleBossConfigFrame(fName)
	for _, frame in pairs(CEPGP_boss_config_frames) do
		if frame:GetName() ~= fName then
			HideUIPanel(frame);
		else
			frame:Show();
		end;
	end
end

function CEPGP_button_options_OnClick()
	CEPGP_updateGuild();
	PlaySound(799);
	CEPGP_toggleFrame("CEPGP_options");
	CEPGP_mode = "options";
	CEPGP_options_mod_edit:SetText(tostring(MOD));
	CEPGP_options_coef_edit:SetText(tostring(COEF));
	CEPGP_options_coef_2_edit:SetText(tostring(MOD_COEF));
	CEPGP_options_gp_base_edit:SetText(tostring(BASEGP));
	CEPGP_options_keyword_edit:SetText(tostring(CEPGP_keyword));
	if STANDBYEP then
		CEPGP_options_standby_ep_check:SetChecked(true);
	else
		CEPGP_options_standby_ep_check:SetChecked(false);
	end
	CEPGP_options_standby_ep_val:SetText(tostring(STANDBYPERCENT));
	if CEPGP_standby_byrank then
		CEPGP_toggleStandbyRanks(true);
	else
		CEPGP_toggleStandbyRanks(false);
	end
	if STANDBYEP then
		_G["CEPGP_options_standby_ep_check"]:SetChecked(true);
	else
		_G["CEPGP_options_standby_ep_check"]:SetChecked(false);
	end
	if STANDBYOFFLINE then
		_G["CEPGP_options_standby_ep_offline_check"]:SetChecked(true);
	else
		_G["CEPGP_options_standby_ep_offline_check"]:SetChecked(false);
	end
	CEPGP_options_standby_ep_val:SetText(tostring(STANDBYPERCENT));
	if CEPGP_options_standby_ep_byrank_check:GetChecked() then
		CEPGP_options_standby_ep_message_val:Hide();
		CEPGP_options_standby_ep_whisper_message:Hide();
	else
		CEPGP_options_standby_ep_message_val:Show();
		CEPGP_options_standby_ep_whisper_message:Show();
	end
	for k, v in pairs(SLOTWEIGHTS) do
		if k ~= "ROBE" and k ~= "WEAPON" and k ~= "EXCEPTION" then
			_G["CEPGP_options_" .. k .. "_weight"]:SetText(tonumber(SLOTWEIGHTS[k]));
		end
	end
	local rName = GuildControlGetRankName(CEPGP_force_sync_rank); --rank name
	UIDropDownMenu_SetSelectedName(CEPGP_sync_rank, rName);
	if ALLOW_FORCED_SYNC then
		CEPGP_options_allow_forced_sync_check:SetChecked(true);
		_G["CEPGP_sync_rank"]:Show();
		_G["CEPGP_button_options_force_sync"]:Show();
	else
		CEPGP_options_allow_forced_sync_check:SetChecked(false);
		_G["CEPGP_sync_rank"]:Hide();
		_G["CEPGP_button_options_force_sync"]:Hide();
	end
	if CEPGP_minEP[1] then
		CEPGP_options_min_EP_check:SetChecked(true);
		_G["CEPGP_options_min_EP_amount"]:Show();
	else
		CEPGP_options_min_EP_check:SetChecked(false);
		_G["CEPGP_options_min_EP_amount"]:Hide();
	end
	if CEPGP_loot_GUI then
		_G["CEPGP_options_response_gui_checkbox"]:SetChecked(true);
		_G["CEPGP_options_keyword"]:Hide();
		_G["CEPGP_options_keyword_edit"]:Hide();
	else
		_G["CEPGP_options_response_gui_checkbox"]:SetChecked(false);
		_G["CEPGP_options_keyword"]:Show();
		_G["CEPGP_options_keyword_edit"]:Show();
	end
	CEPGP_populateFrame();
end

function CEPGP_UIDropDownMenu_Initialize(frame, initFunction, displayMode, level, menuList, search)
	if ( not frame ) then
		frame = self;
	end
	frame.menuList = menuList;

	if ( frame:GetName() ~= UIDROPDOWNMENU_OPEN_MENU ) then
		UIDROPDOWNMENU_MENU_LEVEL = 1;
	end

	-- Set the frame that's being intialized
	UIDROPDOWNMENU_INIT_MENU = frame:GetName();

	-- Hide all the buttons
	local button, dropDownList;
	for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
		dropDownList = _G["DropDownList"..i];
		if ( i >= UIDROPDOWNMENU_MENU_LEVEL or frame:GetName() ~= UIDROPDOWNMENU_OPEN_MENU ) then
			dropDownList.numButtons = 0;
			dropDownList.maxWidth = 0;
			for j=1, UIDROPDOWNMENU_MAXBUTTONS, 1 do
				button = _G["DropDownList"..i.."Button"..j];
				button:Hide();
			end
			dropDownList:Hide();
		end
	end
	frame:SetHeight(UIDROPDOWNMENU_BUTTON_HEIGHT * 2);
	
	-- Set the initialize function and call it.  The initFunction populates the dropdown list.
	if ( initFunction ) then
		frame.initialize = initFunction;
		initFunction(level, frame.menuList, search);
	end

	-- Change appearance based on the displayMode
	if ( displayMode == "MENU" ) then
		_G[frame:GetName().."Left"]:Hide();
		_G[frame:GetName().."Middle"]:Hide();
		_G[frame:GetName().."Right"]:Hide();
		_G[frame:GetName().."ButtonNormalTexture"]:SetTexture("");
		_G[frame:GetName().."ButtonDisabledTexture"]:SetTexture("");
		_G[frame:GetName().."ButtonPushedTexture"]:SetTexture("");
		_G[frame:GetName().."ButtonHighlightTexture"]:SetTexture("");
		_G[frame:GetName().."Button"]:ClearAllPoints();
		_G[frame:GetName().."Button"]:SetPoint("LEFT", frame:GetName().."Text", "LEFT", -9, 0);
		_G[frame:GetName().."Button"]:SetPoint("RIGHT", frame:GetName().."Text", "RIGHT", 6, 0);
		frame.displayMode = "MENU";
	end

end

function CEPGP_getDebugInfo()
	local info = "<details><summary>Debug Info</summary><br />\n";
	info = info .. "Version: " .. CEPGP_VERSION .. "<br />\n";
	info = info .. "Locale: " .. GetLocale() .. "<br />\n";
	info = info .. "GP Formula: (" .. COEF .. "x(" .. MOD_COEF .. "^<sup>((ilvl/26)+(rarity-4))</sup>)xSlot Modifier)x" .. MOD .. "<br />";
	info = info .. "Base GP: " .. BASEGP .. "<br />\n";
	if STANDBYEP then
		info = info .. "Standby EP: True<br />\n";
	else
		info = info .. "Standby EP: False<br />\n";
	end
	if STANDBYOFFLINE then
		info = info .. "Standby Offline: True<br />\n";
	else
		info = info .. "Standby Offline: False<br />\n";
	end
	info = info .. "Standby Percent: " .. STANDBYPERCENT .. "<br />\n";
		if CEPGP_standby_accept_whispers then
		info = info .. "Standby Accept Whispers: True<br />\n";
	else
		info = info .. "Standby Accept Whispers: False<br />\n";
	end
	if CEPGP_standby_byrank then
		info = info .. "Standby EP by Rank: True<br />\n";
	else
		info = info .. "Standby EP by Rank: False<br />\n";
	end
	if CEPGP_standby_manual then
		info = info .. "Standby EP Manual Delegation: True<br />\n";
	else
		info = info .. "Standby EP Manual Delegation: False<br />\n";
	end
	
	if CEPGP_loot_GUI then
		info = info .. "GUI for Loot: True<br />\n";
	else
		info = info .. "GUI for Loot: False<br />\n";
	end
	
	info = info .. "Loot Response Keyphrase: " .. CEPGP_keyword .. "<br />\n";
		
	info = info .. "Standby EP Whisper Keyphrase: " .. CEPGP_standby_whisper_msg .. "<br /><br />\n";

	info = info .. "<details><summary>Auto EP</summary>\n";
	for k, v in pairs(AUTOEP) do
		if v then
			info = info .. k .. ": True<br />\n";
		else
			info = info .. k .. ": False<br />\n";
		end
	end
	info = info .. "</details>\n";
	info = info .. "<details><summary>EP Values</summary>\n";
	for k, v in pairs(EPVALS) do
		info = info .. k .. ": " .. v .. "<br />\n";
	end
	info = info .. "</details>\n";
	info = info .. "<details><summary>Standby Guild Ranks</summary>\n";
	for k, v in pairs(STANDBYRANKS) do
		if v[1] ~= "" and v[1] ~= nil then
			if v[2] then
				info = info .. v[1] .. ": True<br />\n";
			else
				info = info .. v[1] .. ": False<br />\n";
			end
		end
	end
	info = info .. "</details>\n";
	info = info .. "<details><summary>Slot Weights</summary>\n";
	for k, _ in pairs(SLOTWEIGHTS) do
		info = info .. k .. ": " .. SLOTWEIGHTS[k] .. "<br />\n";
	end
	info = info .. "</details>\n";
	info = info .. "<details><summary>Override List</summary>\n";
	for k, v in pairs(OVERRIDE_INDEX) do
		info = info .. k .. ": " .. v .. "<br />\n";
	end
	info = info .. "</details>\n";
	info = info .. "<details><summary>Addons List</summary>\n";
	for i = 1, GetNumAddOns() do
		local name, _, _, enabled = GetAddOnInfo(i);
		if enabled then
			info = info .. name .. "<br />\n";
		end
	end
	info = info .. "</details>\n";
	info = info .. "<details><summary>Enabled Plugins</summary>\n";
	for _, plugin in ipairs(CEPGP_plugins) do
		info = info .. plugin .. "<br />\n";
	end
	info = info .. "</details>\n";
	info = info .. "</details>";
	return info;
end

function CEPGP_getPlayerClass(name, index)
	if not index and not name then return; end
	local class;
	if name == "Guild" then
		return _, {r=0, g=1, b=0};
	end
	if name == "Raid" then
		return _, {r=1, g=0.10, b=0.10};
	end
	if index then
		_, _, _, _, _, _, _, _, _, _, classFileName = GetGuildRosterInfo(index);
		return class, RAID_CLASS_COLORS[classFileName];
	else
		local id = CEPGP_nameToIndex(name);
		if not id then
			return nil;
		else
			_, _, _, _, _, _, _, _, _, _, classFileName = GetGuildRosterInfo(id);
			return class, RAID_CLASS_COLORS[classFileName];
		end
	end
end

function CEPGP_recordAttendance()
	if not UnitInRaid("player") and not CEPGP_debugMode then
		CEPGP_print("You are not in a raid group", true);
		return;
	end
	CEPGP_raid_logs[#CEPGP_raid_logs+1] = {
		[1] = time()
	};
	for i = 1, GetNumGroupMembers(), 1 do
		CEPGP_raid_logs[#CEPGP_raid_logs][i+1] = {
			[1] = GetRaidRosterInfo(i),
			[2] = false --Are they a standby player? Nope.
		};
	end
	for k, v in pairs(CEPGP_standbyRoster) do
		CEPGP_raid_logs[#CEPGP_raid_logs][#CEPGP_raid_logs[#CEPGP_raid_logs]+1] = { --CEPGP_raid_logs[index][timestamp][1] = player name, [2] = bool
			[1] = v[1],
			[2] = true --Are they a standby player? YUP.
		};
	end
	CEPGP_print("Snapshot recorded");
	CEPGP_UpdateAttendanceScrollBar();
end

function CEPGP_deleteAttendance()
	local index = UIDropDownMenu_GetSelectedValue(CEPGP_attendance_dropdown);
	if not index or index == 0 then
		CEPGP_print("Select a snapshot and try again", true);
		return;
	end
	CEPGP_print("Deleted snapshot: " .. date("%d/%m/%Y %H:%M", CEPGP_raid_logs[index][1]));
	local size = CEPGP_ntgetn(CEPGP_raid_logs);
	for i = index, size-1 do
		CEPGP_raid_logs[index] = CEPGP_raid_logs[index+1];
	end
	CEPGP_raid_logs[size] = nil;
	CEPGP_snapshot = nil;
	UIDropDownMenu_SetSelectedValue(CEPGP_attendance_dropdown, 0);
	CEPGP_UpdateAttendanceScrollBar();
end

function CEPGP_formatExport(form)
	--form is the export format
	if form == "CSV" then
		local temp = {};
		local text = "";
		local size = CEPGP_ntgetn(CEPGP_roster);
		for k, v in pairs(CEPGP_roster) do
			temp[CEPGP_ntgetn(temp)+1] = {
				[1] = k,
				[2] = v[2],
				[3] = v[3],
				[4] = v[4],
				[5] = v[5],
				[6] = v[6]
			};
		end
		temp = CEPGP_tSort(temp, 1);
		for i = 1, size do
			text = text .. temp[i][1] .. "," .. temp[i][2] .. "," .. temp[i][3] .. "," .. temp[i][5] .. "," .. temp[i][6] .. "\n"; --Line 16
		end
		_G["CEPGP_export_dump"]:SetText(text);
		_G["CEPGP_export_dump"]:HighlightText();
		temp = nil;
		text = nil;
		size = nil;
	end
end

function CEPGP_calcAttendance(name)
	local count = 0;
	local cWeek = 0; --count week
	local cFN = 0; --count fornight
	local cMonth = 0; --count month
	local cTwoMonth = 0; --count 2 months
	local cThreeMonth = 0; --count 3 months
	for _, v in pairs(CEPGP_raid_logs) do
		for i = 2, CEPGP_ntgetn(v), 1 do
			local diff = time() - v[1];
			diff = diff/60/60/24;
			if v[i] == name then --Accommodates for the old raid attendance structure
				count = count + 1;
				if diff <= 90 then
					cThreeMonth = cThreeMonth + 1;
					if diff <= 60 then
						cTwoMonth = cTwoMonth + 1;
						if diff <= 30 then
							cMonth = cMonth + 1;
							if diff <= 14 then
								cFN = cFN + 1;
								if diff <= 7 then
									cWeek = cWeek + 1;
								end
							end
						end
					end
				end
				break;
			elseif v[i][1] == name then --Accommodates for the new raid attendance structure (i.e. [1] = name, [2] = bool for standby roster
				local diff = time() - v[1];
				diff = diff/60/60/24;
				count = count + 1;
				if diff <= 90 then
					cThreeMonth = cThreeMonth + 1;
					if diff <= 60 then
						cTwoMonth = cTwoMonth + 1;
						if diff <= 30 then
							cMonth = cMonth + 1;
							if diff <= 14 then
								cFN = cFN + 1;
								if diff <= 7 then
									cWeek = cWeek + 1;
								end
							end
						end
					end
				end
				break;
			end
		end
	end
	return count, cWeek, cFN, cMonth, cTwoMonth, cThreeMonth;
end

function CEPGP_calcAttIntervals()
	local week = 0;
	local fn = 0;
	local mon = 0;
	local twoMon = 0;
	local threeMon = 0;
	for _, v in pairs(CEPGP_raid_logs) do
		local diff = time() - v[1];
		diff = diff/60/60/24;
		if diff <= 90 then
			threeMon = threeMon + 1;
			if diff <= 60 then
				twoMon = twoMon + 1;
				if diff <= 30 then
					mon = mon + 1;
					if diff <= 14 then
						fn = fn + 1;
						if diff <= 7 then
							week = week + 1;
						end
					end
				end
			end
		end
	end
	return week, fn, mon, twoMon, threeMon;
end

function CEPGP_callItem(id, gp)
	if not id then return; end
	id = tonumber(id); -- Must be in a numerical format
	local name, link, _, _, _, _, _, _, _, tex, _, classID, subClassID = GetItemInfo(id);
	local iString;
	if not link and CEPGP_itemExists(id) then
		local item = Item:CreateFromItemID(id);
		item:ContinueOnItemLoad(function()
				_, link, _, _, _, _, _, _, _, tex, _, classID, subClassID = GetItemInfo(id)
				if not CEPGP_canEquip(GetItemSubClassInfo(classID, subClassID)) and CEPGP_auto_pass then
					CEPGP_print("Cannot equip " .. link .. "|c006969FF. Passing on item.|r");
					return;
				end
				iString = CEPGP_getItemString(link);
				_G["CEPGP_respond"]:Show();
				_G["CEPGP_respond_texture"]:SetTexture(tex);
				_G["CEPGP_respond_texture_frame"]:SetScript('OnEnter', function()
																		GameTooltip:SetOwner(_G["CEPGP_respond_texture_frame"], "ANCHOR_TOPLEFT")
																		GameTooltip:SetHyperlink(iString);
																		GameTooltip:Show();
																	end);
				_G["CEPGP_respond_texture_frame"]:SetScript('OnLeave', function()
																		GameTooltip:Hide();
																	end);
				_G["CEPGP_respond_item_name_frame"]:SetScript('OnClick', function() SetItemRef(iString, name); end);
				_G["CEPGP_respond_item_name"]:SetText(link);
				_G["CEPGP_respond_gp_value"]:SetText(gp);
			end);
	else
		if not CEPGP_canEquip(GetItemSubClassInfo(classID, subClassID)) and CEPGP_auto_pass then
			CEPGP_print("Cannot equip " .. link .. "|c006969FF. Passing on item.|r");
			return;
		end
		iString = CEPGP_getItemString(link);
		_G["CEPGP_respond"]:Show();
		_G["CEPGP_respond_texture"]:SetTexture(tex);
		_G["CEPGP_respond_texture_frame"]:SetScript('OnEnter', function()
																GameTooltip:SetOwner(_G["CEPGP_respond_texture_frame"], "ANCHOR_TOPLEFT")
																GameTooltip:SetHyperlink(iString);
																GameTooltip:Show();
															end);
		_G["CEPGP_respond_texture_frame"]:SetScript('OnLeave', function()
																GameTooltip:Hide();
															end);
		_G["CEPGP_respond_item_name_frame"]:SetScript('OnClick', function() SetItemRef(iString, name); end);
		_G["CEPGP_respond_item_name"]:SetText(link);
		_G["CEPGP_respond_gp_value"]:SetText(gp);
	end
end

function CEPGP_checkVersion(message)
	local build = string.sub(message, string.find(message, ";")+1); --The whole message, but bits get taken off to form the major, minor and build
	build = string.sub(build, string.find(build, ";")+1);
	local major = string.sub(build, 0, string.find(build, "%.")-1);
	build = string.sub(build, string.len(major)+2);
	local minor = string.sub(build, 0, string.find(build, "%.")-1);
	build = string.sub(build, string.find(build, "%.")+1);
	
	--Current build information
	local curBuild = CEPGP_VERSION;
	local curMajor = string.sub(curBuild, 0, string.find(curBuild, "%.")-1);
	curBuild = string.sub(curBuild, string.len(curMajor)+2);
	local curMinor = string.sub(curBuild, 0, string.find(curBuild, "%.")-1);
	curBuild = string.sub(curBuild, string.find(curBuild, "%.")+1);
	
	outMessage = "Your addon is out of date. Version " .. major .. "." .. minor .. "." .. build .. " is now available for download at https://github.com/Alumian/CEPGP-Retail"
	if not CEPGP_VERSION_NOTIFIED then
		if tonumber(major) > tonumber(curMajor) then 
			CEPGP_print(outMessage);
			CEPGP_VERSION_NOTIFIED = true;
		elseif tonumber(major) == tonumber(curMajor) and tonumber(minor) > tonumber(curMinor) then
			CEPGP_print(outMessage);
			CEPGP_VERSION_NOTIFIED = true;
		elseif tonumber(major) == tonumber(curMajor) and tonumber(minor) == tonumber(curMinor) and tonumber(build) > tonumber(curBuild) then
			CEPGP_print(outMessage);
			CEPGP_VERSION_NOTIFIED = true;
		end
	end
end

function CEPGP_split(msg)
	local args = {};
	local count = 1;
	for i in (msg .. ";"):gmatch("([^;]*);") do
		args[count] = i;
		count = count + 1;
	end
	return args;
end

function CEPGP_canEquip(slot)
	local _, class = UnitClass("player");
	local temp = string.sub(class, 2, string.len(class));
	class = string.sub(class, 1, 1) .. string.lower(temp);
	if CEPGP_tContains(CEPGP_classes[class], slot) then return true; end
	return false;
end

function CEPGP_itemExists(id)
	if not id or not tonumber(id) then return false; end
	if C_Item.DoesItemExistByID(tonumber(id)) then
		return true;
	else
		return false;
	end
end

function CEPGP_getReportChannel()
	local channels = {"SAY","YELL","PARTY","RAID","GUILD","OFFICER"};
	for k, v in pairs(channels) do
		if string.upper(CHANNEL) == v then
			return string.upper(CHANNEL);
		end
	end
	for i = 4, C_ChatInfo.GetNumActiveChannels() do
		if select(2, GetChannelName(i)) == CHANNEL then
			return i;
		end
	end
	CEPGP_print("Couldn't post to channel \"" .. CHANNEL .. "\". Please update your reporting channel in CEPGP options.");
end

function CEPGP_sendChatMessage(msg)
	if not msg then return; end
	if tonumber(CEPGP_getReportChannel()) then
		SendChatMessage(msg, "CHANNEL", CEPGP_LANGUAGE, CEPGP_getReportChannel());
	else
		SendChatMessage(msg, CHANNEL, CEPGP_LANGUAGE);
	end
end
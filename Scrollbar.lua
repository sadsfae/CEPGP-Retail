function CEPGP_UpdateLootScrollBar()
	local tempTable = {};
	local count = 1;
	for name, id in pairs(CEPGP_itemsTable) do
		local EP, GP = CEPGP_getEPGP(CEPGP_roster[name][5], CEPGP_roster[name][1], name)
		if not EP then EP = 0; end
		if not GP then GP = BASEGP; end
		tempTable[count] = {
			[1] = name,
			[2] = CEPGP_roster[name][2], --Class
			[3] = CEPGP_roster[name][3], --Rank
			[4] = CEPGP_roster[name][4], --RankIndex
			[5] = EP,
			[6] = GP,
			[7] = math.floor((tonumber(EP)/tonumber(GP))*100)/100,
			[8] = CEPGP_itemsTable[name][1],
			[9] = CEPGP_itemsTable[name][2]
		};
		count = count + 1;
	end
	tempTable = CEPGP_tSort(tempTable, CEPGP_criteria);
	local kids = {_G["CEPGP_dist_scrollframe_container"]:GetChildren()};
	for _, child in ipairs(kids) do
		child:Hide();
	end
	for i = 1, CEPGP_ntgetn(tempTable) do
		local name = tempTable[i][1];
		if not _G["LootDistButton" .. i] then
			local frame = CreateFrame('Button', "LootDistButton" .. i, _G["CEPGP_dist_scrollframe_container"], "LootDistButtonTemplate");
			if i > 1 then
				_G["LootDistButton" .. i]:SetPoint("TOPLEFT", _G["LootDistButton" .. i-1], "BOTTOMLEFT", 0, -2);
			else
				_G["LootDistButton" .. i]:SetPoint("TOPLEFT", _G["CEPGP_dist_scrollframe_container"], "TOPLEFT", 0, -10);
			end
		end
		if tempTable[i][8] ~= "noitem" or tempTable[i][9] ~= "noitem" then
			if tempTable[i][8] ~= "noitem" then
				local id = tonumber(tempTable[i][8]);
				_, link, _, _, _, _, _, _, _, tex = GetItemInfo(id);
				local iString;
				if not link then
					local item = Item:CreateFromItemID(id);
					item:ContinueOnItemLoad(function()
						_, link, _, _, _, _, _, _, _, tex = GetItemInfo(id)
						iString = CEPGP_getItemString(link);
						local colour = RAID_CLASS_COLORS[string.upper(tempTable[i][2])];
						_G["LootDistButton" .. i]:Show();
						_G["LootDistButton" .. i .. "Info"]:SetText(tempTable[i][1]);
						_G["LootDistButton" .. i .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "Class"]:SetText(tempTable[i][2]);
						_G["LootDistButton" .. i .. "Class"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "Rank"]:SetText(tempTable[i][3]);
						_G["LootDistButton" .. i .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "EP"]:SetText(tempTable[i][5]);
						_G["LootDistButton" .. i .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "GP"]:SetText(tempTable[i][6]);
						_G["LootDistButton" .. i .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "PR"]:SetText(tempTable[i][7]);
						_G["LootDistButton" .. i .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "Tex"]:SetScript('OnLeave', function()
																						GameTooltip:Hide()
																			end);
						_G["LootDistButton" .. i .. "Tex"]:SetScript('OnEnter', function()	
																				GameTooltip:SetOwner(_G["LootDistButton" .. i .. "Tex"], "ANCHOR_TOPLEFT");
																				GameTooltip:SetHyperlink(iString);
																				GameTooltip:Show();
																			end);
						_G["LootDistButton" .. i .. "Icon"]:SetTexture(tex);					
					end);
				else
					iString = CEPGP_getItemString(link);
					local colour = RAID_CLASS_COLORS[string.upper(tempTable[i][2])];
					_G["LootDistButton" .. i]:Show();
					_G["LootDistButton" .. i .. "Info"]:SetText(tempTable[i][1]);
					_G["LootDistButton" .. i .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "Class"]:SetText(tempTable[i][2]);
					_G["LootDistButton" .. i .. "Class"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "Rank"]:SetText(tempTable[i][3]);
					_G["LootDistButton" .. i .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "EP"]:SetText(tempTable[i][5]);
					_G["LootDistButton" .. i .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "GP"]:SetText(tempTable[i][6]);
					_G["LootDistButton" .. i .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "PR"]:SetText(tempTable[i][7]);
					_G["LootDistButton" .. i .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "Tex"]:SetScript('OnLeave', function()
																					GameTooltip:Hide()
																		end);
					_G["LootDistButton" .. i .. "Tex"]:SetScript('OnEnter', function()	
																			GameTooltip:SetOwner(_G["LootDistButton" .. i .. "Tex"], "ANCHOR_TOPLEFT");
																			GameTooltip:SetHyperlink(iString);
																			GameTooltip:Show();
																		end);
					_G["LootDistButton" .. i .. "Icon"]:SetTexture(tex);
				end
			else
				_G["LootDistButton" .. i .. "Tex"]:SetScript('OnEnter', function() end);
				_G["LootDistButton" .. i .. "Icon"]:SetTexture(nil);
			end
			
			if tempTable[i][9] ~= "noitem" then
				local id = tonumber(tempTable[i][9]);
				_, link, _, _, _, _, _, _, _, tex2 = GetItemInfo(id);
				local iString2;
				if not link then
					local item = Item:CreateFromItemID(id);
					item:ContinueOnItemLoad(function()
						_, link, _, _, _, _, _, _, _, tex2 = GetItemInfo(id)
						iString2 = CEPGP_getItemString(link);
						local colour = RAID_CLASS_COLORS[string.upper(tempTable[i][2])];
						_G["LootDistButton" .. i]:Show();
						_G["LootDistButton" .. i .. "Info"]:SetText(tempTable[i][1]);
						_G["LootDistButton" .. i .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "Class"]:SetText(tempTable[i][2]);
						_G["LootDistButton" .. i .. "Class"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "Rank"]:SetText(tempTable[i][3]);
						_G["LootDistButton" .. i .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "EP"]:SetText(tempTable[i][5]);
						_G["LootDistButton" .. i .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "GP"]:SetText(tempTable[i][6]);
						_G["LootDistButton" .. i .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "PR"]:SetText(tempTable[i][7]);
						_G["LootDistButton" .. i .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
						_G["LootDistButton" .. i .. "Tex2"]:SetScript('OnLeave', function()
																				GameTooltip:Hide()
																			end);
						_G["LootDistButton" .. i .. "Tex2"]:SetScript('OnEnter', function()	
														GameTooltip:SetOwner(_G["LootDistButton" .. i .. "Tex2"], "ANCHOR_TOPLEFT")
														GameTooltip:SetHyperlink(iString2)
														GameTooltip:Show()
													end);				
						_G["LootDistButton" .. i .. "Icon2"]:SetTexture(tex2);
					end);
				else
					iString2 = CEPGP_getItemString(link);
					local colour = RAID_CLASS_COLORS[string.upper(tempTable[i][2])];
					_G["LootDistButton" .. i]:Show();
					_G["LootDistButton" .. i .. "Info"]:SetText(tempTable[i][1]);
					_G["LootDistButton" .. i .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "Class"]:SetText(tempTable[i][2]);
					_G["LootDistButton" .. i .. "Class"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "Rank"]:SetText(tempTable[i][3]);
					_G["LootDistButton" .. i .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "EP"]:SetText(tempTable[i][5]);
					_G["LootDistButton" .. i .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "GP"]:SetText(tempTable[i][6]);
					_G["LootDistButton" .. i .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "PR"]:SetText(tempTable[i][7]);
					_G["LootDistButton" .. i .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
					_G["LootDistButton" .. i .. "Tex2"]:SetScript('OnLeave', function()
																			GameTooltip:Hide()
																		end);
					_G["LootDistButton" .. i .. "Tex2"]:SetScript('OnEnter', function()	
													GameTooltip:SetOwner(_G["LootDistButton" .. i .. "Tex2"], "ANCHOR_TOPLEFT")
													GameTooltip:SetHyperlink(iString2)
													GameTooltip:Show()
												end);				
					_G["LootDistButton" .. i .. "Icon2"]:SetTexture(tex2);
				end
			else
				_G["LootDistButton" .. i .. "Tex2"]:SetScript('OnEnter', function() end);
				_G["LootDistButton" .. i .. "Icon2"]:SetTexture(nil);
			end
		else --Recipient has no items in the corresponding slots
			local colour = RAID_CLASS_COLORS[string.upper(tempTable[i][2])];
			_G["LootDistButton" .. i]:Show();
			_G["LootDistButton" .. i .. "Info"]:SetText(tempTable[i][1]);
			_G["LootDistButton" .. i .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["LootDistButton" .. i .. "Class"]:SetText(tempTable[i][2]);
			_G["LootDistButton" .. i .. "Class"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["LootDistButton" .. i .. "Rank"]:SetText(tempTable[i][3]);
			_G["LootDistButton" .. i .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["LootDistButton" .. i .. "EP"]:SetText(tempTable[i][5]);
			_G["LootDistButton" .. i .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["LootDistButton" .. i .. "GP"]:SetText(tempTable[i][6]);
			_G["LootDistButton" .. i .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["LootDistButton" .. i .. "PR"]:SetText(tempTable[i][7]);
			_G["LootDistButton" .. i .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["LootDistButton" .. i .. "Tex"]:SetScript('OnLeave', function()
																			GameTooltip:Hide()
																end);
			_G["LootDistButton" .. i .. "Tex2"]:SetScript('OnLeave', function()
																	GameTooltip:Hide()
																end);
			_G["LootDistButton" .. i .. "Icon"]:SetTexture(nil);
			_G["LootDistButton" .. i .. "Icon2"]:SetTexture(nil);
			_G["LootDistButton" .. i .. "Tex2"]:SetScript('OnEnter', function() end);
			_G["LootDistButton" .. i .. "Icon2"]:SetTexture(nil);
			_G["LootDistButton" .. i .. "Tex"]:SetScript('OnEnter', function() end);
			_G["LootDistButton" .. i .. "Icon"]:SetTexture(nil);
		end
	end
end

function CEPGP_UpdateGuildScrollBar()
	local tempTable = {};
	for name, v in pairs(CEPGP_roster) do
		local EP, GP = CEPGP_getEPGP(v[5], v[1], name)
		if not EP then EP = 0; end
		if not GP then GP = BASEGP; end
		tempTable[v[1]] = {
			[1] = name,
			[2] = v[2], --Class
			[3] = v[3], --Rank
			[4] = v[4], --RankIndex
			[5] = EP,
			[6] = GP,
			[7] = math.floor((tonumber(EP)/tonumber(GP))*100)/100
		};
	end
	tempTable = CEPGP_tSort(tempTable, CEPGP_criteria);
	local kids = {_G["CEPGP_guild_scrollframe_container"]:GetChildren()};
	for _, child in ipairs(kids) do
		child:Hide();
	end
	for i = 1, CEPGP_ntgetn(tempTable) do
		if not _G["GuildButton" .. i] then
			local frame = CreateFrame('Button', "GuildButton" .. i, _G["CEPGP_guild_scrollframe_container"], "GuildButtonTemplate");
			if i > 1 then
				_G["GuildButton" .. i]:SetPoint("TOPLEFT", _G["GuildButton" .. i-1], "BOTTOMLEFT", 0, -2);
			else
				_G["GuildButton" .. i]:SetPoint("TOPLEFT", _G["CEPGP_guild_scrollframe_container"], "TOPLEFT", 0, -10);
			end
		end
		local colour = RAID_CLASS_COLORS[string.upper(tempTable[i][2])];
		_G["GuildButton" .. i]:Show();
		_G["GuildButton" .. i .. "Info"]:SetText(tempTable[i][1]);
		_G["GuildButton" .. i .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["GuildButton" .. i .. "Class"]:SetText(tempTable[i][2]);
		_G["GuildButton" .. i .. "Class"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["GuildButton" .. i .. "Rank"]:SetText(tempTable[i][3]);
		_G["GuildButton" .. i .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["GuildButton" .. i .. "EP"]:SetText(tempTable[i][5]);
		_G["GuildButton" .. i .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["GuildButton" .. i .. "GP"]:SetText(tempTable[i][6]);
		_G["GuildButton" .. i .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["GuildButton" .. i .. "PR"]:SetText(tempTable[i][7]);
		_G["GuildButton" .. i .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
	end
end

function CEPGP_UpdateRaidScrollBar()
	local tempTable = {};
	for i = 1, CEPGP_ntgetn(CEPGP_raidRoster) do
		local name = CEPGP_raidRoster[i];
		local EP, GP = CEPGP_getEPGP(CEPGP_roster[name][5], CEPGP_roster[name][1], name)
		if not EP then EP = 0; end
		if not GP then GP = BASEGP; end
		tempTable[i] = {
			[1] = name,
			[2] = CEPGP_roster[name][2], --Class
			[3] = CEPGP_roster[name][3], --Rank
			[4] = EP,
			[5] = GP,
			[6] = math.floor((tonumber(EP)/tonumber(GP))*100)/100
		};
	end
	tempTable = CEPGP_tSort(tempTable, CEPGP_criteria);
	local kids = {_G["CEPGP_raid_scrollframe_container"]:GetChildren()};
	for _, child in ipairs(kids) do
		child:Hide();
	end
	for i = 1, CEPGP_ntgetn(tempTable) do
		if not _G["RaidButton" .. i] then
			local frame = CreateFrame('Button', "RaidButton" .. i, _G["CEPGP_raid_scrollframe_container"], "RaidButtonTemplate");
			if i > 1 then
				_G["RaidButton" .. i]:SetPoint("TOPLEFT", _G["RaidButton" .. i-1], "BOTTOMLEFT", 0, -2);
			else
				_G["RaidButton" .. i]:SetPoint("TOPLEFT", _G["CEPGP_raid_scrollframe_container"], "TOPLEFT", 0, -10);
			end
		end
		local colour = RAID_CLASS_COLORS[string.upper(tempTable[i][2])];
		_G["RaidButton" .. i]:Show();
		_G["RaidButton" .. i .. "Info"]:SetText(tempTable[i][1]);
		_G["RaidButton" .. i .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["RaidButton" .. i .. "Rank"]:SetText(tempTable[i][3]);
		_G["RaidButton" .. i .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["RaidButton" .. i .. "EP"]:SetText(tempTable[i][4]);
		_G["RaidButton" .. i .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["RaidButton" .. i .. "GP"]:SetText(tempTable[i][5]);
		_G["RaidButton" .. i .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
		_G["RaidButton" .. i .. "PR"]:SetText(tempTable[i][6]);
		_G["RaidButton" .. i .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
	end
end

function CEPGP_initVersionScrollBar()
	CEPGP_groupVersion = CEPGP_tSort(CEPGP_groupVersion, 1);
	for i = 1, CEPGP_ntgetn(CEPGP_roster) do
		if not _G["versionButton" .. i] then
			local frame = CreateFrame('Button', "versionButton" .. i, _G["CEPGP_version_scrollframe_container"], "versionButtonTemplate"); -- Creates version frames if needed
			local colour;
			if not CEPGP_roster[CEPGP_groupVersion[i][1]][2] then
				colour = RAID_CLASS_COLORS["WARRIOR"];
			else
				colour = RAID_CLASS_COLORS[string.upper(CEPGP_roster[CEPGP_groupVersion[i][1]][2])];
			end
			_G["versionButton" .. i .. "name"]:SetText(CEPGP_groupVersion[i][1]);
			_G["versionButton" .. i .. "name"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["versionButton" .. i .. "version"]:SetText(CEPGP_groupVersion[i][2]);
			_G["versionButton" .. i .. "version"]:SetTextColor(colour.r, colour.g, colour.b);
			if i > 1 then
				_G["versionButton" .. i]:SetPoint("TOPLEFT", _G["versionButton" .. i-1], "BOTTOMLEFT", 0, -2);
			else
				_G["versionButton" .. i]:SetPoint("TOPLEFT", _G["CEPGP_version_scrollframe_container"], "TOPLEFT", 5, -6);
			end
		end
	end
end

function CEPGP_UpdateVersionScrollBar()
	if CEPGP_vSearch == "GUILD" then
		CEPGP_groupVersion = CEPGP_tSort(CEPGP_groupVersion, 1);
		for i = 1, GetNumGuildMembers() do
			if not _G["versionButton" .. i] then
				local frame = CreateFrame('Button', "versionButton" .. i, _G["CEPGP_version_scrollframe_container"], "versionButtonTemplate"); -- Creates version frames if needed
				if i > 1 then
					_G["versionButton" .. i]:SetPoint("TOPLEFT", _G["versionButton" .. i-1], "BOTTOMLEFT", 0, -2);
				else
					_G["versionButton" .. i]:SetPoint("TOPLEFT", _G["CEPGP_version_scrollframe_container"], "TOPLEFT", 5, -6);
				end
			end
			_G["versionButton" .. i]:Show();
			local colour;
			if not CEPGP_roster[CEPGP_groupVersion[i][1]][2] then
				colour = RAID_CLASS_COLORS["WARRIOR"];
			else
				colour = RAID_CLASS_COLORS[string.upper(CEPGP_roster[CEPGP_groupVersion[i][1]][2])];
			end
			_G["versionButton" .. i .. "name"]:SetText(CEPGP_groupVersion[i][1]);
			_G["versionButton" .. i .. "name"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["versionButton" .. i .. "version"]:SetText(CEPGP_groupVersion[i][2]);
			_G["versionButton" .. i .. "version"]:SetTextColor(colour.r, colour.g, colour.b);
		end
	else
		local kids = {_G["CEPGP_version_scrollframe_container"]:GetChildren()};
		for _, child in ipairs(kids) do
			child:Hide();
		end
		for i = 1, GetNumGroupMembers() do
			_G["versionButton" .. i]:Show();
			local name, class, version;
			name = GetRaidRosterInfo(i);
			for x = 1, CEPGP_ntgetn(CEPGP_groupVersion) do
				if CEPGP_groupVersion[x][1] == name then
					version = CEPGP_groupVersion[x][2];
					class = CEPGP_groupVersion[x][3];
					break;
				end
			end
			local colour = RAID_CLASS_COLORS[string.upper(class)];
			_G["versionButton" .. i .. "name"]:SetText(name);
			_G["versionButton" .. i .. "name"]:SetTextColor(colour.r, colour.g, colour.b);
			_G["versionButton" .. i .. "version"]:SetText(version);
			_G["versionButton" .. i .. "version"]:SetTextColor(colour.r, colour.g, colour.b);
		end
	end
end

function CEPGP_UpdateOverrideScrollBar()
	if OVERRIDE_INDEX == nil then
		return;
	end
	local x, y;
	local yoffset;
	local t;
	local tSize;
	local item;
	local gp;
	local colour;
	local quality;
	t = {};
	tSize = CEPGP_ntgetn(OVERRIDE_INDEX);
	if tSize == 0 then
		for y = 1, 18, 1 do
			_G["CEPGP_overrideButton" .. y]:Hide();
		end
	end
	local count = 1;
	for k, v in pairs(OVERRIDE_INDEX) do
		t[count] = {
			[1] = k,
			[2] = v
		};
		count = count + 1;
	end
	FauxScrollFrame_Update(CEPGP_overrideScrollFrame, tSize, 18, 15);
	for y = 1, 18, 1 do
		yoffset = y + FauxScrollFrame_GetOffset(CEPGP_overrideScrollFrame);
		if (yoffset <= tSize) then
			if not CEPGP_tContains(t, yoffset, true) then
				_G["CEPGP_overrideButton" .. y]:Hide();
			else
				t2 = t[yoffset];
				item = t2[1];
				gp = t2[2];
				quality = t2[3];
				_G["CEPGP_overrideButton" .. y .. "item"]:SetText(item);
				_G["CEPGP_overrideButton" .. y .. "GP"]:SetText(gp);
				_G["CEPGP_overrideButton" .. y .. "GP"]:SetTextColor(1, 1, 1);
				_G["CEPGP_overrideButton" .. y]:Show();
			end
		else
			_G["CEPGP_overrideButton" .. y]:Hide();
		end
	end
	x, y, yoffset, t, tSize, item, gp, colour, quality = nil;
end

function CEPGP_UpdateTrafficScrollBar()
	if TRAFFIC == nil then
		return;
	end
	local yoffset;
	local tSize;
	tSize = CEPGP_ntgetn(TRAFFIC);
	FauxScrollFrame_Update(trafficScrollFrame, tSize, 18, 15);
	for y = 1, 18, 1 do
		yoffset = y + FauxScrollFrame_GetOffset(trafficScrollFrame);
		if (yoffset <= tSize) then
			local name = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][1];
			local issuer = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][2];
			local action = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][3];
			local EPB = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][4];
			local EPA = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][5];
			local GPB = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][6];
			local GPA = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][7];
			local item = TRAFFIC[CEPGP_ntgetn(TRAFFIC) - (yoffset-1)][8];
			local _, colour = CEPGP_getPlayerClass(name);
			_G["trafficButton" .. y .. "Name"]:SetText(name);
			if colour then
				_G["trafficButton" .. y .. "Name"]:SetTextColor(colour.r, colour.g, colour.b);
			else
				_G["trafficButton" .. y .. "Name"]:SetTextColor(1, 1, 1);
			end
			_, colour = CEPGP_getPlayerClass(issuer);
			_G["trafficButton" .. y .. "Issuer"]:SetText(issuer);
			if colour then
				_G["trafficButton" .. y .. "Issuer"]:SetTextColor(colour.r, colour.g, colour.b);
			else
				_G["trafficButton" .. y .. "Issuer"]:SetTextColor(1, 1, 1);
			end
			if item then
				_G["trafficButton" .. y .. "ItemName"]:SetText(item);
				_G["trafficButton" .. y .. "ItemName"]:Show();
				_G["trafficButton" .. y .. "Item"]:SetScript('OnClick', function() SetItemRef(tostring(CEPGP_getItemString(item))) end);
			else
				_G["trafficButton" .. y .. "ItemName"]:SetText("");
				_G["trafficButton" .. y .. "ItemName"]:Hide();
				_G["trafficButton" .. y .. "Item"]:SetScript('OnClick', function() end);
			end
			_G["trafficButton" .. y .. "Action"]:SetText(action);
			_G["trafficButton" .. y .. "Action"]:SetTextColor(1, 1, 1);
			_G["trafficButton" .. y .. "EPBefore"]:SetText(EPB);
			_G["trafficButton" .. y .. "EPBefore"]:SetTextColor(1, 1, 1);
			_G["trafficButton" .. y .. "EPAfter"]:SetText(EPA);
			_G["trafficButton" .. y .. "EPAfter"]:SetTextColor(1, 1, 1);
			_G["trafficButton" .. y .. "GPBefore"]:SetText(GPB);
			_G["trafficButton" .. y .. "GPBefore"]:SetTextColor(1, 1, 1);
			_G["trafficButton" .. y .. "GPAfter"]:SetText(GPA);
			_G["trafficButton" .. y .. "GPAfter"]:SetTextColor(1, 1, 1);
			_G["trafficButton" .. y]:Show();
			name, issuer, action, EPB, EPA, GPB, GPA, item = nil;
		else
			_G["trafficButton" .. y]:Hide();
		end
	end
	yoffset, tSize = nil;
end

function CEPGP_UpdateStandbyScrollBar()
	local x, y;
	local yoffset;
	local t;
	local tSize;
	local name;
	local class;
	local rank;
	local EP;
	local GP;
	local offNote;
	local colour;
	t = {};
	tSize = CEPGP_ntgetn(CEPGP_standbyRoster);
	for x = 1, tSize do
		name = CEPGP_standbyRoster[x];
		index, class, rank, rankIndex, offNote = CEPGP_getGuildInfo(name);
		EP, GP = CEPGP_getEPGP(offNote)
		t[x] = {
			[1] = name,
			[2] = class,
			[3] = rank,
			[4] = rankIndex,
			[5] = EP,
			[6] = GP,
			[7] = math.floor((EP/GP)*100)/100,
			[8] = 0
		}
	end
	t = CEPGP_tSort(t, CEPGP_criteria)
	FauxScrollFrame_Update(CEPGP_StandbyScrollFrame, tSize, 18, 15);
	for y = 1, 18, 1 do
		yoffset = y + FauxScrollFrame_GetOffset(CEPGP_StandbyScrollFrame);
		if (yoffset <= tSize) then
			if not CEPGP_tContains(t, yoffset, true) then
				_G["CEPGP_StandbyButton" .. y]:Hide();
			else
				name = t[yoffset][1]
				class = t[yoffset][2];
				rank = t[yoffset][3];
				EP = t[yoffset][5];
				GP = t[yoffset][6];
				PR = t[yoffset][7];
				if class then
					colour = RAID_CLASS_COLORS[string.upper(class)];
				else
					colour = RAID_CLASS_COLORS["WARRIOR"];
				end
				if not colour then colour = RAID_CLASS_COLORS["WARRIOR"]; end
				_G["CEPGP_StandbyButton" .. y .. "Info"]:SetText(name);
				_G["CEPGP_StandbyButton" .. y .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
				_G["CEPGP_StandbyButton" .. y .. "Class"]:SetText(class);
				_G["CEPGP_StandbyButton" .. y .. "Class"]:SetTextColor(colour.r, colour.g, colour.b);
				_G["CEPGP_StandbyButton" .. y .. "Rank"]:SetText(rank);
				_G["CEPGP_StandbyButton" .. y .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
				_G["CEPGP_StandbyButton" .. y .. "EP"]:SetText(EP);
				_G["CEPGP_StandbyButton" .. y .. "EP"]:SetTextColor(colour.r, colour.g, colour.b);
				_G["CEPGP_StandbyButton" .. y .. "GP"]:SetText(GP);
				_G["CEPGP_StandbyButton" .. y .. "GP"]:SetTextColor(colour.r, colour.g, colour.b);
				_G["CEPGP_StandbyButton" .. y .. "PR"]:SetText(PR);
				_G["CEPGP_StandbyButton" .. y .. "PR"]:SetTextColor(colour.r, colour.g, colour.b);
				_G["CEPGP_StandbyButton" .. y]:Show();
			end
		else
			_G["CEPGP_StandbyButton" .. y]:Hide();
		end
	end
	x, y, yoffset, t, tSize, name, class, rank, EP, GP, offNote, colour = nil;
end

function CEPGP_UpdateAttendanceScrollBar()
	local x, y;
	local yoffset;
	local t;
	local tSize;
	local name;
	local class;
	local rank;
	local colour;
	local total;
	local week;
	local fn;
	local month;
	local twoMon;
	local ThreeMon;
	local avg; --average attendance
	t = {};
	if snapshot then
		tSize = CEPGP_ntgetn(CEPGP_raid_logs[CEPGP_snapshot]);
	else
		tSize = CEPGP_ntgetn(CEPGP_roster);
	end
	for x = 1, tSize do
		if CEPGP_snapshot then
			name = CEPGP_raid_logs[CEPGP_snapshot][x+1];
		else
			name = CEPGP_indexToName(x);
		end
		index, class, rank = CEPGP_getGuildInfo(name);
		if not index then
			rank = "Non-Guild Member"
		end
		total, week, fn, month, twoMon, ThreeMon = CEPGP_calcAttendance(name);
		t[x] = {
			[1] = name,
			[2] = class,
			[3] = rank,
			[4] = total,
			[5] = week,
			[6] = fn,
			[7] = month,
			[8] = twoMon,
			[9] = ThreeMon
		}
	end
	t = CEPGP_tSort(t, 1)
	FauxScrollFrame_Update(AttendanceScrollFrame, tSize, 18, 15);
	for y = 1, 18, 1 do
		yoffset = y + FauxScrollFrame_GetOffset(AttendanceScrollFrame);
		if (yoffset <= tSize) then
			if not CEPGP_tContains(t, yoffset, true) then
				_G["AttendanceButton" .. y]:Hide();
			else
				name = t[yoffset][1];
				class = t[yoffset][2];
				rank = t[yoffset][3];
				total = t[yoffset][4];
				week = t[yoffset][5];
				fn = t[yoffset][6];
				month = t[yoffset][7];
				twoMon = t[yoffset][8];
				threeMon = t[yoffset][9];
				avg = total/CEPGP_ntgetn(CEPGP_raid_logs);
				avg = math.floor(avg*100)/100;
				if class then
					colour = RAID_CLASS_COLORS[string.upper(class)];
				else
					colour = RAID_CLASS_COLORS["WARRIOR"];
				end
				if not colour then colour = RAID_CLASS_COLORS["WARRIOR"]; end
				_G["AttendanceButton" .. y .. "Info"]:SetText(name);
				_G["AttendanceButton" .. y .. "Info"]:SetTextColor(colour.r, colour.g, colour.b);
				_G["AttendanceButton" .. y .. "Rank"]:SetText(rank);
				_G["AttendanceButton" .. y .. "Rank"]:SetTextColor(colour.r, colour.g, colour.b);
				
				_G["AttendanceButton" .. y]:Show();
				
				if CEPGP_snapshot then
					_G["AttendanceButton" .. y .. "Total"]:Hide();
					_G["AttendanceButton" .. y .. "Int7"]:Hide();
					_G["AttendanceButton" .. y .. "Int14"]:Hide();
					_G["AttendanceButton" .. y .. "Int30"]:Hide();
					_G["AttendanceButton" .. y .. "Int60"]:Hide();
					_G["AttendanceButton" .. y .. "Int90"]:Hide();
				else
					local totals = {CEPGP_calcAttIntervals()};
					_G["AttendanceButton" .. y .. "Total"]:SetText(total .. " (" .. avg*100 .. "%)");
					_G["AttendanceButton" .. y .. "Total"]:SetTextColor(1-avg,avg/1,0);
					_G["AttendanceButton" .. y .. "Int7"]:SetText(week .. "/" .. totals[1]);
					_G["AttendanceButton" .. y .. "Int7"]:SetTextColor(1-(week/totals[1]), (week/totals[1])/1, 0);
					_G["AttendanceButton" .. y .. "Int14"]:SetText(fn .. "/" .. totals[2]);
					_G["AttendanceButton" .. y .. "Int14"]:SetTextColor(1-(week/totals[2]), (week/totals[2])/1, 0);
					_G["AttendanceButton" .. y .. "Int30"]:SetText(month .. "/" .. totals[3]);
					_G["AttendanceButton" .. y .. "Int30"]:SetTextColor(1-(week/totals[3]), (week/totals[3])/1, 0);
					_G["AttendanceButton" .. y .. "Int60"]:SetText(twoMon .. "/" .. totals[4]);
					_G["AttendanceButton" .. y .. "Int60"]:SetTextColor(1-(week/totals[4]), (week/totals[4])/1, 0);
					_G["AttendanceButton" .. y .. "Int90"]:SetText(threeMon .. "/" .. totals[5]);
					_G["AttendanceButton" .. y .. "Int90"]:SetTextColor(1-(week/totals[5]), (week/totals[5])/1, 0);
					_G["AttendanceButton" .. y .. "Total"]:Show();
					_G["AttendanceButton" .. y .. "Int7"]:Show();
					_G["AttendanceButton" .. y .. "Int14"]:Show();
					_G["AttendanceButton" .. y .. "Int30"]:Show();
					_G["AttendanceButton" .. y .. "Int60"]:Show();
					_G["AttendanceButton" .. y .. "Int90"]:Show();
				end
			end
		else
			_G["AttendanceButton" .. y]:Hide();
		end
	end
	_G["CEPGP_attendance_header_total"]:SetText("Total Snapshots Recorded: " .. CEPGP_ntgetn(CEPGP_raid_logs));
	x, y, yoffset, t, tSize, name, class, rank, colour, total, week, fn, month, twoMon, ThreeMon, avg = nil;
end
--[[

****************************************************************************************
Chuck Norris Facts

$Date$
$Rev$

By Ackis and Lothaer

****************************************************************************************

Original by Lothaer, modified version by Ackis and then the two versions merged together.

****************************************************************************************

]]

CNF 		= LibStub("AceAddon-3.0"):NewAddon("Chuck Norris Facts", "AceConsole-3.0")

local addon = CNF

local random = math.random
local GetGameTime = GetGameTime

-- Spam protection
local lastminute

-- Returns configuration options for CNF

local function giveCNFOptions()

	local command_options = {
	    type = "group",
	    args =
		{
			header1 =
			{
				order = 1,
				type = "header",
				name = "",
			},
			displayself = 
			{
				type = "execute",
				name = "Display Fact (Self)",
				desc = "Displays a random Chuck Norris fact to yourself.",
				func = function(info) addon:Print(addon:GetCNF()) end,
				order = 5,
			},
			displaysay = 
			{
				type = "execute",
				name = "Display Fact (Say)",
				desc = "Displays a random Chuck Norris fact in say.",
				func = function(info) addon:DisplayCNF("SAY") end,
				order = 6,
			},
			displayyell = 
			{
				type = "execute",
				name = "Display Fact (Yell)",
				desc = "Displays a random Chuck Norris fact in yell.",
				func = function(info) addon:DisplayCNF("YELL") end,
				order = 7,
			},
			displayguild = 
			{
				type = "execute",
				name = "Display Fact (Guild)",
				desc = "Displays a random Chuck Norris fact in guild chat.",
				func = function(info) addon:DisplayCNF("GUILD") end,
				order = 10,
			},
			displayofficer = 
			{
				type = "execute",
				name = "Display Fact (Officer)",
				desc = "Displays a random Chuck Norris fact in officer chat.",
				func = function(info) addon:DisplayCNF("OFFICER") end,
				order = 11,
			},
			displayparty = 
			{
				type = "execute",
				name = "Display Fact (Party)",
				desc = "Displays a random Chuck Norris fact in party chat.",
				func = function(info) addon:DisplayCNF("PARTY") end,
				order = 20,
			},
			displayraid = 
			{
				type = "execute",
				name = "Display Fact (Raid)",
				desc = "Displays a random Chuck Norris fact in raid chat.",
				func = function(info) addon:DisplayCNF("RAID") end,
				order = 21,
			},
			displayraidwarning = 
			{
				type = "execute",
				name = "Display Fact (Raid Warning)",
				desc = "Displays a random Chuck Norris fact in raid warning chat.",
				func = function(info) addon:DisplayCNF("RAIDWARN") end,
				order = 21,
			},
			displaybg = 
			{
				type = "execute",
				name = "Display Fact (Battleground)",
				desc = "Displays a random Chuck Norris fact in battleground chat.",
				func = function(info) addon:DisplayCNF("BG") end,
				order = 30,
			},
		}
	}

	return command_options

end

-- Loaded when addon is initialized

function addon:OnInitialize()

	local AceConfigReg = LibStub("AceConfigRegistry-3.0")
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	-- Create the options with Ace3
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Chuck Norris Facts",giveCNFOptions,"Chuck Norris Facts")

	-- Add the options to blizzard frame (add them backwards so they show up in the proper order
	self.optionsFrame = AceConfigDialog:AddToBlizOptions("Chuck Norris Facts","Chuck Norris Facts")
	self.optionsFrame["About"] = LibStub("LibAboutPanel").new("Chuck Norris Facts", "CNF")

	self:RegisterChatCommand("chuck", "ChatCommandHandler")
	self:RegisterChatCommand("cnf", "ChatCommandHandler")

end

-- Gets a random quote from the database and returns it.

function addon:GetCNF()

	return addon.CNFDB[random(#addon.CNFDB)]

end

-- Outputs a chuck norris fact to the specified channel.  Does spam checking

function addon:DisplayCNF(channel,target)

	local _,minute = GetGameTime()
	-- If there is 1 or more minutes since the last time we did this or if it's the first time
	if ((not lastminute) or ((minute - lastminute) > 0) or (abs((minute - lastminute)) > 0)) then
		-- Update the time
		lastminute = minute
		if (target) then
			SendChatMessage(self:GetCNF(), channel, nil, target)
		else
			SendChatMessage(self:GetCNF(), channel)
		end
	else
		self:Print("You have sent a Chuck Norris Fact to an external source within the last minute, please wait before doing it again.")
	end

end

-- Prints out the command line options

function addon:PrintCNFOptions()

	self:Print("|cffffff00 Usage:")
	self:Print("   Type /Chuck and then the channel that you wish to post in")
	self:Print("   Self - Send output to your chat window")
	self:Print("   G or Guild - Send output to guild chat")
	self:Print("   R or Raid")
	self:Print("   S or Say")
	self:Print("   Y or Yell")
	self:Print("   P or Party")
	self:Print("   O or Officer")
	self:Print("   RW or Raidwarn")
	self:Print("   BG or Battleground")
	--self:Print("   W or Whisper <PlayerName>")
	self:Print("   <ChannelNumber> - such as 1,2, 3, etc")

end

-- Slash command handler

function addon:ChatCommandHandler(arg)

	local input = string.lower(arg)

	if (not input) or (input and input:trim() == "") then
		self:PrintCNFOptions()
	elseif (input == "self") then
		self:Print(self:GetCNF())
	elseif (input == "say") or (input == "s") then
		addon:DisplayCNF("SAY")
	elseif (input == "whisper") or (input == "w") then
		self:Print("NYI - Ticket made already")
		--addon:DisplayCNF("WHISPER", input)
	elseif (input == "yell") or (input == "y") then
		addon:DisplayCNF("YELL")
	elseif (input == "1") or (input == "2") or (input == "3") or (input == "4") or (input == "5") or (input == "6") or (input == "7") or (input == "8") or (input == "9") then
		addon:DisplayCNF("CHANNEL", input)
	elseif (input == "guild") or (input == "g") then
		addon:DisplayCNF("GUILD")
	elseif (input == "officer") or (input == "o") then
		addon:DisplayCNF("OFFICER")
	elseif (input == "party") or (input == "p") then
		addon:DisplayCNF("PARTY")
	elseif (input == "raid") or (input == "r") then
		addon:DisplayCNF("RAID")
	elseif (input == "raidwarn") or (input == "rw") then
		addon:DisplayCNF("RAID_WARNING")
	elseif (input == "battleground") or (input == "bg") then
		addon:DisplayCNF("BATTLEGROUND")
	end

end

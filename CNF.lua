--[[

****************************************************************************************
Chuck Norris Facts

File date: @file-date-iso@ 
Project version: @project-version@

By Ackis and Lothaer

****************************************************************************************

Original by Lothaer, modified version by Ackis and then the two versions merged together.

****************************************************************************************

]]

--- **CNF** 
-- @class file
-- @name IHML.lua
-- @release 3.31

local MODNAME = "Chuck Norris Facts"

CNF	= LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceConsole-3.0")

local addon = CNF

local random = math.random
local lower = string.lower
local GetGameTime = GetGameTime

if (not LibStub:GetLibrary("AceLocale-3.0", true)) then
	addon:Print(format("%s is missing.  Addon cannot run.","AceLocale-3.0"))
	--@debug@
	addon:Print("You are using a git version of ARL. All libraries manually to esnure that it works properly.")
	--@end-debug@
	CNF = nil
	return
end

local L	= LibStub("AceLocale-3.0"):GetLocale(MODNAME)

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
				name = L["Display Fact (Self)"],
				desc = L["SELF_LONG"],
				func = function(info) addon:Print(addon:GetCNF()) end,
				order = 5,
			},
			displaysay = 
			{
				type = "execute",
				name = L["Display Fact (Say)"],
				desc = L["SAY_LONG"],
				func = function(info) addon:DisplayCNF("SAY") end,
				order = 6,
			},
			displayyell = 
			{
				type = "execute",
				name = L["Display Fact (Yell)"],
				desc = L["YELL_LONG"],
				func = function(info) addon:DisplayCNF("YELL") end,
				order = 7,
			},
			displayguild = 
			{
				type = "execute",
				name = L["Display Fact (Guild)"],
				desc = L["GUILD_LONG"],
				func = function(info) addon:DisplayCNF("GUILD") end,
				order = 10,
			},
			displayofficer = 
			{
				type = "execute",
				name = L["Display Fact (Officer)"],
				desc = L["OFFICER_LONG"],
				func = function(info) addon:DisplayCNF("OFFICER") end,
				order = 11,
			},
			displayparty = 
			{
				type = "execute",
				name = L["Display Fact (Party)"],
				desc = L["PARTY_LONG"],
				func = function(info) addon:DisplayCNF("PARTY") end,
				order = 20,
			},
			displayraid = 
			{
				type = "execute",
				name = L["Display Fact (Raid)"],
				desc = L["RAID_LONG"],
				func = function(info) addon:DisplayCNF("RAID") end,
				order = 21,
			},
			displayraidwarning = 
			{
				type = "execute",
				name = L["Display Fact (Raid Warning)"],
				desc = L["RAIDWARNING_LONG"],
				func = function(info) addon:DisplayCNF("RAIDWARN") end,
				order = 21,
			},
			displaybg = 
			{
				type = "execute",
				name = L["Display Fact (Battleground)"],
				desc = L["BATTLEGROUND_LONG"],
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
	LibStub("AceConfig-3.0"):RegisterOptionsTable(MODNAME,giveCNFOptions,MODNAME)

	-- Add the options to blizzard frame (add them backwards so they show up in the proper order
	self.optionsFrame = AceConfigDialog:AddToBlizOptions(MODNAME,MODNAME)

	if LibStub:GetLibrary("LibAboutPanel", true) then
		self.optionsFrame["About"] = LibStub("LibAboutPanel").new(MODNAME, "CNF")
	else
		self:Print("Lib AboutPanel not loaded.")
	end

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
		self:Print(L["SPAM"])
	end

end

-- Slash command handler

function addon:ChatCommandHandler(arg)

	local input = lower(arg)

	if (not input) or (input and input:trim() == "") then
		self:Print(L["COMMAND_OPTIONS"])
	elseif (input == L["self"]) then
		self:Print(self:GetCNF())
	elseif (input == L["say"]) or (input == "s") then
		addon:DisplayCNF("SAY")
	elseif (input == L["yell"]) or (input == "y") then
		addon:DisplayCNF("YELL")
	elseif (input == "1") or (input == "2") or (input == "3") or (input == "4") or (input == "5") or (input == "6") or (input == "7") or (input == "8") or (input == "9") then
		addon:DisplayCNF("CHANNEL", input)
	elseif (input == L["guild"]) or (input == "g") then
		addon:DisplayCNF("GUILD")
	elseif (input == L["officer"]) or (input == "o") then
		addon:DisplayCNF("OFFICER")
	elseif (input == L["party"]) or (input == "p") then
		addon:DisplayCNF("PARTY")
	elseif (input == L["raid"]) or (input == "r") then
		addon:DisplayCNF("RAID")
	elseif (input == L["raidwarn"]) or (input == "rw") then
		addon:DisplayCNF("RAID_WARNING")
	elseif (input == L["battleground"]) or (input == "bg") then
		addon:DisplayCNF("BATTLEGROUND")
	else
		local first, second = string.match(input, "([a-z0-9]+)[ ]?(.*)")
		if (first == L["whisper"]) or (first == "w") then
			addon:DisplayCNF("WHISPER", second)
		else
			self:Print(L["COMMAND_OPTIONS"])
		end
	end

end

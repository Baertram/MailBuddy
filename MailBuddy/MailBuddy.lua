--The addon table/array
MailBuddy = MailBuddy or {}

local addonVars = MailBuddy.addonVars


------------------------------------------------------------------------------------------------------------------------
--Addon load
EVENT_MANAGER:RegisterForEvent(addonVars.name, EVENT_ADD_ON_LOADED, MailBuddy.Initialize) -->See file src/MailBuddy_Events.lua

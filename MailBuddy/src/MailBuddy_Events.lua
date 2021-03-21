MailBuddy = MailBuddy or {}

local addonVars = MailBuddy.addonVars

local function eventMailSend()
    zo_callLater(function()
        MailBuddy.SetRememberedMailData()
    end, 150)
end

local function eventPlayerActivatedCallback(event, firstCall)
   -- zo_callLater(MailBuddyGetMail(), 2500)
    EVENT_MANAGER:UnregisterForEvent(addonVars.name, event)

    --Update the anchors and positions of the recipients and subjects list
    MailBuddy.ShowBox("recipients", false, false, false, false)
    MailBuddy.ShowBox("subjects", false, false, false, false)

   --Add new recipient and new subject into an edit group and add autocomplete for the recipient name
    local editControlGroup = ZO_EditControlGroup:New()
    MailBuddy.autoCompleteRecipient = ZO_AutoComplete:New(
            MailBuddy_MailSendRecipientsBoxEditNewRecipient,
            { AUTO_COMPLETE_FLAG_ALL },
            nil,
            AUTO_COMPLETION_ONLINE_OR_OFFLINE,
            MAX_AUTO_COMPLETION_RESULTS
    )
    editControlGroup:AddEditControl(MailBuddy_MailSendRecipientsBoxEditNewRecipient, MailBuddy.autoCompleteRecipient)
    editControlGroup:AddEditControl(MailBuddy_MailSendSubjectsBoxEditNewSubject, nil)
end



local function otherAddonsCheck(addOnName)
    --MailR
    MailBuddy.otherAddons.isMailRActive = ((addOnName ~= nil and addOnName ~= "" and addOnName == "MailR") or
                                          (MailR ~= nil)) or false
end

------------------------------------------------------------------------------------------------------------------------

--Initialization of this addon
function MailBuddy.Initialize(eventCode, addOnName)
    if addOnName ~= addonVars.name then return end

    --Check for other addons
    otherAddonsCheck(addOnName)

    --Unregister the addon loaded event again so it won't be called twice!
    EVENT_MANAGER:UnregisterForEvent(addonVars.name, eventCode)

    --Load the saved variables etc.
    MailBuddy.LoadUserSettings()

    --Load localization file
    MailBuddy.preventerVars.KeyBindingTexts = false
    MailBuddy.Localization()
    --Create the text for the keybinding
    ZO_CreateStringId("SI_BINDING_NAME_MAILBUDDY_COPY", MailBuddy.GetLocText("SI_BINDING_NAME_MAILBUDDY_COPY", true))

    --Build the settings panel
    MailBuddy.CreateLAMPanel()

    --Select the current page at recipients and subjects (from the saved variables)
    MailBuddy.GetPage("recipients", 0, false)
    MailBuddy.GetPage("subjects", 0, false)

    --Load the hooks etc. into friends-/guild lists and mail UI
    MailBuddy.LoadHooks()

    --Preset the standard mail recipient and subject from the settings after mail was send/not sent (error)
    EVENT_MANAGER:RegisterForEvent(addonVars.name, EVENT_MAIL_SEND_SUCCESS, eventMailSend)
    EVENT_MANAGER:RegisterForEvent(addonVars.name, EVENT_MAIL_SEND_FAILED,  eventMailSend)

    EVENT_MANAGER:RegisterForEvent(addonVars.name, EVENT_PLAYER_ACTIVATED,  eventPlayerActivatedCallback)

    -- Registers addon to loadedAddon library
    MailBuddy.LIBLA:RegisterAddon(addonVars.name, addonVars.addonVersionOptionsNumber)
end
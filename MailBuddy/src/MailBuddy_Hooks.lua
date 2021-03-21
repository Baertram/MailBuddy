MailBuddy = MailBuddy or {}

------------------------------------------------------------------------------------------------------------------------
--Constants for the functions below
local friendsList = ZO_KeyboardFriendsList
local guildRoster = ZO_GuildRoster

------------------------------------------------------------------------------------------------------------------------
--Add button to the friends list to show recipients list
local function AddButtonToFriendsList()
    if friendsList ~= nil and not friendsList:IsHidden() then
        local settings = MailBuddy.settingsVars.settings
        --Automatically hide the recipients box?
        local doHide = settings.automatism.hide["RecipientsBox"]
        local doOpen = settings.lastShown.recipients["FriendsList"]
        if doOpen == false then
            doHide = true
        end
        MailBuddy.ShowBox("recipients", false, doHide, doOpen, false, friendsList, -16, 0)

        --Add a button to the friends list, at top left corner near the "online status icon" to show/hide MailBuddy
        if ZO_DisplayNameStatusSelectedItem ~= nil then
            if MailBuddy_FriendsToggleButton == nil then
                --Create the button control at the parent
                local button = WINDOW_MANAGER:CreateControl("MailBuddy_FriendsToggleButton", friendsList, CT_BUTTON)
                if button ~= nil then
                    --Set the button's size
                    button:SetDimensions(24, 24)
                    --Align the button
                    --SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY)
                    button:SetAnchor(TOPLEFT, ZO_DisplayNameStatusSelectedItem, TOPLEFT, -20, 5)
                    --Texture
                    local texture
                    --Create the texture for the button to hold the image
                    texture = WINDOW_MANAGER:CreateControl("MailBuddy_FriendsToggleButtonTexture", button, CT_TEXTURE)
                    texture:SetAnchorFill()
                    --Set the texture for normale state now
                    texture:SetTexture("EsoUI/Art/Inventory/inventory_tabIcon_quickslot_up.dds")
                    --Do we have seperate textures for the button states?
                    button.upTexture 	  = "EsoUI/Art/Inventory/inventory_tabIcon_quickslot_up.dds"
                    button.downTexture 	  = "EsoUI/Art/Inventory/inventory_tabIcon_quickslot_over.dds"
                    button.clickedTexture = "EsoUI/Art/Inventory/inventory_tabIcon_quickslot_down.dds"
                    button:SetNormalTexture(button.upTexture)
                    button:SetMouseOverTexture(button.downTexture)
                    button:SetPressedMouseOverTexture(button.clickedTexture)
                    button:SetHandler("OnMouseEnter", function(self)
                        local mailBuddyToggleButtonTooltip
                        if MailBuddy.recipientsBox:IsHidden() then
                            mailBuddyToggleButtonTooltip = "Show MailBuddy"
                        else
                            mailBuddyToggleButtonTooltip = "Hide MailBuddy"
                        end
                        ZO_Tooltips_ShowTextTooltip(button, LEFT, mailBuddyToggleButtonTooltip)
                    end)
                    button:SetHandler("OnMouseExit", function(self)
                        ZO_Tooltips_HideTextTooltip()
                    end)
                    --Set the callback function of the button
                    button:SetHandler("OnClicked", function(...)
                        ZO_Tooltips_HideTextTooltip()
                        MailBuddy.ShowBox("recipients", true, false, false, true, friendsList, -16, 0)
                    end)
                    button:SetHidden(false)
                end
            end
        end
    end
end

--Add button to the guild roster to show recipients list
local function AddButtonToGuildRoster()
    if guildRoster ~= nil and not guildRoster:IsHidden() then
        local settings = MailBuddy.settingsVars.settings

        --Automatically hide the recipients box?
        local doHide = settings.automatism.hide["RecipientsBox"]
        local doOpen = settings.lastShown.recipients["GuildRoster"]
        if doOpen == false then
            doHide = true
        end
        MailBuddy.ShowBox("recipients", false, doHide, doOpen, false, guildRoster, -16, 0)

        --Add a button to the guild roster, at top left corner near the "online status icon" to show/hide MailBuddy
        if ZO_DisplayNameStatusSelectedItem ~= nil then
            if MailBuddy_GuildRosterToggleButton == nil then
                --Create the button control at the parent
                local button = WINDOW_MANAGER:CreateControl("MailBuddy_GuildRosterToggleButton", guildRoster, CT_BUTTON)
                if button ~= nil then
                    --Set the button's size
                    button:SetDimensions(24, 24)
                    --Align the button
                    --SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY)
                    button:SetAnchor(TOPLEFT, ZO_DisplayNameStatusSelectedItem, TOPLEFT, -20, 5)
                    --Texture
                    local texture
                    --Create the texture for the button to hold the image
                    texture = WINDOW_MANAGER:CreateControl("MailBuddy_GuildRosterToggleButtonTexture", button, CT_TEXTURE)
                    texture:SetAnchorFill()
                    --Set the texture for normale state now
                    texture:SetTexture("EsoUI/Art/Inventory/inventory_tabIcon_quickslot_up.dds")
                    --Do we have seperate textures for the button states?
                    button.upTexture 	  = "EsoUI/Art/Inventory/inventory_tabIcon_quickslot_up.dds"
                    button.downTexture 	  = "EsoUI/Art/Inventory/inventory_tabIcon_quickslot_over.dds"
                    button.clickedTexture = "EsoUI/Art/Inventory/inventory_tabIcon_quickslot_down.dds"
                    button:SetNormalTexture(button.upTexture)
                    button:SetMouseOverTexture(button.downTexture)
                    button:SetPressedMouseOverTexture(button.clickedTexture)
                    button:SetHandler("OnMouseEnter", function(self)
                        local mailBuddyToggleButtonTooltip
                        if MailBuddy.recipientsBox:IsHidden() then
                            mailBuddyToggleButtonTooltip = "Show MailBuddy"
                        else
                            mailBuddyToggleButtonTooltip = "Hide MailBuddy"
                        end
                        ZO_Tooltips_ShowTextTooltip(button, LEFT, mailBuddyToggleButtonTooltip)
                    end)
                    button:SetHandler("OnMouseExit", function(self)
                        ZO_Tooltips_HideTextTooltip()
                    end)
                    --Set the callback function of the button
                    button:SetHandler("OnClicked", function(...)
                        ZO_Tooltips_HideTextTooltip()
                        MailBuddy.ShowBox("recipients", true, false, false, true, guildRoster, -16, 0)
                    end)
                    button:SetHidden(false)
                end
            end
        end
    end
end


local function GetMouseOverFriends(mouseOverControl)
    if (not friendsList:IsHidden()) then
            KEYBIND_STRIP:AddKeybindButtonGroup(MailBuddy.keystripDefCopyFriend)
    else
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyFriend)
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyGuildMember)
    end
end

local function GetMouseOverGuildMembers(mouseOverControl)
    if (not guildRoster:IsHidden()) then
        KEYBIND_STRIP:AddKeybindButtonGroup(MailBuddy.keystripDefCopyGuildMember)
    else
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyFriend)
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyGuildMember)
    end
end



------------------------------------------------------------------------------------------------------------------------
function MailBuddy.LoadHooks()
    local settings = MailBuddy.settingsVars.settings

    --New after patch 1.6
    --======== FRIENDS LIST ================================================================
    --Register a callback function for the friends list scene
    FRIENDS_LIST_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   newState == SCENE_SHOWN then
            AddButtonToFriendsList()

        elseif newState == SCENE_HIDING then
            settings.lastShown.recipients["FriendsList"] = not MailBuddy.recipientsBox:IsHidden()
        end
    end)
    --PreHook the MouseEnter and Exit functions for the friends list rows + names in the rows
    ZO_PreHook("ZO_FriendsListRowDisplayName_OnMouseEnter", function(control)
        --d("Mouse enter friend name: " .. control:GetName())
       GetMouseOverFriends(control)
    end)
    ZO_PreHook("ZO_FriendsListRowDisplayName_OnMouseExit", function(control)
        --d("Mouse exit friend name: " .. control:GetName())
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyFriend)
    end)
    ZO_PreHook("ZO_FriendsListRow_OnMouseExit", function(control)
        --d("Mouse exit friends row: " .. control:GetName())
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyFriend)
    end)

    --======== GUILD ROSTER ================================================================
    --Register a callback function for the guild roster scene
    GUILD_ROSTER_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   newState == SCENE_SHOWN then
            AddButtonToGuildRoster()

        elseif newState == SCENE_HIDING then
            settings.lastShown.recipients["GuildRoster"] = not MailBuddy.recipientsBox:IsHidden()
        end
    end)

    --PreHook the MouseEnter and Exit functions for the guild roster list rows + names in the rows
    ZO_PreHook("ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter", function(control)
       --d("Mouse enter guild roster name: " .. control:GetName())
       GetMouseOverGuildMembers(control)
    end)
    ZO_PreHook("ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit", function(control)
        --d("Mouse exit guild roster  name: " .. control:GetName())
    --TODO: QuadroTony Fehlermeldung beim Scrollen des Guild Member Rosters -> http://www.esoui.com/forums/showthread.php?p=28034#post28034
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyGuildMember)
    end)
    ZO_PreHook("ZO_KeyboardGuildRosterRow_OnMouseExit", function(control)
        --d("Mouse exit guild roster row: " .. control:GetName())
        KEYBIND_STRIP:RemoveKeybindButtonGroup(MailBuddy.keystripDefCopyGuildMember)
    end)


    --======== MAIL INBOX ================================================================
    --Register a callback function for the mail inbox scene
    MAIL_INBOX_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   	   newState == SCENE_SHOWN then
            --Update the total number of mails label
            MailBuddy.UpdateNumTotalMails()
        end
    end)

    --PreHook the mail inbox update functions so the number of current mails at the label will be updated too
    ZO_PreHook(MAIL_INBOX, "OnMailNumUnreadChanged", function(...)
        if SCENE_MANAGER:IsShowing("mailInbox") then
            --Update the total number of mails label
            MailBuddy.UpdateNumTotalMails()
        end
    end)
    ZO_PreHook(MAIL_INBOX, "OnMailRemoved", function(...)
        if SCENE_MANAGER:IsShowing("mailInbox") then
            --Update the total number of mails label
            MailBuddy.UpdateNumTotalMails()
        end
    end)

    --======== MAIL SEND ================================================================
    --Register a callback function for the mail send scene
    MAIL_SEND_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   	   newState == SCENE_SHOWING then
            --Hide the UI elements for the recipients and subjects lists if enabled in the settings
            if settings.automatism.hide["RecipientsBox"] then
                MailBuddy.ShowBox("recipients", false, true, false, false)
            else
                local doClose = false
                local doOpen = settings.lastShown.recipients["MailSend"]
                if doOpen == false then doClose = true end
                MailBuddy.ShowBox("recipients", false, doClose, doOpen, false)
            end
            if settings.automatism.hide["SubjectsBox"] then
                MailBuddy.ShowBox("subjects", false, true, false, false)
            else
                local doClose = false
                local doOpen = settings.lastShown.subjects["MailSend"]
                if doOpen == false then doClose = true end
                MailBuddy.ShowBox("subjects", false, doClose, doOpen, false)
            end

            --Add the "from" label above the "to" label and show the current account name if activated in the settings
            if settings.showAccountName or settings.showCharacterName then
                if MailBuddy.mailSendFromLabel == nil then
                    MailBuddy.mailSendFromLabel = WINDOW_MANAGER:CreateControl("MailBuddy_MailSendFromLabel", ZO_MailSend, CT_LABEL)
                end
                if MailBuddy.mailSendFromLabel ~= nil then
                    local mailSendFromLabel = MailBuddy.mailSendFromLabel
                    --Set the name to display at the label
                    local nameToShow = ""
                    if settings.showAccountName then
                        nameToShow = GetDisplayName()
                    elseif settings.showCharacterName then
                        local playerName = GetUnitName("player")
                        nameToShow = playerName
                    end
                    --Change the label values
                    mailSendFromLabel:SetFont("ZoFontWinH3")
                    mailSendFromLabel:SetColor(ZO_NORMAL_TEXT:UnpackRGBA())
                    mailSendFromLabel:SetScale(1)
                    mailSendFromLabel:SetDrawLayer(DT_HIGH)
                    mailSendFromLabel:SetDrawTier(DT_HIGH)
                    mailSendFromLabel:SetAnchor(TOPLEFT, ZO_MailSendToLabel, TOPLEFT, 0, -30)
                    mailSendFromLabel:SetDimensions(326, 23)
                    mailSendFromLabel:SetHidden(false)
                    mailSendFromLabel:SetText(MailBuddy.localizationVars.mb_loc["options_mail_from"] .. "   " .. nameToShow)
                end
            elseif not settings.showAccountName and not settings.showCharacterName then
                if MailBuddy.mailSendFromLabel ~= nil then
                    MailBuddy.mailSendFromLabel:SetHidden(true)
                end
            end

        elseif 	   newState == SCENE_SHOWN then
            --Preset the standard mail recipient and subject from the settings after mail was send/not sent (error)
            --Delay the automatic text filling of the subject and body texts as "send mail" from guild roster will clear the texts
            zo_callLater(function()
                MailBuddy.SetRememberedMailData()
            end, 150)
        elseif     newState == SCENE_HIDING then
            --Remember if the recipients list and subjects list are currently shown
            settings.lastShown.recipients["MailSend"] = not MailBuddy.recipientsBox:IsHidden()
            settings.lastShown.subjects["MailSend"] = not MailBuddy.subjectsBox:IsHidden()
            --Remember the last used recipient and subject text
            MailBuddy.RememberMailData()
            --Hide the account name/character name label
            if MailBuddy.mailSendFromLabel ~= nil then
                MailBuddy.mailSendFromLabel:SetHidden(true)
            end
        end
    end)

    --PreHook the OnMouseDown Handler at the ZOs mail to edit field
    ZO_PreHookHandler(ZO_MailSendToField, "OnMouseDown", function(control, button)
        if settings.useAlternativeLayout then
            if button == 2 then
                SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
            end
        end
    end)
    --PreHook the OnMouseUp Handler at the ZOs mail to edit field
    ZO_PreHookHandler(ZO_MailSendToField, "OnMouseUp", function(control, button, upInside)
        if settings.useAlternativeLayout then
            ZO_Tooltips_HideTextTooltip()
            if upInside and button == 2 then
                MailBuddy.ShowBox("recipients", true, false, false, true)
                SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
            end
        end
    end)
    --PreHook the OnMouseEnter Handler at the ZOs mail to edit field
    ZO_PreHookHandler(ZO_MailSendToField, "OnMouseEnter", function(control)
        if settings.showAlternativeLayoutTooltip and settings.useAlternativeLayout then
            local recipientFieldTooltipText = ""
            if MailBuddy.recipientsBox:IsHidden() then
                recipientFieldTooltipText = "|cF0F0F0Right click|r to |c22DD22show|r recipients list"
            else
                recipientFieldTooltipText = "|cF0F0F0Right click to |cDD2222hide|r recipients list"
            end
            ZO_Tooltips_ShowTextTooltip(control, BOTTOMRIGHT, recipientFieldTooltipText)
        end
    end)
    --PreHook the OnMouseExit Handler at the ZOs mail to edit field
    ZO_PreHookHandler(ZO_MailSendToField, "OnMouseExit", function(control)
        if settings.showAlternativeLayoutTooltip and settings.useAlternativeLayout then
            ZO_Tooltips_HideTextTooltip()
        end
    end)
    --PreHook the OnMouseDown Handler at the ZOs mail subject edit field
    ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseDown", function(control, button)
        if settings.useAlternativeLayout then
            ZO_Tooltips_HideTextTooltip()
            if button == 2 then
                SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
            end
        end
    end)
    --PreHook the OnMouseUp Handler at the ZOs mail subject edit field
    ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseUp", function(control, button, upInside)
        if settings.useAlternativeLayout then
            if upInside and button == 2 then
                MailBuddy.ShowBox("subjects", true, false, false, true)
                SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
            end
        end
    end)
    --PreHook the OnMouseEnter Handler at the ZOs mail subject edit field
    ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseEnter", function(control)
        if settings.showAlternativeLayoutTooltip and settings.useAlternativeLayout then
            local subjectFieldTooltipText = ""
            if MailBuddy.subjectsBox:IsHidden() then
                subjectFieldTooltipText = "|cF0F0F0Right click|r to |c22DD22show|r subjects list"
            else
                subjectFieldTooltipText = "|cF0F0F0Right click|r to |cDD2222hide|r subjects list"
            end
            ZO_Tooltips_ShowTextTooltip(control, BOTTOMRIGHT, subjectFieldTooltipText)
        end
    end)
    --PreHook the OnMouseExit Handler at the ZOs mail subject edit field
    ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseExit", function(control)
        if settings.showAlternativeLayoutTooltip and settings.useAlternativeLayout then
            ZO_Tooltips_HideTextTooltip()
        end
    end)

    --PreHook the standard mail sent method to store the recipient, subject and text (if wished)
    ZO_PreHook(MAIL_SEND, "Send", function()
        MailBuddy.RememberMailData()
    end)
    --PostHook the standard mail clear fields method to store the recipient, subject and text (if wished)
    ZO_PreHook(MAIL_SEND, "ClearFields", function()
        MailBuddy.RememberMailData()
        zo_callLater(function()
            MailBuddy.SetRememberedMailData()
        end, 150)
    end)

    --Set the current selected recipient and subject texts
    MailBuddy_MailSendRecipientLabelActiveText:SetText(string.format(settings.curRecipientAbbreviated))
    MailBuddy.UpdateEditFieldToolTip(MailBuddy_MailSendRecipientLabelActiveText, settings.curRecipient, settings.curRecipientAbbreviated)
    MailBuddy_MailSendSubjectLabelActiveText:SetText(string.format(settings.curSubjectAbbreviated))
    MailBuddy.UpdateEditFieldToolTip(MailBuddy_MailSendSubjectLabelActiveText, settings.curSubject, settings.curSubjectAbbreviated)
end
--The addon table/array
local MB = MailBuddy

--Global -> local speedup
local EM = EVENT_MANAGER
local WM = WINDOW_MANAGER

local addonVars = MB.addonVars
local addonName = addonVars.name
local addonNamePrefix = "[" .. addonName .. "]"
local mbLocPrefix = MB.LocalizationPrefix

local settings

------------------------------------------------------------------------------------------------------------------------
-- local helper functions
------------------------------------------------------------------------------------------------------------------------
--Get the class's icon texture
local function getClassIcon(classId)
    --* GetClassInfo(*luaindex* _index_)
    -- @return defId integer,lore string,normalIconKeyboard textureName,pressedIconKeyboard textureName,mouseoverIconKeyboard textureName,isSelectable bool,ingameIconKeyboard textureName,ingameIconGamepad textureName,normalIconGamepad textureName,pressedIconGamepad textureName
    local classLuaIndex = GetClassIndexById(classId)
    local _, _, textureName, _, _, _, ingameIconKeyboard, _, _, _= GetClassInfo(classLuaIndex)
    return ingameIconKeyboard or textureName or ""
end

--Decorate a character name with colour and icon of the class
local function decorateCharName(charName, classId, decorate)
    if not charName or charName == "" then return "" end
    if not classId then return charName end
    decorate = decorate or false
    if not decorate then return charName end
    local charNameDecorated
    --Get the class color
    local charColorDef = GetClassColor(classId)
    --Apply the class color to the charname
    if nil ~= charColorDef then charNameDecorated = charColorDef:Colorize(charName) end
    --Apply the class textures to the charname
    charNameDecorated = zo_iconTextFormatNoSpace(getClassIcon(classId), 20, 20, charNameDecorated)
    return charNameDecorated
end

--Build the table of all characters of the account
local function getCharactersOfAccount(keyIsCharName, decorate)
    decorate = decorate or false
    keyIsCharName = keyIsCharName or false
    local charactersOfAccount
    --Check all the characters of the account
    for i = 1, GetNumCharacters() do
        --GetCharacterInfo() -> *string* _name_, *[Gender|#Gender]* _gender_, *integer* _level_, *integer* _classId_, *integer* _raceId_, *[Alliance|#Alliance]* _alliance_, *string* _id_, *integer* _locationId_
        local name, gender, level, classId, raceId, alliance, characterId, location = GetCharacterInfo(i)
        local charName = zo_strformat(SI_UNIT_NAME, name)
        if characterId ~= nil and charName ~= "" then
            if charactersOfAccount == nil then charactersOfAccount = {} end
            charName = decorateCharName(charName, classId, decorate)
            if keyIsCharName then
                charactersOfAccount[charName]   = characterId
            else
                charactersOfAccount[characterId]= charName
            end
        end
    end
    return charactersOfAccount
end
MB.getCharactersOfAccount = getCharactersOfAccount

local function migrationInfoOutput(strVar, asAlertToo)
    asAlertToo = asAlertToo or false
    d(addonNamePrefix .. strVar)
    if asAlertToo == true then
        ZO_Alert(UI_ALERT_CATEGORY_ALERT, SOUNDS.AVA_GATE_OPENED, addonNamePrefix .. strVar)
    end
end
MB.migrationInfoOutput = migrationInfoOutput

------------------------------------------------------------------------------------------------------------------------
-- MailBuddy functions
---------------------------------------------------------------------------------------------------------------------------
function MB.ShowBox(boxType, doToggleShowHide, doCloseNow, doShowNow, doPlaySound, parentControl, doX, doY)
    if boxType == "" then return end
    doToggleShowHide = doToggleShowHide or false
    doCloseNow = doCloseNow or false
    doShowNow = doShowNow or false
    doPlaySound = doPlaySound or false
    if boxType == "recipients" then
        if settings.useAlternativeLayout then
            parentControl = parentControl or ZO_MailSendSubjectField
            doX = doX or -20
            doY = doY or -300
            MB.recipientsLabel:SetHidden(true)
            MB.recipientsLabel:SetMouseEnabled(false)
            MailBuddy_UseRecipientButton:SetHidden(true)
            MailBuddy_UseRecipientButton:SetMouseEnabled(false)
            MB.recipientsBox:ClearAnchors()
            MB.recipientsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
            MB.recipientsBox:SetParent(parentControl)
        else
            parentControl = parentControl or MB.recipientsLabel
            doX = doX or -15
            doY = doY or 0
            MB.recipientsLabel:SetHidden(false)
            MB.recipientsLabel:SetMouseEnabled(true)
            MailBuddy_UseRecipientButton:SetHidden(false)
            MailBuddy_UseRecipientButton:SetMouseEnabled(true)
            MB.recipientsBox:ClearAnchors()
            MB.recipientsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
            MB.recipientsBox:SetParent(parentControl)
        end
        if doToggleShowHide then
            if MB.recipientsBox:IsHidden() then
                MB.GetZOMailRecipient()
                MB.recipientsBox:SetHidden(false)
                MB.editRecipient:TakeFocus()
                if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
            else
                if  ( (not settings.useAlternativeLayout and settings.additional["RecipientsBoxVisibility"])
                  or  (settings.useAlternativeLayout) ) then
                    MB.recipientsBox:SetHidden(true)
                    if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
                end
            end
        end
        if doCloseNow then
            ZO_Tooltips_HideTextTooltip()
            MB.recipientsBox:SetHidden(true)
            if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
        elseif doShowNow then
            MB.recipientsBox:SetHidden(false)
            if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
        end
    elseif boxType == "subjects" then
        if settings.useAlternativeLayout then
            parentControl = parentControl or ZO_MailSendSubjectField
            doX = doX or -20
            doY = doY or 0
            MailBuddy_MailSendSubjectLabel:SetHidden(true)
            MailBuddy_MailSendSubjectLabel:SetMouseEnabled(false)
            MailBuddy_UseSubjectButton:SetHidden(true)
            MailBuddy_UseSubjectButton:SetMouseEnabled(false)
            MB.subjectsBox:ClearAnchors()
            MB.subjectsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
            MB.subjectsBox:SetParent(parentControl)
        else
            parentControl = parentControl or MB.subjectsLabel
            doX = doX or 0
            doY = doY or 10
            MailBuddy_MailSendSubjectLabel:SetHidden(false)
            MailBuddy_MailSendSubjectLabel:SetMouseEnabled(true)
            MailBuddy_UseSubjectButton:SetHidden(false)
            MailBuddy_UseSubjectButton:SetMouseEnabled(true)
            MB.subjectsBox:ClearAnchors()
            MB.subjectsBox:SetAnchor(TOP, parentControl, BOTTOM, doX, doY)
            MB.subjectsBox:SetParent(parentControl)
        end
        if doToggleShowHide then
            if MB.subjectsBox:IsHidden() then
                MB.GetZOMailSubject()
                MB.subjectsBox:SetHidden(false)
                MB.editSubject:TakeFocus()
                if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
            else
                if  ( (not settings.useAlternativeLayout and settings.additional["SubjectsBoxVisibility"])
                  or  (settings.useAlternativeLayout) ) then
                    MB.subjectsBox:SetHidden(true)
                    if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
                end
            end
        end
        if doCloseNow then
            ZO_Tooltips_HideTextTooltip()
            MB.subjectsBox:SetHidden(true)
            if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
        elseif doShowNow then
            MB.subjectsBox:SetHidden(false)
            if doPlaySound then MB.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
        else
        end
    end
end

function MB.UpdateFontAndColor(labelCtrl, updateWhere, fontArea)
    if labelCtrl == nil then return end
    --Get labe control by help of the name
    local labelControl
    if type(labelCtrl) == "string" then
        labelControl = WM:GetControlByName(labelCtrl, "")
    else
        labelControl = labelCtrl
    end
    if labelControl == nil then return end
    updateWhere = updateWhere or "recipients"
    fontArea = fontArea or 1
    if fontArea ~= 1 and fontArea ~= 2 then return end
    if updateWhere ~= "recipients" and updateWhere ~= "subjects" then return end
    --font for the selected recipient/subject
    local color = settings.font[updateWhere][fontArea].color
    local fontPath = MB.LMP:Fetch('font', settings.font[updateWhere][fontArea].family)
    local fontString = string.format('%s|%u|%s', fontPath, settings.font[updateWhere][fontArea].size, settings.font[updateWhere][fontArea].style)
    --local fontString = "ZoFontGame"
    if fontString  == nil then return end
    labelControl:SetFont(fontString)
    labelControl:SetColor(color.r, color.g, color.b, color.a)
end

function MB.UpdateAllLabels(updateWhere, pageNr, ctrlNr)
    updateWhere = updateWhere or "recipients"
    local maxLoop = 0
    local startLoop = 0
    if      updateWhere == "recipients" then
        if pageNr == -1 then
            startLoop = 1
            maxLoop = 3
        else
            startLoop = pageNr
            maxLoop = pageNr
        end
        for page=startLoop, maxLoop, 1 do
            for labelNr, recipientName in pairs(MB.recipientPages.pages[page]) do
                if ctrlNr == -1 or ctrlNr == labelNr then
                    local labelControl = WM:GetControlByName(recipientName, "")
                    if labelControl ~= nil then
                        --Chaneg font etc.
                        MB.UpdateFontAndColor(labelControl, updateWhere, 2)
                    end
                end
            end
        end

    elseif  updateWhere == "subjects" then
        if pageNr == -1 then
            startLoop = 1
            maxLoop = 1
        else
            startLoop = pageNr
            maxLoop = pageNr
        end
        for page=startLoop, maxLoop, 1 do
            for labelNr, subjectName in pairs(MB.subjectPages.pages[page]) do
                if ctrlNr == -1 or ctrlNr == labelNr then
                    local labelControl = WM:GetControlByName(subjectName, "")
                    if labelControl ~= nil then
                        --Chaneg font etc.
                        MB.UpdateFontAndColor(labelControl, updateWhere, 2)
                    end
                end
            end
        end
    end
end

local function PlayerActivatedCallback(eventId)
   -- zo_callLater(MailBuddyGetMail(), 2500)
    EM:UnregisterForEvent(addonName, eventId)

    MB.checkSavedVariablesMigrationTasks()

    --Update the anchors and positions of the recipients and subjects list
    MB.ShowBox("recipients", false, false, false, false)
    MB.ShowBox("subjects", false, false, false, false)

   --Add new recipient and new subject into an edit group and add autocomplete for the recipient name
    local editControlGroup = ZO_EditControlGroup:New()
    MB.autoCompleteRecipient = ZO_AutoComplete:New(MailBuddy_MailSendRecipientsBoxEditNewRecipient, { AUTO_COMPLETE_FLAG_ALL }, nil, AUTO_COMPLETION_ONLINE_OR_OFFLINE, MAX_AUTO_COMPLETION_RESULTS)
    editControlGroup:AddEditControl(MailBuddy_MailSendRecipientsBoxEditNewRecipient, MB.autoCompleteRecipient)
    editControlGroup:AddEditControl(MailBuddy_MailSendSubjectsBoxEditNewSubject, nil)
end

--Add button to the friends list to show recipients list
local function AddButtonToFriendsList()
    if ZO_KeyboardFriendsList ~= nil and not ZO_KeyboardFriendsList:IsHidden() then
        --Automatically hide the recipients box?
        local doHide = settings.automatism.hide["RecipientsBox"]
        local doOpen = settings.lastShown.recipients["FriendsList"]
        if doOpen == false then
            doHide = true
        end
        MB.ShowBox("recipients", false, doHide, doOpen, false, ZO_KeyboardFriendsList, -16, 0)

        --Add a button to the friends list, at top left corner near the "online status icon" to show/hide MailBuddy
        if ZO_DisplayNameStatusSelectedItem ~= nil then
            if MailBuddy_FriendsToggleButton == nil then
                --Create the button control at the parent
                local button = WM:CreateControl("MailBuddy_FriendsToggleButton", ZO_KeyboardFriendsList, CT_BUTTON)
                if button ~= nil then
                    --Set the button's size
                    button:SetDimensions(24, 24)
                    --Align the button
                    --SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY)
                    button:SetAnchor(TOPLEFT, ZO_DisplayNameStatusSelectedItem, TOPLEFT, -20, 5)
                    --Texture
                    local texture
                    --Create the texture for the button to hold the image
                    texture = WM:CreateControl("MailBuddy_FriendsToggleButtonTexture", button, CT_TEXTURE)
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
                        if MB.recipientsBox:IsHidden() then
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
                        MB.ShowBox("recipients", true, false, false, true, ZO_KeyboardFriendsList, -16, 0)
                    end)
                    button:SetHidden(false)
                end
            end
        end
    end
end

--Add button to the guild roster to show recipients list
local function AddButtonToGuildRoster()
    if ZO_GuildRoster ~= nil and not ZO_GuildRoster:IsHidden() then
        --Automatically hide the recipients box?
        local doHide = settings.automatism.hide["RecipientsBox"]
        local doOpen = settings.lastShown.recipients["GuildRoster"]
        if doOpen == false then
            doHide = true
        end
        MB.ShowBox("recipients", false, doHide, doOpen, false, ZO_GuildRoster, -16, 0)

        --Add a button to the guild roster, at top left corner near the "online status icon" to show/hide MailBuddy
        if ZO_DisplayNameStatusSelectedItem ~= nil then
            if MailBuddy_GuildRosterToggleButton == nil then
                --Create the button control at the parent
                local button = WM:CreateControl("MailBuddy_GuildRosterToggleButton", ZO_GuildRoster, CT_BUTTON)
                if button ~= nil then
                    --Set the button's size
                    button:SetDimensions(24, 24)
                    --Align the button
                    --SetAnchor(point, relativeTo, relativePoint, offsetX, offsetY)
                    button:SetAnchor(TOPLEFT, ZO_DisplayNameStatusSelectedItem, TOPLEFT, -20, 5)
                    --Texture
                    local texture
                    --Create the texture for the button to hold the image
                    texture = WM:CreateControl("MailBuddy_GuildRosterToggleButtonTexture", button, CT_TEXTURE)
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
                        if MB.recipientsBox:IsHidden() then
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
                        MB.ShowBox("recipients", true, false, false, true, ZO_GuildRoster, -16, 0)
                    end)
                    button:SetHidden(false)
                end
            end
        end
    end
end

function MB.PlaySoundNow(soundName, itemSoundCategory, itemSoundAction)
    --Only play sounds if enabled ins ettings
    if settings.playSounds == false then return end
    if (soundName == nil or soundName == "") and
        ((itemSoundCategory == nil or itemSoundCategory == "") or
         (itemSoundAction == nil or itemSoundAction == "")) then return end

    if soundName ~= nil and soundName ~= "" then
        PlaySound(soundName)
    else
        if (itemSoundCategory ~= nil and itemSoundAction ~= nil) then
            PlayItemSound(itemSoundCategory, itemSoundAction)
        end
    end
end

function MB.CopyNameUnderControl()
    local mouseOverControl = WM:GetMouseOverControl()
    if (mouseOverControl:GetName():find("^ZO_KeyboardFriendsListList1Row%d+DisplayName*" or "^ZO_KeyboardFriendsListList1Row%d%d+DisplayName*" )) then
        MB.editRecipient:SetText(string.format(mouseOverControl:GetText()))
    elseif (mouseOverControl:GetName():find("^ZO_GuildRosterList1Row%d+DisplayName*" or "^ZO_GuildRosterList1Row%d%d+DisplayName*" )) then
        MB.editRecipient:SetText(string.format(mouseOverControl:GetText()))
    end
end

function MB.GetZOMailRecipient(doOverride)
    doOverride = doOverride or false

    if not doOverride and MB.editRecipient:GetText() ~= "" then return "" end
    local GetTo = ZO_MailSendToField:GetText()
    if (GetTo ~= "") then
        if not doOverride then MB.editRecipient:SetText(GetTo)
        else return GetTo end
    else return "" end
end

function MB.GetZOMailSubject(doOverride)
    doOverride = doOverride or false

    if not doOverride and MB.editSubject:GetText() ~= "" then return "" end
    local GetSubject = ZO_MailSendSubjectField:GetText()
    if (GetSubject ~= "") then
        if not doOverride then MB.editSubject:SetText(GetSubject)
        else return GetSubject end
    else return "" end
end

function MB.GetZOMailBody()
    local GetBody = ZO_MailSendBodyField:GetText()
    return GetBody
end

local function GetMouseOverFriends(mouseOverControl)
    local keyStripVars = MB.keyStripVars
    if (not ZO_KeyboardFriendsList:IsHidden()) then
            KEYBIND_STRIP:AddKeybindButtonGroup(keyStripVars.keystripDefCopyFriend)
    else
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyFriend)
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyGuildMember)
    end
end

local function GetMouseOverGuildMembers(mouseOverControl)
    local keyStripVars = MB.keyStripVars
    if (not ZO_GuildRoster:IsHidden()) then
        KEYBIND_STRIP:AddKeybindButtonGroup(keyStripVars.keystripDefCopyGuildMember)
    else
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyFriend)
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyGuildMember)
    end
end

--Set the Mail-Brain "last used" mail recipient and subject for new mails
local function SetRememberedRecipientSubjectAndBody()
    if settings.remember.recipient["last"] and ZO_MailSendToField ~= nil and settings.remember.recipient["text"] ~= nil and settings.remember.recipient["text"] ~= "" then
        if not MB.preventerVars.dontUseLastRecipientName and ZO_MailSendToField:GetText() == "" then
            ZO_MailSendToField:SetText(string.format(settings.remember.recipient["text"]))
        end
    end
    if settings.remember.subject["last"] and ZO_MailSendSubjectField ~= nil and settings.remember.subject["text"] ~= nil and settings.remember.subject["text"] ~= "" then
        zo_callLater(function()
            ZO_MailSendSubjectField:SetText(string.format(settings.remember.subject["text"]))
        end, 50)
    end
    if settings.remember.body["last"] and ZO_MailSendBodyField ~= nil and settings.remember.body["text"] ~= nil and settings.remember.body["text"] ~= "" then
        ZO_MailSendBodyField:SetText(string.format(settings.remember.body["text"]))
    end
end

--Set the standard mail recipient and subject for new mails
local function SetStandardRecipientAndSubject()
    if not settings.remember.recipient["last"] and ZO_MailSendToField ~= nil and settings.standard["To"] ~= nil and settings.standard["To"] ~= "" then
        ZO_MailSendToField:SetText(settings.standard["To"])
    end
    if not settings.remember.subject["last"] and ZO_MailSendSubjectField ~= nil and settings.standard["Subject"] ~= nil and settings.standard["Subject"] ~= "" then
        ZO_MailSendSubjectField:SetText(settings.standard["Subject"])
    end
end

--------------------------------------------------------------------------------

function MB.GetPage(pageType, oldPage, doPlaySound)
    if pageType == nil or pageType == "" then return end
    oldPage = oldPage or 0
    doPlaySound = doPlaySound or false

    if pageType == "recipients" then
        if settings.curRecipientPage ~= oldPage then
            --Pages for the recipients
            if (settings.curRecipientPage == "1") then
                MailBuddy_RecipientsPage1:SetHidden(false)
                MailBuddy_RecipientsPage2:SetHidden(true)
                MailBuddy_RecipientsPage3:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow1:SetHidden(false)
                MailBuddy_MailSendRecipientsBoxButtonGlow2:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow3:SetHidden(true)
                if doPlaySound then
                    MB.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
                elseif (settings.curRecipientPage == "2") then
                MailBuddy_RecipientsPage2:SetHidden(false)
                MailBuddy_RecipientsPage1:SetHidden(true)
                MailBuddy_RecipientsPage3:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow2:SetHidden(false)
                MailBuddy_MailSendRecipientsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow3:SetHidden(true)
                if doPlaySound then
                    MB.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            elseif (settings.curRecipientPage == "3") then
                MailBuddy_RecipientsPage3:SetHidden(false)
                MailBuddy_RecipientsPage1:SetHidden(true)
                MailBuddy_RecipientsPage2:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow3:SetHidden(false)
                MailBuddy_MailSendRecipientsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow2:SetHidden(true)
                if doPlaySound then
                    MB.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            end
        end
    elseif pageType == "subjects" then
        if settings.curSubjectPage ~= oldPage then
            --Pages for the subjects
            if (settings.curSubjectPage == "1") then
                MailBuddy_SubjectsPage1:SetHidden(false)
                MailBuddy_SubjectsPage2:SetHidden(true)
                MailBuddy_SubjectsPage3:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow1:SetHidden(false)
                MailBuddy_MailSendSubjectsBoxButtonGlow2:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow3:SetHidden(true)
                if doPlaySound then
                    MB.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            elseif (settings.curSubjectPage == "2") then
                MailBuddy_SubjectsPage2:SetHidden(false)
                MailBuddy_SubjectsPage1:SetHidden(true)
                MailBuddy_SubjectsPage3:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow2:SetHidden(false)
                MailBuddy_MailSendSubjectsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow3:SetHidden(true)
                if doPlaySound then
                    MB.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            elseif (settings.curSubjectPage == "3") then
                MailBuddy_SubjectsPage3:SetHidden(false)
                MailBuddy_SubjectsPage1:SetHidden(true)
                MailBuddy_SubjectsPage2:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow3:SetHidden(false)
                MailBuddy_MailSendSubjectsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow2:SetHidden(true)
                if doPlaySound then
                    MB.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            end
        end
    end
end

function MB.mapPageAndEntry(p_pageIndex, p_Type)
    if p_pageIndex == nil or p_Type == nil then return end
    local pageEntry
    if p_pageIndex ~= 0 then
        --Get the recipient page and entry
        if p_Type == "recipient" then
            for pageNr, maxEntries in pairs (MB.recipientPages.maxEntriesUntilHere) do
                if p_pageIndex <= maxEntries then
                    if pageNr > 1 then
                        pageEntry = p_pageIndex - ((pageNr-1) * MB.recipientPages.entriesPerPage)
                    else
                        pageEntry = p_pageIndex
                    end
                    return pageNr, pageEntry
                end
            end
        --Get the subject page and entry
        elseif p_Type == "subject" then
            for pageNr, maxEntries in pairs (MB.subjectPages.maxEntriesUntilHere) do
                if p_pageIndex <= maxEntries then
                    if pageNr > 1 then
                        pageEntry = p_pageIndex - ((pageNr-1) * MB.subjectPages.entriesPerPage)
                    else
                        pageEntry = p_pageIndex
                    end
                    return pageNr, pageEntry
                end
            end
        else
            return nil, nil
        end
    else
        return nil, nil
    end
end

--Update the tooltips of the edit field to show the non-abbreviated text inside the tooltip
function MB.UpdateEditFieldToolTip(editControl, tooltipText, tooltiptextShort)
    if editControl == nil or tooltipText == "" then return end

    if tooltipText ~= tooltiptextShort then
        editControl:SetHandler("OnMouseEnter", function(self)
            ZO_Tooltips_ShowTextTooltip(editControl, LEFT, tooltipText)
        end)
        editControl:SetHandler("OnMouseExit", function(self)
            ZO_Tooltips_HideTextTooltip()
        end)
    else
        editControl:SetHandler("OnMouseEnter", nil)
    end
end

--Set the focus to the next field that needs it
function MB.FocusNextField()
    if  not settings.automatism.focus["To"]
        and not settings.automatism.focus["Subject"]
        and not settings.automatism.focus["Body"] then return end
    if settings.automatism.focus["Body"] and ZO_MailSendToField:GetText() ~= "" and ZO_MailSendSubjectField:GetText() ~= "" then
        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
        ZO_MailSendBodyField:TakeFocus()
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
    elseif settings.automatism.focus["To"] and ZO_MailSendToField:GetText() == "" and ZO_MailSendSubjectField:GetText() ~= "" then
        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
        ZO_MailSendToField:TakeFocus()
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
        if settings.automatism.focusOpen["To"] then
            MB.ShowBox("recipients", false, false, true, true)
        end
    elseif settings.automatism.focus["Subject"] and ZO_MailSendToField:GetText() ~= "" and ZO_MailSendSubjectField:GetText() == "" then
        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
        ZO_MailSendSubjectField:TakeFocus()
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
        if settings.automatism.focusOpen["Subject"] then
            MB.ShowBox("subjects", false, false, true, true)
        end
    end
end

--Close the recipients/subjects lists automatically
function MB.AutoCloseBox(boxType, doOverride)
    if boxType == nil or boxType == "" then return end
    doOverride = doOverride or false
    local isGuildRoster = false
    local isFriendsList = false

    if ZO_KeyboardFriendsList ~= nil and not ZO_KeyboardFriendsList:IsHidden() then isFriendsList = true
    elseif ZO_GuildRoster ~= nil and not ZO_GuildRoster:IsHidden() then isGuildRoster = true end

    if    (boxType == "subjects" and (doOverride or settings.automatism.close["SubjectsBox"]))
       or (boxType == "recipients" and (doOverride or settings.automatism.close["RecipientsBox"])) then
        MB.ShowBox(boxType, false, true, false, false)
    end
end

function MB.UpdateNumTotalMails()
    --Show the current total count of mails?
    if settings.showTotalMailCountInInbox then
        zo_callLater(function()
            if ZO_MailInboxUnreadLabel ~= nil then
                local otherAddons = MB.otherAddons
                local unreadMails = GetNumUnreadMail()
                if MAIL_INBOX == nil or MAIL_INBOX.masterList == nil then return false end
                local currentMailCount = 0
                --Is the addon MaiLR active?
                otherAddons.isMailRActive = (MailR ~= nil)
                if otherAddons.isMailRActive then
                    currentMailCount = 0
                    for key, mailData in pairs(MAIL_INBOX.masterList) do
                        --Is the mail not a MailR "sent" mail?
                        if mailData.expiresText == nil or mailData.expiresText ~= "MAILR" then
                            --Increase the counter by 1
                            currentMailCount = currentMailCount + 1
                        end
                    end
                else
                    currentMailCount = #MAIL_INBOX.masterList
                end
                if currentMailCount ~= nil then
                    --Colorize the current mails in inbox count. If it is below the half of MAX_LOCAL_MAILS it will be white.
                    --If it reaches the half of MAX_LOCAL_MAILS it will be yellow, otherweise it will be red
                    local colorText = ""
                    if MAX_LOCAL_MAILS ~= nil and MAX_LOCAL_MAILS > 0 then
                        local halfMax = (MAX_LOCAL_MAILS / 2)
                        if halfMax == 0 then halfMax = 1 end
                        if currentMailCount < halfMax then
                            colorText = ""
                        elseif currentMailCount >= halfMax and currentMailCount < MAX_LOCAL_MAILS then
                            colorText = "|cFFA500"
                        elseif currentMailCount >= MAX_LOCAL_MAILS then
                            colorText = "|cDD2222"
                        end
                    end
                    if colorText ~= "" then
                        ZO_MailInboxUnreadLabel:SetText(unreadMails .. " / " .. colorText .. currentMailCount .."|r")
                    else
                        ZO_MailInboxUnreadLabel:SetText(unreadMails .. " / " .. currentMailCount)
                    end
                else
                    ZO_MailInboxUnreadLabel:SetText(unreadMails)
                end
            end
        end, 100)
    end
end

function MB.RememberMailData()
    --Remember the last used recipient and subject text
    settings.remember.recipient["text"] = MB.GetZOMailRecipient(true)
    settings.remember.subject["text"]   = MB.GetZOMailSubject(true)
    settings.remember.body["text"]      = MB.GetZOMailBody()
end

function MB.SetRememberedMailData()
    SetStandardRecipientAndSubject()
    SetRememberedRecipientSubjectAndBody()
end

function MB.OnTLCMoveStop(self)
 d("TLC was moved")
end

--Prepare some needed addon variables
local function prepareVars()
    --Build the character name to unique ID mapping tables and vice-versa
    --The character names are decorated with the color and icon of the class!
    MB.characterName2Id = {}
    MB.characterId2Name = {}
    MB.characterNameRaw2Id = {}
    MB.characterId2NameRaw = {}
    --Tables with character charname as key
    MB.characterName2Id =       getCharactersOfAccount(true, true)
    MB.characterNameRaw2Id =    getCharactersOfAccount(true, false)
    --Tables with character ID as key
    MB.characterId2Name =       getCharactersOfAccount(false, true)
    MB.characterId2NameRaw =    getCharactersOfAccount(false, false)
end

local function registerHooks()
    local keyStripVars = MB.keyStripVars
    --======== FRIENDS LIST ================================================================
    --Register a callback function for the friends list scene
    FRIENDS_LIST_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   newState == SCENE_SHOWN then
            AddButtonToFriendsList()

        elseif newState == SCENE_HIDING then
            settings.lastShown.recipients["FriendsList"] = not MB.recipientsBox:IsHidden()
        end
    end)
    --PreHook the MouseEnter and Exit functions for the friends list rows + names in the rows
    ZO_PreHook("ZO_FriendsListRowDisplayName_OnMouseEnter", function(control)
        --d("Mouse enter friend name: " .. control:GetName())
        GetMouseOverFriends(control)
    end)
    ZO_PreHook("ZO_FriendsListRowDisplayName_OnMouseExit", function(control)
        --d("Mouse exit friend name: " .. control:GetName())
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyFriend)
    end)
    ZO_PreHook("ZO_FriendsListRow_OnMouseExit", function(control)
        --d("Mouse exit friends row: " .. control:GetName())
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyFriend)
    end)

    --======== GUILD ROSTER ================================================================
    --Register a callback function for the guild roster scene
    GUILD_ROSTER_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   newState == SCENE_SHOWN then
            AddButtonToGuildRoster()

        elseif newState == SCENE_HIDING then
            settings.lastShown.recipients["GuildRoster"] = not MB.recipientsBox:IsHidden()
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
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyGuildMember)
    end)
    ZO_PreHook("ZO_KeyboardGuildRosterRow_OnMouseExit", function(control)
        --d("Mouse exit guild roster row: " .. control:GetName())
        KEYBIND_STRIP:RemoveKeybindButtonGroup(keyStripVars.keystripDefCopyGuildMember)
    end)


    --======== MAIL INBOX ================================================================
    --Register a callback function for the mail inbox scene
    MAIL_INBOX_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   	   newState == SCENE_SHOWN then
            --Update the total number of mails label
            MB.UpdateNumTotalMails()
        end
    end)

    --PreHook the mail inbox update functions so the number of current mails at the label will be updated too
    ZO_PreHook(MAIL_INBOX, "OnMailNumUnreadChanged", function(...)
        if SCENE_MANAGER:IsShowing("mailInbox") then
            --Update the total number of mails label
            MB.UpdateNumTotalMails()
        end
    end)
    ZO_PreHook(MAIL_INBOX, "OnMailRemoved", function(...)
        if SCENE_MANAGER:IsShowing("mailInbox") then
            --Update the total number of mails label
            MB.UpdateNumTotalMails()
        end
    end)

    --======== MAIL SEND ================================================================
    --Register a callback function for the mail send scene
    MAIL_SEND_SCENE:RegisterCallback("StateChange", function(oldState, newState)
        if 	   	   newState == SCENE_SHOWING then
            --Hide the UI elements for the recipients and subjects lists if enabled in the settings
            if settings.automatism.hide["RecipientsBox"] then
                MB.ShowBox("recipients", false, true, false, false)
            else
                local doClose = false
                local doOpen = settings.lastShown.recipients["MailSend"]
                if doOpen == false then doClose = true end
                MB.ShowBox("recipients", false, doClose, doOpen, false)
            end
            if settings.automatism.hide["SubjectsBox"] then
                MB.ShowBox("subjects", false, true, false, false)
            else
                local doClose = false
                local doOpen = settings.lastShown.subjects["MailSend"]
                if doOpen == false then doClose = true end
                MB.ShowBox("subjects", false, doClose, doOpen, false)
            end

            --Add the "from" label above the "to" label and show the current account name if activated in the settings
            if settings.showAccountName or settings.showCharacterName then
                if MB.mailSendFromLabel == nil then
                    MB.mailSendFromLabel = WM:CreateControl("MailBuddy_MailSendFromLabel", ZO_MailSend, CT_LABEL)
                end
                if MB.mailSendFromLabel ~= nil then
                    --Set the name to display at the label
                    local nameToShow = ""
                    if settings.showAccountName then
                        nameToShow = GetDisplayName()
                    elseif settings.showCharacterName then
                        local playerName = GetUnitName("player")
                        nameToShow = playerName
                    end
                    --Change the label values
                    MB.mailSendFromLabel:SetFont("ZoFontWinH3")
                    MB.mailSendFromLabel:SetColor(ZO_NORMAL_TEXT:UnpackRGBA())
                    MB.mailSendFromLabel:SetScale(1)
                    MB.mailSendFromLabel:SetDrawLayer(DT_HIGH)
                    MB.mailSendFromLabel:SetDrawTier(DT_HIGH)
                    MB.mailSendFromLabel:SetAnchor(TOPLEFT, ZO_MailSendToLabel, TOPLEFT, 0, -30)
                    MB.mailSendFromLabel:SetDimensions(326, 23)
                    MB.mailSendFromLabel:SetHidden(false)
                    MB.mailSendFromLabel:SetText(GetString(mbLocPrefix .."options_mail_from") .. "   " .. nameToShow)
                end
            elseif not settings.showAccountName and not settings.showCharacterName then
                if MB.mailSendFromLabel ~= nil then
                    MB.mailSendFromLabel:SetHidden(true)
                end
            end

        elseif 	   newState == SCENE_SHOWN then
            --Preset the standard mail recipient and subject from the settings after mail was send/not sent (error)
            --Delay the automatic text filling of the subject and body texts as "send mail" from guild roster will clear the texts
            zo_callLater(function()
                MB.SetRememberedMailData()
            end, 150)
        elseif     newState == SCENE_HIDING then
            --Remember if the recipients list and subjects list are currently shown
            settings.lastShown.recipients["MailSend"] = not MB.recipientsBox:IsHidden()
            settings.lastShown.subjects["MailSend"] = not MB.subjectsBox:IsHidden()
            --Remember the last used recipient and subject text
            MB.RememberMailData()
            --Hide the account name/character name label
            if MB.mailSendFromLabel ~= nil then
                MB.mailSendFromLabel:SetHidden(true)
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
                MB.ShowBox("recipients", true, false, false, true)
                SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
            end
        end
    end)
    --PreHook the OnMouseEnter Handler at the ZOs mail to edit field
    ZO_PreHookHandler(ZO_MailSendToField, "OnMouseEnter", function(control)
        if settings.showAlternativeLayoutTooltip and settings.useAlternativeLayout then
            local recipientFieldTooltipText = ""
            if MB.recipientsBox:IsHidden() then
                recipientFieldTooltipText = GetString(_G[string.format("MAILBUDDY_%s_right_click_%s_tt", "recipient_list", "show")])
            else
                recipientFieldTooltipText = GetString(_G[string.format("MAILBUDDY_%s_right_click_%s_tt", "recipient_list", "hide")])
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
                MB.ShowBox("subjects", true, false, false, true)
                SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
            end
        end
    end)
    --PreHook the OnMouseEnter Handler at the ZOs mail subject edit field
    ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseEnter", function(control)
        if settings.showAlternativeLayoutTooltip and settings.useAlternativeLayout then
            local subjectFieldTooltipText = ""
            if MB.subjectsBox:IsHidden() then
                subjectFieldTooltipText = GetString(_G[string.format("MAILBUDDY_%s_right_click_%s_tt", "subject", "show")])
            else
                subjectFieldTooltipText = GetString(_G[string.format("MAILBUDDY_%s_right_click_%s_tt", "subject", "hide")])
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
        MB.RememberMailData()
    end)
    --PostHook the standard mail clear fields method to store the recipient, subject and text (if wished)
    ZO_PreHook(MAIL_SEND, "ClearFields", function()
        MB.RememberMailData()
        zo_callLater(function()
            MB.SetRememberedMailData()
        end, 150)
    end)
end

--Initialization of this addon
local function Initialize(eventCode, addOnName)
    if (addOnName ~= addonName) then
        return
    end
    --Unregister the addon loaded event again so it won't be called twice!
    EM:UnregisterForEvent(addonName, eventCode)

    --Prepare some variables
    prepareVars()

    --Load the saved variables etc.
    MB.LoadUserSettings()
    settings = MB.settingsVars.settings

    --Build the settings panel
    MB.CreateLAMPanel()

    --Create the text for the keybinding
    ZO_CreateStringId("SI_BINDING_NAME_MAILBUDDY_COPY", GetString("SI_BINDING_NAME_MAILBUDDY_COPY"))

    --Select the current page at recipients and subjects (from the saved variables)
    MB.GetPage("recipients", 0, false)
    MB.GetPage("subjects", 0, false)

    --Register the hooks
    registerHooks()

    --Set the current selected recipient and subject texts
    MB.UpdateLabelTextAndTooltip(MailBuddy_MailSendRecipientLabelActiveText, settings.curRecipientAbbreviated, settings.curRecipient)
    MB.UpdateLabelTextAndTooltip(MailBuddy_MailSendSubjectLabelActiveText, settings.curSubjectAbbreviated, settings.curSubject)

    --Preset the standard mail recipient and subject from the settings after mail was send/not sent (error)
    EM:RegisterForEvent(addonName, EVENT_MAIL_SEND_SUCCESS, function()
        zo_callLater(function()
            MB.SetRememberedMailData()
        end, 150)
    end)
    EM:RegisterForEvent(addonName, EVENT_MAIL_SEND_FAILED, function()
        zo_callLater(function()
            MB.SetRememberedMailData()
        end, 150)
    end)
    EM:RegisterForEvent(addonName, EVENT_PLAYER_ACTIVATED, PlayerActivatedCallback)

    local function mailBuddyDeleteOldNonServerDependentSVForAccount(argu)
        local svNameOld     = addonVars.savedVariablesName_OLD
 	    local svVersionOld  = MB.settingsVars.settingsVersion

        local displayName = GetDisplayName()
        migrationInfoOutput("Looking for old non-server dependent SavedVariables of account \'".. displayName .."\'....", true, false)
        local dbOld = ZO_SavedVars:NewAccountWide(svNameOld, svVersionOld, nil, nil, nil, nil)
        --Do the old SV exist with recently new pChat data?
        if dbOld ~= nil and dbOld.SetRecipient ~= nil then
            local dbOldNonServerDependent = _G[svNameOld]["Default"][displayName]["$AccountWide"]
            if dbOldNonServerDependent ~= nil then
                _G[svNameOld]["Default"][displayName]["$AccountWide"] = nil
                dbOldNonServerDependent = nil
                migrationInfoOutput("Successfully deleted the old, non-server dependent SavedVariables of account \'"..displayName.."\'.", true, true)
                migrationInfoOutput(">A reloadUI saves the changes to disk in 3 seconds...", true, true)
                zo_callLater(function()
                    ReloadUI("ingame")
                end, 3000)
        end
        else
            migrationInfoOutput("No non-server dependent SavedVariables found for account \'"..displayName.."\'!", true, true)
        end
    end
    SLASH_COMMANDS["/mailbuddydeleteoldsv"] = mailBuddyDeleteOldNonServerDependentSVForAccount


    --Test MailBuddyPagedList - Recipients
    MB.InitializeRecipientsList()
    --MB.InitializeSubjectsList()
end

--Event Registry--
EM:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, Initialize)

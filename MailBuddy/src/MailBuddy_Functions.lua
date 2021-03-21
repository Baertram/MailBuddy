MailBuddy = MailBuddy or {}


------------------------------------------------------------------------------------------------------------------------
--Constants for the functions below
local friendsList = ZO_KeyboardFriendsList
local guildRoster = ZO_GuildRoster


------------------------------------------------------------------------------------------------------------------------
--local helper functions

--Clear player/account name from the recipients list, as you are not allowed to send mails to yourself
local function RemoveOwnCharactersFromSavedRecipients(index, recipientName)
    if index == nil or recipientName == nil then return false end
    if recipientName == MailBuddy.playerName or recipientName == MailBuddy.accountName then
        --One of your characters or your account name was added to teh recipients list
        --> It will be removed now and clearedfrom the SavedVariables at the next reloadui/zone change/logout
        MailBuddy.settingsVars.settings.SetRecipient[index] = ""
        MailBuddy.settingsVars.settings.SetRecipientAbbreviated[index] = ""
        return true
    end
    return false
end

--Set the Mail-Brain "last used" mail recipient and subject for new mails
local function SetRememberedRecipientSubjectAndBody()
    local settings = MailBuddy.settingsVars.settings
    local mailSendToField = ZO_MailSendToField
    local mailSendSubjectField = ZO_MailSendSubjectField
    local mailSendBodyField = ZO_MailSendBodyField
    if settings.remember.recipient["last"] and mailSendToField ~= nil and settings.remember.recipient["text"] ~= nil and settings.remember.recipient["text"] ~= "" then
        if not MailBuddy.preventerVars.dontUseLastRecipientName and mailSendToField:GetText() == "" then
            mailSendToField:SetText(string.format(settings.remember.recipient["text"]))
        end
    end
    if settings.remember.subject["last"] and mailSendSubjectField ~= nil and settings.remember.subject["text"] ~= nil and settings.remember.subject["text"] ~= "" then
        zo_callLater(function()
            mailSendSubjectField:SetText(string.format(settings.remember.subject["text"]))
        end, 50)
    end
    if settings.remember.body["last"] and mailSendBodyField ~= nil and settings.remember.body["text"] ~= nil and settings.remember.body["text"] ~= "" then
        mailSendBodyField:SetText(string.format(settings.remember.body["text"]))
    end
end

--Set the standard mail recipient and subject for new mails
local function SetStandardRecipientAndSubject()
    local settings = MailBuddy.settingsVars.settings
    local mailSendToField = ZO_MailSendToField
    local mailSendSubjectField = ZO_MailSendSubjectField
    if not settings.remember.recipient["last"] and mailSendToField ~= nil and settings.standard["To"] ~= nil and settings.standard["To"] ~= "" then
        mailSendToField:SetText(settings.standard["To"])
    end
    if not settings.remember.subject["last"] and mailSendSubjectField ~= nil and settings.standard["Subject"] ~= nil and settings.standard["Subject"] ~= "" then
        mailSendSubjectField:SetText(settings.standard["Subject"])
    end
end


------------------------------------------------------------------------------------------------------------------------
--Get functions
function MailBuddy.GetZOMailRecipient(doOverride)
    doOverride = doOverride or false

    if not doOverride and MailBuddy.editRecipient:GetText() ~= "" then return "" end
    local GetTo = ZO_MailSendToField:GetText()
    if (GetTo ~= "") then
        if not doOverride then MailBuddy.editRecipient:SetText(GetTo)
        else return GetTo end
    else return "" end
end

function MailBuddy.GetZOMailSubject(doOverride)
    doOverride = doOverride or false

    if not doOverride and MailBuddy.editSubject:GetText() ~= "" then return "" end
    local GetSubject = ZO_MailSendSubjectField:GetText()
    if (GetSubject ~= "") then
        if not doOverride then MailBuddy.editSubject:SetText(GetSubject)
        else return GetSubject end
    else return "" end
end

function MailBuddy.GetZOMailBody()
    local GetBody = ZO_MailSendBodyField:GetText()
    return GetBody
end


------------------------------------------------------------------------------------------------------------------------
--Set functions
function MailBuddy.SetRememberedMailData()
    SetStandardRecipientAndSubject()
    SetRememberedRecipientSubjectAndBody()
end


------------------------------------------------------------------------------------------------------------------------
--Update functions



------------------------------------------------------------------------------------------------------------------------
--Get UI functions
function MailBuddy.GetPage(pageType, oldPage, doPlaySound)
    if pageType == nil or pageType == "" then return end
    oldPage = oldPage or 0
    doPlaySound = doPlaySound or false
    local settings = MailBuddy.settingsVars.settings

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
                    MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
                elseif (settings.curRecipientPage == "2") then
                MailBuddy_RecipientsPage2:SetHidden(false)
                MailBuddy_RecipientsPage1:SetHidden(true)
                MailBuddy_RecipientsPage3:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow2:SetHidden(false)
                MailBuddy_MailSendRecipientsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow3:SetHidden(true)
                if doPlaySound then
                    MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            elseif (settings.curRecipientPage == "3") then
                MailBuddy_RecipientsPage3:SetHidden(false)
                MailBuddy_RecipientsPage1:SetHidden(true)
                MailBuddy_RecipientsPage2:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow3:SetHidden(false)
                MailBuddy_MailSendRecipientsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendRecipientsBoxButtonGlow2:SetHidden(true)
                if doPlaySound then
                    MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
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
                    MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            elseif (settings.curSubjectPage == "2") then
                MailBuddy_SubjectsPage2:SetHidden(false)
                MailBuddy_SubjectsPage1:SetHidden(true)
                MailBuddy_SubjectsPage3:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow2:SetHidden(false)
                MailBuddy_MailSendSubjectsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow3:SetHidden(true)
                if doPlaySound then
                    MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            elseif (settings.curSubjectPage == "3") then
                MailBuddy_SubjectsPage3:SetHidden(false)
                MailBuddy_SubjectsPage1:SetHidden(true)
                MailBuddy_SubjectsPage2:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow3:SetHidden(false)
                MailBuddy_MailSendSubjectsBoxButtonGlow1:SetHidden(true)
                MailBuddy_MailSendSubjectsBoxButtonGlow2:SetHidden(true)
                if doPlaySound then
                    MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                end
            end
        end
    end
end


------------------------------------------------------------------------------------------------------------------------
--Set UI functions



------------------------------------------------------------------------------------------------------------------------
--Update UI functions
function MailBuddy.UpdateFontAndColor(labelCtrl, updateWhere, fontArea)
    if labelCtrl == nil then return end
    --Get labe control by help of the name
    local labelControl
    if type(labelCtrl) == "string" then
        labelControl = WINDOW_MANAGER:GetControlByName(labelCtrl, "")
    else
        labelControl = labelCtrl
    end
    if labelControl == nil then return end
    updateWhere = updateWhere or "recipients"
    fontArea = fontArea or 1
    if fontArea ~= 1 and fontArea ~= 2 then return end
    if updateWhere ~= "recipients" and updateWhere ~= "subjects" then return end
    --font for the selected recipient/subject
    local settings = MailBuddy.settingsVars.settings
    local fontArea = settings.font[updateWhere][fontArea]
    local color = fontArea.color
    local fontPath = LMP:Fetch('font', fontArea.family)
    local fontString = string.format('%s|%u|%s', fontPath, fontArea.size, fontArea.style)
    --local fontString = "ZoFontGame"
    if fontString  == nil then return end
    labelControl:SetFont(fontString)
    labelControl:SetColor(color.r, color.g, color.b, color.a)
end

function MailBuddy.UpdateAllLabels(updateWhere, pageNr, ctrlNr)
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
            for labelNr, recipientName in pairs(MailBuddy.recipientPages.pages[page]) do
                if ctrlNr == -1 or ctrlNr == labelNr then
                    local labelControl = WINDOW_MANAGER:GetControlByName(recipientName, "")
                    if labelControl ~= nil then
                        --Chaneg font etc.
                        MailBuddy.UpdateFontAndColor(labelControl, updateWhere, 2)
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
            for labelNr, subjectName in pairs(MailBuddy.subjectPages.pages[page]) do
                if ctrlNr == -1 or ctrlNr == labelNr then
                    local labelControl = WINDOW_MANAGER:GetControlByName(subjectName, "")
                    if labelControl ~= nil then
                        --Chaneg font etc.
                        MailBuddy.UpdateFontAndColor(labelControl, updateWhere, 2)
                    end
                end
            end
        end
    end
end

function MailBuddy.UpdateNumTotalMails()
    --Show the current total count of mails?
    if MailBuddy.settingsVars.settings.showTotalMailCountInInbox then
        zo_callLater(function()
            local unreadLabel = ZO_MailInboxUnreadLabel
            if unreadLabel ~= nil then
                local unreadMails = GetNumUnreadMail()
                if MAIL_INBOX == nil or MAIL_INBOX.masterList == nil then return false end
                local currentMailCount = 0
                --Is the addon MaiLR active?
                if MailBuddy.otherAddons.isMailRActive then
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
                        unreadLabel:SetText(unreadMails .. " / " .. colorText .. currentMailCount .."|r")
                    else
                        unreadLabel:SetText(unreadMails .. " / " .. currentMailCount)
                    end
                else
                    unreadLabel:SetText(unreadMails)
                end
            end
        end, 100)
    end
end


------------------------------------------------------------------------------------------------------------------------
--Other UI functions
function MailBuddy.CopyNameUnderControl()
    local mouseOverControl = WINDOW_MANAGER:GetMouseOverControl()
    if (mouseOverControl:GetName():find("^ZO_KeyboardFriendsListList1Row%d+DisplayName*" or "^ZO_KeyboardFriendsListList1Row%d%d+DisplayName*" )) then
        MailBuddy.editRecipient:SetText(string.format(mouseOverControl:GetText()))
    elseif (mouseOverControl:GetName():find("^ZO_GuildRosterList1Row%d+DisplayName*" or "^ZO_GuildRosterList1Row%d%d+DisplayName*" )) then
        MailBuddy.editRecipient:SetText(string.format(mouseOverControl:GetText()))
    end
end


function MailBuddy.mapPageAndEntry(p_pageIndex, p_Type)
    if p_pageIndex == nil or p_Type == nil then return end
    local pageEntry
    if p_pageIndex ~= 0 then
        --Get the recipient page and entry
        local entriesPerPage = MailBuddy.recipientPages.entriesPerPage
        if p_Type == "recipient" then
            for pageNr, maxEntries in pairs (MailBuddy.recipientPages.maxEntriesUntilHere) do
                if p_pageIndex <= maxEntries then
                    if pageNr > 1 then
                        pageEntry = p_pageIndex - ((pageNr-1) * entriesPerPage)
                    else
                        pageEntry = p_pageIndex
                    end
                    return pageNr, pageEntry
                end
            end
        --Get the subject page and entry
        elseif p_Type == "subject" then
            for pageNr, maxEntries in pairs (MailBuddy.subjectPages.maxEntriesUntilHere) do
                if p_pageIndex <= maxEntries then
                    if pageNr > 1 then
                        pageEntry = p_pageIndex - ((pageNr-1) * entriesPerPage)
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
function MailBuddy.UpdateEditFieldToolTip(editControl, tooltipText, tooltiptextShort)
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
function MailBuddy.FocusNextField()
    local settingsAutomatism = MailBuddy.settingsVars.settings.automatism
    local settingsAutomatismFocus = settingsAutomatism.focus
    local mailSendToField = ZO_MailSendToField
    local mailSendToSubjectField = ZO_MailSendSubjectField
    if  not settingsAutomatismFocus["To"]
        and not settingsAutomatismFocus["Subject"]
        and not settingsAutomatismFocus["Body"] then return end
    if settingsAutomatismFocus["Body"] and mailSendToField:GetText() ~= "" and mailSendToSubjectField:GetText() ~= "" then
        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
        ZO_MailSendBodyField:TakeFocus()
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
    elseif settingsAutomatismFocus["To"] and mailSendToField:GetText() == "" and mailSendToSubjectField:GetText() ~= "" then
        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
        mailSendToField:TakeFocus()
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
        if settingsAutomatism.focusOpen["To"] then
            MailBuddy.ShowBox("recipients", false, false, true, true)
        end
    elseif settingsAutomatismFocus["Subject"] and mailSendToField:GetText() ~= "" and mailSendToSubjectField:GetText() == "" then
        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
        mailSendToSubjectField:TakeFocus()
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
        if settingsAutomatism.focusOpen["Subject"] then
            MailBuddy.ShowBox("subjects", false, false, true, true)
        end
    end
end

--Box functions
function MailBuddy.ShowBox(boxType, doToggleShowHide, doCloseNow, doShowNow, doPlaySound, parentControl, doX, doY)
    if boxType == "" then return end
    doToggleShowHide = doToggleShowHide or false
    doCloseNow = doCloseNow or false
    doShowNow = doShowNow or false
    doPlaySound = doPlaySound or false
    local settings = MailBuddy.settingsVars.settings
    if boxType == "recipients" then
        local recipientsLabel = MailBuddy.recipientsLabel
        local recipientsBox = MailBuddy.recipientsBox
        if settings.useAlternativeLayout then
            parentControl = parentControl or ZO_MailSendSubjectField
            doX = doX or -20
            doY = doY or -300
            recipientsLabel:SetHidden(true)
            recipientsLabel:SetMouseEnabled(false)
            MailBuddy_UseRecipientButton:SetHidden(true)
            MailBuddy_UseRecipientButton:SetMouseEnabled(false)
            recipientsBox:ClearAnchors()
            recipientsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
            recipientsBox:SetParent(parentControl)
        else
            parentControl = parentControl or MailBuddy.recipientsLabel
            doX = doX or -15
            doY = doY or 0
            recipientsLabel:SetHidden(false)
            recipientsLabel:SetMouseEnabled(true)
            MailBuddy_UseRecipientButton:SetHidden(false)
            MailBuddy_UseRecipientButton:SetMouseEnabled(true)
            recipientsBox:ClearAnchors()
            recipientsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
            recipientsBox:SetParent(parentControl)
        end
        if doToggleShowHide then
            if MailBuddy.recipientsBox:IsHidden() then
                MailBuddy.GetZOMailRecipient()
                recipientsBox:SetHidden(false)
                MailBuddy.editRecipient:TakeFocus()
                if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
            else
                if  ( (not settings.useAlternativeLayout and settings.additional["RecipientsBoxVisibility"])
                  or  (settings.useAlternativeLayout) ) then
                    recipientsBox:SetHidden(true)
                    if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
                end
            end
        end
        if doCloseNow then
            ZO_Tooltips_HideTextTooltip()
            recipientsBox:SetHidden(true)
            if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
        elseif doShowNow then
            recipientsBox:SetHidden(false)
            if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
        end
    elseif boxType == "subjects" then
        local subjectsBox = MailBuddy.subjectsBox
        if settings.useAlternativeLayout then
            parentControl = parentControl or ZO_MailSendSubjectField
            doX = doX or -20
            doY = doY or 0
            MailBuddy_MailSendSubjectLabel:SetHidden(true)
            MailBuddy_MailSendSubjectLabel:SetMouseEnabled(false)
            MailBuddy_UseSubjectButton:SetHidden(true)
            MailBuddy_UseSubjectButton:SetMouseEnabled(false)
            subjectsBox:ClearAnchors()
            subjectsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
            subjectsBox:SetParent(parentControl)
        else
            parentControl = parentControl or MailBuddy.subjectsLabel
            doX = doX or 0
            doY = doY or 10
            MailBuddy_MailSendSubjectLabel:SetHidden(false)
            MailBuddy_MailSendSubjectLabel:SetMouseEnabled(true)
            MailBuddy_UseSubjectButton:SetHidden(false)
            MailBuddy_UseSubjectButton:SetMouseEnabled(true)
            subjectsBox:ClearAnchors()
            subjectsBox:SetAnchor(TOP, parentControl, BOTTOM, doX, doY)
            subjectsBox:SetParent(parentControl)
        end
        if doToggleShowHide then
            if subjectsBox:IsHidden() then
                MailBuddy.GetZOMailSubject()
                subjectsBox:SetHidden(false)
                MailBuddy.editSubject:TakeFocus()
                if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
            else
                if  ( (not settings.useAlternativeLayout and settings.additional["SubjectsBoxVisibility"])
                  or  (settings.useAlternativeLayout) ) then
                    subjectsBox:SetHidden(true)
                    if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
                end
            end
        end
        if doCloseNow then
            ZO_Tooltips_HideTextTooltip()
            subjectsBox:SetHidden(true)
            if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
        elseif doShowNow then
            subjectsBox:SetHidden(false)
            if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
        else
        end
    end
end

--Close the recipients/subjects lists automatically
function MailBuddy.AutoCloseBox(boxType, doOverride)
    if boxType == nil or boxType == "" then return end
    doOverride = doOverride or false
    local isGuildRoster = false
    local isFriendsList = false

    if friendsList ~= nil and not friendsList:IsHidden() then isFriendsList = true
    elseif guildRoster ~= nil and not guildRoster:IsHidden() then isGuildRoster = true end

    local settingsAutoClose = MailBuddy.settingsVars.settings.automatism.close
    if    (boxType == "subjects" and (doOverride or settingsAutoClose["SubjectsBox"]))
       or (boxType == "recipients" and (doOverride or settingsAutoClose["RecipientsBox"])) then
        MailBuddy.ShowBox(boxType, false, true, false, false)
    end
end


------------------------------------------------------------------------------------------------------------------------
--Other functions
function MailBuddy.RememberMailData()
    --Remember the last used recipient and subject text
    MailBuddy.settingsVars.settings.remember.recipient["text"] = MailBuddy.GetZOMailRecipient(true)
    MailBuddy.settingsVars.settings.remember.subject["text"]   = MailBuddy.GetZOMailSubject(true)
    MailBuddy.settingsVars.settings.remember.body["text"]      = MailBuddy.GetZOMailBody()
end



------------------------------------------------------------------------------------------------------------------------
--SOUND functions
function MailBuddy.PlaySoundNow(soundName, itemSoundCategory, itemSoundAction)
    --Only play sounds if enabled in settings
    if MailBuddy.settingsVars.settings.playSounds == false then return end
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

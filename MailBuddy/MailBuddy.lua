    --The addon table/array
    MailBuddy = {}
    --Information about the addon
    MailBuddy.addonVars = {}
    MailBuddy.addonVars.name = "MailBuddy"
    MailBuddy.addonVars.displayName = "|cFFFF00MailBuddy|r"
    MailBuddy.addonVars.author = "|cFF0000Minceraft|r and |cFFFF00Baertram|r"
	MailBuddy.addonVars.addonVersionOptionsNumber = 3.1
    MailBuddy.addonVars.version = tostring(MailBuddy.addonVars.addonVersionOptionsNumber)

    MailBuddy.addonVars.savedVariablesName = "MailBuddy_SavedVars"
    MailBuddy.addonVars.gSettingsLoaded = false

    --Librraies
    local LAM = LibAddonMenu2
    if LAM == nil and LibStub then LAM = LibStub('LibAddonMenu-2.0') end
    local LMP = LibMediaProvider
    if LMP == nil and LibStub then LMP = LibStub('LibMediaProvider-1.0') end
    local LIBLA = LibLoadedAddons
    if LIBLA == nil and LibStub then LIBLA = LibStub('LibLoadedAddons') end

    --The arrays for the saved variables
    MailBuddy.settingsVars	= {}
    MailBuddy.settingsVars.settingsVersion = 2.4
    MailBuddy.settingsVars.fontStyles = {
        "none",
        "outline",
        "thin-outline",
        "thick-outline",
        "shadow",
        "soft-shadow-thin",
        "soft-shadow-thick",
    }
    --Additional settings arrays for the first run of this addon, default values, etc.
    MailBuddy.settingsVars.settings			= {}
    MailBuddy.settingsVars.defaultSettings	= {}
    MailBuddy.settingsVars.firstRunSettings = {}
    MailBuddy.settingsVars.defaults			= {}

    --The LAM settings panel
	MailBuddy.SettingsPanel = nil

    --Array with prevention variables
    MailBuddy.preventerVars = {}
    MailBuddy.preventerVars.gLocalizationDone = false
    MailBuddy.preventerVars.KeyBindingTexts   = false
    MailBuddy.preventerVars.dontUseLastRecipientName = false

	--Build list of saved text controls for the recipients
	MailBuddy.recipientPages = {}
    MailBuddy.recipientPages.pages = {}
	--Page 1
    MailBuddy.recipientPages.pages[1] = {}
    table.insert(MailBuddy.recipientPages.pages[1], 1, "MailBuddy_RecipientsPage1CustomRecipientLabel1")
    table.insert(MailBuddy.recipientPages.pages[1], 2, "MailBuddy_RecipientsPage1CustomRecipientLabel2")
    table.insert(MailBuddy.recipientPages.pages[1], 3, "MailBuddy_RecipientsPage1CustomRecipientLabel3")
    table.insert(MailBuddy.recipientPages.pages[1], 4, "MailBuddy_RecipientsPage1CustomRecipientLabel4")
    table.insert(MailBuddy.recipientPages.pages[1], 5, "MailBuddy_RecipientsPage1CustomRecipientLabel5")
    table.insert(MailBuddy.recipientPages.pages[1], 6, "MailBuddy_RecipientsPage1CustomRecipientLabel6")
    table.insert(MailBuddy.recipientPages.pages[1], 7, "MailBuddy_RecipientsPage1CustomRecipientLabel7")
	--Page 2
    MailBuddy.recipientPages.pages[2] = {}
    table.insert(MailBuddy.recipientPages.pages[2], 1, "MailBuddy_RecipientsPage2CustomRecipientLabel8")
    table.insert(MailBuddy.recipientPages.pages[2], 2, "MailBuddy_RecipientsPage2CustomRecipientLabel9")
    table.insert(MailBuddy.recipientPages.pages[2], 3, "MailBuddy_RecipientsPage2CustomRecipientLabel10")
    table.insert(MailBuddy.recipientPages.pages[2], 4, "MailBuddy_RecipientsPage2CustomRecipientLabel11")
    table.insert(MailBuddy.recipientPages.pages[2], 5, "MailBuddy_RecipientsPage2CustomRecipientLabel12")
    table.insert(MailBuddy.recipientPages.pages[2], 6, "MailBuddy_RecipientsPage2CustomRecipientLabel13")
    table.insert(MailBuddy.recipientPages.pages[2], 7, "MailBuddy_RecipientsPage2CustomRecipientLabel14")
	--Page 3
    MailBuddy.recipientPages.pages[3] = {}
    table.insert(MailBuddy.recipientPages.pages[3], 1, "MailBuddy_RecipientsPage3CustomRecipientLabel15")
    table.insert(MailBuddy.recipientPages.pages[3], 2, "MailBuddy_RecipientsPage3CustomRecipientLabel16")
    table.insert(MailBuddy.recipientPages.pages[3], 3, "MailBuddy_RecipientsPage3CustomRecipientLabel17")
    table.insert(MailBuddy.recipientPages.pages[3], 4, "MailBuddy_RecipientsPage3CustomRecipientLabel18")
    table.insert(MailBuddy.recipientPages.pages[3], 5, "MailBuddy_RecipientsPage3CustomRecipientLabel19")
    table.insert(MailBuddy.recipientPages.pages[3], 6, "MailBuddy_RecipientsPage3CustomRecipientLabel20")
    table.insert(MailBuddy.recipientPages.pages[3], 7, "MailBuddy_RecipientsPage3CustomRecipientLabel21")

	--Variables for the entries on recipient pages
    MailBuddy.recipientPages.entriesPerPage = 7
    MailBuddy.recipientPages.totalEntries = 21
    MailBuddy.recipientPages.maxEntriesUntilHere = {}
    MailBuddy.recipientPages.maxEntriesUntilHere[1] = 7
    MailBuddy.recipientPages.maxEntriesUntilHere[2] = 14
    MailBuddy.recipientPages.maxEntriesUntilHere[3] = 21
    MailBuddy.recipientPages.selectedLabel = "MailBuddy_MailSendRecipientLabelActiveText"

	--Build list of saved text controls for the subjects
	MailBuddy.subjectPages = {}
    MailBuddy.subjectPages.pages = {}
	--Page 1
    MailBuddy.subjectPages.pages[1] = {}
    table.insert(MailBuddy.subjectPages.pages[1], 1, "MailBuddy_SubjectsPage1CustomSubjectLabel1")
    table.insert(MailBuddy.subjectPages.pages[1], 2, "MailBuddy_SubjectsPage1CustomSubjectLabel2")
    table.insert(MailBuddy.subjectPages.pages[1], 3, "MailBuddy_SubjectsPage1CustomSubjectLabel3")
    table.insert(MailBuddy.subjectPages.pages[1], 4, "MailBuddy_SubjectsPage1CustomSubjectLabel4")
    table.insert(MailBuddy.subjectPages.pages[1], 5, "MailBuddy_SubjectsPage1CustomSubjectLabel5")
	--Page 2
    MailBuddy.subjectPages.pages[2] = {}
    table.insert(MailBuddy.subjectPages.pages[2], 1, "MailBuddy_SubjectsPage2CustomSubjectLabel6")
    table.insert(MailBuddy.subjectPages.pages[2], 2, "MailBuddy_SubjectsPage2CustomSubjectLabel7")
    table.insert(MailBuddy.subjectPages.pages[2], 3, "MailBuddy_SubjectsPage2CustomSubjectLabel8")
    table.insert(MailBuddy.subjectPages.pages[2], 4, "MailBuddy_SubjectsPage2CustomSubjectLabel9")
    table.insert(MailBuddy.subjectPages.pages[2], 5, "MailBuddy_SubjectsPage2CustomSubjectLabel10")
	--Page 3
    MailBuddy.subjectPages.pages[3] = {}
    table.insert(MailBuddy.subjectPages.pages[3], 1, "MailBuddy_SubjectsPage3CustomSubjectLabel11")
    table.insert(MailBuddy.subjectPages.pages[3], 2, "MailBuddy_SubjectsPage3CustomSubjectLabel12")
    table.insert(MailBuddy.subjectPages.pages[3], 3, "MailBuddy_SubjectsPage3CustomSubjectLabel13")
    table.insert(MailBuddy.subjectPages.pages[3], 4, "MailBuddy_SubjectsPage3CustomSubjectLabel14")
    table.insert(MailBuddy.subjectPages.pages[3], 5, "MailBuddy_SubjectsPage3CustomSubjectLabel15")

	--Variables for the entries on subject pages
    MailBuddy.subjectPages.entriesPerPage = 5
    MailBuddy.subjectPages.totalEntries = 15
    MailBuddy.subjectPages.maxEntriesUntilHere = {}
    MailBuddy.subjectPages.maxEntriesUntilHere[1] = 5
    MailBuddy.subjectPages.maxEntriesUntilHere[2] = 10
    MailBuddy.subjectPages.maxEntriesUntilHere[3] = 15
    MailBuddy.subjectPages.selectedLabel = "MailBuddy_MailSendSubjectLabelActiveText"

	--Boolean value to check if the keybind was pressed
    MailBuddy.keybindUsed = false

	--Get the current player name
    MailBuddy.playerName = GetUnitName("player")
    --get the current account name
    MailBuddy.accountName = GetDisplayName()

    --Maximum characters shown inside the recipients/subjects list (tested with letter W, which is the widest)
    MailBuddy.maximumCharacters = {
    	["recipients"]	= 14,
        ["subjects"]	= 10,
    }
    --MailBuddy controls
    MailBuddy.subjectsBox = nil
    MailBuddy.recipientsBox = nil
    MailBuddy.editSubject = nil
    MailBuddy.editRecipient = nil
    MailBuddy.subjectsLabel = nil
    MailBuddy.recipientsLabel = nil
    MailBuddy.mailSendFromLabel = nil

    --Localization variables
    MailBuddy.localizationVars = {}
    MailBuddy.localizationVars.mb_loc 	 	= {}

    --Keybindstrip variables
    local keystripDefCopyFriend         = {}
    local keystripDefCopyGuildMember    = {}

    --Backup the edit click sound
    SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"] = SOUNDS["EDIT_CLICK"]

    local otherAddons = {}
    otherAddons.isMailRActive = false

    --Localized texts etc.
    function MailBuddy.Localization()
        --Was localization already done during keybindings? Then abort here
        if MailBuddy.preventerVars.KeyBindingTexts == true and MailBuddy.preventerVars.gLocalizationDone == true then return end

        --Fallback to english
        if (MailBuddy.settingsVars.defaultSettings.language == nil or (MailBuddy.settingsVars.defaultSettings.language ~= 1 and MailBuddy.settingsVars.defaultSettings.language ~= 2 and MailBuddy.settingsVars.defaultSettings.language ~= 3 and MailBuddy.settingsVars.defaultSettings.language ~= 4 and MailBuddy.settingsVars.defaultSettings.language ~= 5)) then
            MailBuddy.settingsVars.defaultSettings.language = 1
        end
        --Is the standard language english set?
        if (MailBuddy.preventerVars.KeyBindingTexts == true or (MailBuddy.settingsVars.defaultSettings.language == 1 and MailBuddy.settingsVars.settings.languageChoosen == false)) then
            local lang = GetCVar("language.2")
            --Check for supported languages
            if(lang == "de") then
                MailBuddy.settingsVars.defaultSettings.language = 2
            elseif (lang == "en") then
                MailBuddy.settingsVars.defaultSettings.language = 1
            elseif (lang == "fr") then
                MailBuddy.settingsVars.defaultSettings.language = 3
            elseif (lang == "es") then
                MailBuddy.settingsVars.defaultSettings.language = 4
            elseif (lang == "it") then
                MailBuddy.settingsVars.defaultSettings.language = 5
            else
                MailBuddy.settingsVars.defaultSettings.language = 1
            end
        end
        MailBuddy.localizationVars.mb_loc = {}
        MailBuddy.localizationVars.mb_loc = mb_loc[MailBuddy.settingsVars.defaultSettings.language]

        MailBuddy.preventerVars.gLocalizationDone = true
        --Abort here if we only needed the keybinding texts
        if MailBuddy.preventerVars.KeyBindingTexts == true then return end
    end

    --Global function to get text for the keybindings etc.
    function MailBuddy.GetLocText(textName, isKeybindingText)
        isKeybindingText = isKeybindingText or false
        MailBuddy.preventerVars.KeyBindingTexts = isKeybindingText
        --Do the localization now
        MailBuddy.Localization()
        if textName == nil or MailBuddy.localizationVars.mb_loc == nil or MailBuddy.localizationVars.mb_loc[textName] == nil then return "" end
        return MailBuddy.localizationVars.mb_loc[textName]
    end


    function MailBuddy.ShowBox(boxType, doToggleShowHide, doCloseNow, doShowNow, doPlaySound, parentControl, doX, doY)
        if boxType == "" then return end
        doToggleShowHide = doToggleShowHide or false
        doCloseNow = doCloseNow or false
        doShowNow = doShowNow or false
        doPlaySound = doPlaySound or false
        if boxType == "recipients" then
            if MailBuddy.settingsVars.settings.useAlternativeLayout then
                parentControl = parentControl or ZO_MailSendSubjectField
                doX = doX or -20
                doY = doY or -300
                MailBuddy.recipientsLabel:SetHidden(true)
                MailBuddy.recipientsLabel:SetMouseEnabled(false)
                MailBuddy_UseRecipientButton:SetHidden(true)
                MailBuddy_UseRecipientButton:SetMouseEnabled(false)
                MailBuddy.recipientsBox:ClearAnchors()
                MailBuddy.recipientsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
                MailBuddy.recipientsBox:SetParent(parentControl)
            else
                parentControl = parentControl or MailBuddy.recipientsLabel
                doX = doX or -15
                doY = doY or 0
                MailBuddy.recipientsLabel:SetHidden(false)
                MailBuddy.recipientsLabel:SetMouseEnabled(true)
                MailBuddy_UseRecipientButton:SetHidden(false)
                MailBuddy_UseRecipientButton:SetMouseEnabled(true)
                MailBuddy.recipientsBox:ClearAnchors()
                MailBuddy.recipientsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
                MailBuddy.recipientsBox:SetParent(parentControl)
            end
            if doToggleShowHide then
                if MailBuddy.recipientsBox:IsHidden() then
                    MailBuddy.GetZOMailRecipient()
                    MailBuddy.recipientsBox:SetHidden(false)
                    MailBuddy.editRecipient:TakeFocus()
                    if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
                else
                    if  ( (not MailBuddy.settingsVars.settings.useAlternativeLayout and MailBuddy.settingsVars.settings.additional["RecipientsBoxVisibility"])
                      or  (MailBuddy.settingsVars.settings.useAlternativeLayout) ) then
                        MailBuddy.recipientsBox:SetHidden(true)
                        if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
                    end
                end
            end
            if doCloseNow then
                ZO_Tooltips_HideTextTooltip()
                MailBuddy.recipientsBox:SetHidden(true)
                if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
            elseif doShowNow then
                MailBuddy.recipientsBox:SetHidden(false)
                if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
            end
        elseif boxType == "subjects" then
            if MailBuddy.settingsVars.settings.useAlternativeLayout then
                parentControl = parentControl or ZO_MailSendSubjectField
                doX = doX or -20
                doY = doY or 0
                MailBuddy_MailSendSubjectLabel:SetHidden(true)
                MailBuddy_MailSendSubjectLabel:SetMouseEnabled(false)
                MailBuddy_UseSubjectButton:SetHidden(true)
                MailBuddy_UseSubjectButton:SetMouseEnabled(false)
                MailBuddy.subjectsBox:ClearAnchors()
                MailBuddy.subjectsBox:SetAnchor(TOPRIGHT, parentControl, TOPLEFT, doX, doY)
                MailBuddy.subjectsBox:SetParent(parentControl)
            else
                parentControl = parentControl or MailBuddy.subjectsLabel
                doX = doX or 0
                doY = doY or 10
                MailBuddy_MailSendSubjectLabel:SetHidden(false)
                MailBuddy_MailSendSubjectLabel:SetMouseEnabled(true)
                MailBuddy_UseSubjectButton:SetHidden(false)
                MailBuddy_UseSubjectButton:SetMouseEnabled(true)
                MailBuddy.subjectsBox:ClearAnchors()
                MailBuddy.subjectsBox:SetAnchor(TOP, parentControl, BOTTOM, doX, doY)
                MailBuddy.subjectsBox:SetParent(parentControl)
            end
            if doToggleShowHide then
                if MailBuddy.subjectsBox:IsHidden() then
                    MailBuddy.GetZOMailSubject()
                    MailBuddy.subjectsBox:SetHidden(false)
                    MailBuddy.editSubject:TakeFocus()
                    if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
                else
                    if  ( (not MailBuddy.settingsVars.settings.useAlternativeLayout and MailBuddy.settingsVars.settings.additional["SubjectsBoxVisibility"])
                      or  (MailBuddy.settingsVars.settings.useAlternativeLayout) ) then
                        MailBuddy.subjectsBox:SetHidden(true)
                        if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
                    end
                end
            end
            if doCloseNow then
                ZO_Tooltips_HideTextTooltip()
                MailBuddy.subjectsBox:SetHidden(true)
                if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_CLOSE"]) end
            elseif doShowNow then
                MailBuddy.subjectsBox:SetHidden(false)
                if doPlaySound then MailBuddy.PlaySoundNow(SOUNDS["BOOK_OPEN"]) end
            else
            end
        end
    end

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
        local color = MailBuddy.settingsVars.settings.font[updateWhere][fontArea].color
        local fontPath = LMP:Fetch('font', MailBuddy.settingsVars.settings.font[updateWhere][fontArea].family)
        local fontString = string.format('%s|%u|%s', fontPath, MailBuddy.settingsVars.settings.font[updateWhere][fontArea].size, MailBuddy.settingsVars.settings.font[updateWhere][fontArea].style)
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
                    if ctrlNr == -1 or ctrlNr == labelnr then
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
                    if ctrlNr == -1 or ctrlNr == labelnr then
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

    --=============================================================================================================
    --	LOAD USER SETTINGS
    --=============================================================================================================
    --Load the SavedVariables now
    function MailBuddy.LoadUserSettings()
        if not MailBuddy.addonVars.gSettingsLoaded then
            --Prepare the keybindings in the keybindstrip
            keystripDefCopyFriend = {
                {
                    name = MailBuddy.GetLocText("SI_BINDING_NAME_MAILBUDDY_FRIEND_COPY", true),
                    keybind = "MAILBUDDY_COPY",
                    callback = function() MailBuddy.CopyNameUnderControl() end,
                    alignment = KEYBIND_STRIP_ALIGN_CENTER,
                }
            }
            keystripDefCopyGuildMember = {
                {
                    name = MailBuddy.GetLocText("SI_BINDING_NAME_MAILBUDDY_GUILD_MEMBER_COPY", true),
                    keybind = "MAILBUDDY_COPY",
                    callback = function() MailBuddy.CopyNameUnderControl() end,
                    alignment = KEYBIND_STRIP_ALIGN_CENTER,
                }
            }

            --The default settings (loaded if no SavedVariables are given)
            MailBuddy.settingsVars.defaults = {
                curRecipient						= "",
                curRecipientAbbreviated				= "",
                curSubject 							= "RETURN",
                curSubjectAbbreviated				= "RETURN",
                curRecipientPage 					= "1",
                lastRecipientPage                   = "0",
                curSubjectPage 			 			= "1",
                lastSubjectPage 			 		= "0",
                remember                    = {
                    recipient                   = {
                        ["last"]                    = false,
                        ["text"]                    = "",
                    },
                    subject                     = {
                        ["last"]                    = false,
                        ["text"]                    = "",
                    },
                    body                     = {
                        ["last"]                    = false,
                        ["text"]                    = "",
                    },
                },
                lastShown                   = {
                    recipients                  = {
                        ["FriendsList"]             = false,
                        ["GuildRoster"]             = false,
                        ["MailSend"]                = false,
                    },
                    subjects                    = {
                        ["FriendsList"]             = false,
                        ["GuildRoster"]             = false,
                        ["MailSend"]                = false,
                    },
                },
                SetRecipient 				= {},
                SetRecipientAbbreviated		= {},
                SetSubject 					= {},
                SetSubjectAbbreviated		= {},
                playSounds                  = true,
                standard					= {
                    ["To"]							= "",
                    ["Subject"]						= "",
                },
                automatism              = {
                    close					= {
                        ["RecipientsList"] 			= false,
                        ["SubjectsList"]   			= false,
                    },
                    focus					= {
                        ["To"] 				        = false,
                        ["Subject"]   				= false,
                        ["Body"]                    = false,
                    },
                    hide					= {
                        ["RecipientsList"] 			= false,
                        ["SubjectsList"]   			= false,
                    },
                    focusOpen				= {
                        ["To"] 				        = false,
                        ["Subject"]   				= false,
                    },
                },
                additional					= {
                    ["RecipientsBoxVisibility"]		= true,
                    ["SubjectsBoxVisibility"]   	= true,
                },
                useAlternativeLayout				= false,
                showAlternativeLayoutTooltip        = false,
                font = {
                    ["recipients"]  = {
                        [1] =                   {
                                        family 	= "STONE_TABLET_FONT",
                                        size    = 18,
                                        style	= "shadow",
                                        color	= {
                                            ["r"] = 1,
                                            ["g"] = 1,
                                            ["b"] = 1,
                                            ["a"] = 1
                                        }
                        },
                        [2] =                   {
                                        family 	= "Univers 55",
                                        size    = 14,
                                        style	= "none",
                                        color	= {
                                            ["r"] = 1,
                                            ["g"] = 1,
                                            ["b"] = 1,
                                            ["a"] = 1
                                        }
                        },
                    },
                    ["subjects"] = {
                        [1] =                   {
                            family 	= "STONE_TABLET_FONT",
                            size    = 18,
                            style	= "shadow",
                            color	= {
                                ["r"] = 1,
                                ["g"] = 1,
                                ["b"] = 1,
                                ["a"] = 1
                            }
                        },
                        [2] =                   {
                            family 	= "Univers 55",
                            size    = 14,
                            style	= "none",
                            color	= {
                                ["r"] = 1,
                                ["g"] = 1,
                                ["b"] = 1,
                                ["a"] = 1
                            }
                        },
                    }
                },
                showAccountName 			= false,
                showCharacterName 		  	= false,
				showTotalMailCountInInbox	= false,
            }

            --The default values for the language and save mode
            MailBuddy.settingsVars.firstRunSettings = {
                language 	 		    = 1, --Standard: English
                saveMode     		    = 2, --Standard: Account wide MailBuddy.settingsVars.settings
            }

            --=========== BEGIN - SAVED VARIABLES ==========================================
            --Load the user's MailBuddy.settingsVars.settings from SavedVariables file -> Account wide of basic version 999 at first
            MailBuddy.settingsVars.defaultSettings = ZO_SavedVars:NewAccountWide(MailBuddy.addonVars.savedVariablesName, 999, "SettingsForAll", MailBuddy.settingsVars.firstRunSettings)

            --Check, by help of basic version 999 MailBuddy.settingsVars.settings, if the settings should be loaded for each character or account wide
            --Use the current addon version to read the MailBuddy.settingsVars.settings now
            if (MailBuddy.settingsVars.defaultSettings.saveMode == 1) then
                MailBuddy.settingsVars.settings = ZO_SavedVars:New(MailBuddy.addonVars.savedVariablesName, MailBuddy.settingsVars.settingsVersion , "Settings", MailBuddy.settingsVars.defaults)
            elseif (MailBuddy.settingsVars.defaultSettings.saveMode == 2) then
                MailBuddy.settingsVars.settings = ZO_SavedVars:NewAccountWide(MailBuddy.addonVars.savedVariablesName, MailBuddy.settingsVars.settingsVersion, "Settings", MailBuddy.settingsVars.defaults)
            else
                MailBuddy.settingsVars.settings = ZO_SavedVars:NewAccountWide(MailBuddy.addonVars.savedVariablesName, MailBuddy.settingsVars.settingsVersion, "Settings", MailBuddy.settingsVars.defaults)
            end
            --=========== END - SAVED VARIABLES ============================================

            --Read the settings and set the mail recipient names
            for idx, recipientName in pairs(MailBuddy.settingsVars.settings.SetRecipient) do
                --d("Recipient name: " .. recipientName .. ", index: " .. idx)
                if recipientName ~= "" and not RemoveOwnCharactersFromSavedRecipients(idx, recipientName) then
                    local page, pageEntry = MailBuddy.mapPageAndEntry(idx, "recipient")
                    if page ~= nil and pageEntry ~= nil then
                        local editControl = WINDOW_MANAGER:GetControlByName(MailBuddy.recipientPages.pages[page][pageEntry], "")
                        if editControl ~= nil then
                            local recipientNameAbbreviated = MailBuddy.settingsVars.settings.SetRecipientAbbreviated[idx] or recipientName
                            editControl:SetText(string.format(recipientNameAbbreviated))
                            MailBuddy.UpdateEditFieldToolTip(editControl, recipientName, recipientNameAbbreviated)
                        end
                    end
                end
            end

            --Read the settings and set the mail subjects
            for idx, subjectText in pairs(MailBuddy.settingsVars.settings.SetSubject) do
                if subjectText ~= "" then
                    local page, pageEntry = MailBuddy.mapPageAndEntry(idx, "subject")
                    if page ~= nil and pageEntry ~= nil then
                        local subjectEditControl = WINDOW_MANAGER:GetControlByName(MailBuddy.subjectPages.pages[page][pageEntry], "")
                        if subjectEditControl ~= nil then
                            local subjectTextAbbreviated = MailBuddy.settingsVars.settings.SetSubjectAbbreviated[idx] or subjectText
                            subjectEditControl:SetText(string.format(subjectTextAbbreviated))
                            MailBuddy.UpdateEditFieldToolTip(subjectEditControl, subjectText, subjectTextAbbreviated)
                        end
                    end
                end
            end

            --Set settings = loaded
            MailBuddy.addonVars.gSettingsLoaded = true
        end
        --=============================================================================================================
    end

    local function PlayerActivatedCallback(event)
	   -- zo_callLater(MailBuddyGetMail(), 2500)
	    EVENT_MANAGER:UnregisterForEvent(MailBuddy.addonVars.name, eventCode)

        --Update the anchors and positions of the recipients and subjects list
        MailBuddy.ShowBox("recipients", false, false, false, false)
        MailBuddy.ShowBox("subjects", false, false, false, false)

       --Add new recipient and new subject into an edit group and add autocomplete for the recipient name
	    local editControlGroup = ZO_EditControlGroup:New()
	    MailBuddy.autoCompleteRecipient = ZO_AutoComplete:New(MailBuddy_MailSendRecipientsBoxEditNewRecipient, { AUTO_COMPLETE_FLAG_ALL }, nil, AUTO_COMPLETION_ONLINE_OR_OFFLINE, MAX_AUTO_COMPLETION_RESULTS)
        editControlGroup:AddEditControl(MailBuddy_MailSendRecipientsBoxEditNewRecipient, MailBuddy.autoCompleteRecipient)
        editControlGroup:AddEditControl(MailBuddy_MailSendSubjectsBoxEditNewSubject, nil)
	end

    --Add button to the friends list to show recipients list
    local function AddButtonToFriendsList()
		if ZO_KeyboardFriendsList ~= nil and not ZO_KeyboardFriendsList:IsHidden() then
            --Automatically hide the recipients box?
            local doHide = MailBuddy.settingsVars.settings.automatism.hide["RecipientsBox"]
            local doOpen = MailBuddy.settingsVars.settings.lastShown.recipients["FriendsList"]
            if doOpen == false then
                doHide = true
            end
            MailBuddy.ShowBox("recipients", false, doHide, doOpen, false, ZO_KeyboardFriendsList, -16, 0)

			--Add a button to the friends list, at top left corner near the "online status icon" to show/hide MailBuddy
	        if ZO_DisplayNameStatusSelectedItem ~= nil then
	        	if MailBuddy_FriendsToggleButton == nil then
					--Create the button control at the parent
					local button = WINDOW_MANAGER:CreateControl("MailBuddy_FriendsToggleButton", ZO_KeyboardFriendsList, CT_BUTTON)
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
                            MailBuddy.ShowBox("recipients", true, false, false, true, ZO_KeyboardFriendsList, -16, 0)
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
            local doHide = MailBuddy.settingsVars.settings.automatism.hide["RecipientsBox"]
            local doOpen = MailBuddy.settingsVars.settings.lastShown.recipients["GuildRoster"]
            if doOpen == false then
                doHide = true
            end
            MailBuddy.ShowBox("recipients", false, doHide, doOpen, false, ZO_GuildRoster, -16, 0)

            --Add a button to the guild roster, at top left corner near the "online status icon" to show/hide MailBuddy
            if ZO_DisplayNameStatusSelectedItem ~= nil then
                if MailBuddy_GuildRosterToggleButton == nil then
                    --Create the button control at the parent
                    local button = WINDOW_MANAGER:CreateControl("MailBuddy_GuildRosterToggleButton", ZO_GuildRoster, CT_BUTTON)
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
                            MailBuddy.ShowBox("recipients", true, false, false, true, ZO_GuildRoster, -16, 0)
                        end)
                        button:SetHidden(false)
                    end
                end
            end
        end
	end

    function MailBuddy.PlaySoundNow(soundName, itemSoundCategory, itemSoundAction)
        --Only play sounds if enabled ins ettings
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

	function MailBuddy.CopyNameUnderControl()
		local mouseOverControl = WINDOW_MANAGER:GetMouseOverControl()
		if (mouseOverControl:GetName():find("^ZO_KeyboardFriendsListList1Row%d+DisplayName*" or "^ZO_KeyboardFriendsListList1Row%d%d+DisplayName*" )) then
			MailBuddy.editRecipient:SetText(string.format(mouseOverControl:GetText()))
		elseif (mouseOverControl:GetName():find("^ZO_GuildRosterList1Row%d+DisplayName*" or "^ZO_GuildRosterList1Row%d%d+DisplayName*" )) then
			MailBuddy.editRecipient:SetText(string.format(mouseOverControl:GetText()))
		end
	end

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

	local function GetMouseOverFriends(mouseOverControl)
		if (not ZO_KeyboardFriendsList:IsHidden()) then
				KEYBIND_STRIP:AddKeybindButtonGroup(keystripDefCopyFriend)
		else
			KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyFriend)
            KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyGuildMember)
		end
	end

	local function GetMouseOverGuildMembers(mouseOverControl)
		if (not ZO_GuildRoster:IsHidden()) then
            KEYBIND_STRIP:AddKeybindButtonGroup(keystripDefCopyGuildMember)
		else
            KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyFriend)
			KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyGuildMember)
		end
	end

    --Set the Mail-Brain "last used" mail recipient and subject for new mails
    local function SetRememberedRecipientSubjectAndBody()
        if MailBuddy.settingsVars.settings.remember.recipient["last"] and ZO_MailSendToField ~= nil and MailBuddy.settingsVars.settings.remember.recipient["text"] ~= nil and MailBuddy.settingsVars.settings.remember.recipient["text"] ~= "" then
            if not MailBuddy.preventerVars.dontUseLastRecipientName and ZO_MailSendToField:GetText() == "" then
                ZO_MailSendToField:SetText(string.format(MailBuddy.settingsVars.settings.remember.recipient["text"]))
            end
        end
        if MailBuddy.settingsVars.settings.remember.subject["last"] and ZO_MailSendSubjectField ~= nil and MailBuddy.settingsVars.settings.remember.subject["text"] ~= nil and MailBuddy.settingsVars.settings.remember.subject["text"] ~= "" then
            zo_callLater(function()
                ZO_MailSendSubjectField:SetText(string.format(MailBuddy.settingsVars.settings.remember.subject["text"]))
            end, 50)
        end
        if MailBuddy.settingsVars.settings.remember.body["last"] and ZO_MailSendBodyField ~= nil and MailBuddy.settingsVars.settings.remember.body["text"] ~= nil and MailBuddy.settingsVars.settings.remember.body["text"] ~= "" then
            ZO_MailSendBodyField:SetText(string.format(MailBuddy.settingsVars.settings.remember.body["text"]))
        end
    end

    --Set the standard mail recipient and subject for new mails
	local function SetStandardRecipientAndSubject()
    	if not MailBuddy.settingsVars.settings.remember.recipient["last"] and ZO_MailSendToField ~= nil and MailBuddy.settingsVars.settings.standard["To"] ~= nil and MailBuddy.settingsVars.settings.standard["To"] ~= "" then
            ZO_MailSendToField:SetText(MailBuddy.settingsVars.settings.standard["To"])
	    end
	 	if not MailBuddy.settingsVars.settings.remember.subject["last"] and ZO_MailSendSubjectField ~= nil and MailBuddy.settingsVars.settings.standard["Subject"] ~= nil and MailBuddy.settingsVars.settings.standard["Subject"] ~= "" then
            ZO_MailSendSubjectField:SetText(MailBuddy.settingsVars.settings.standard["Subject"])
        end
	end

--------------------------------------------------------------------------------
	--Create the options panel with LAM 2.0
    --BuildAddonMenu
	function MailBuddy.CreateLAMPanel()
		local panelData = {
			type 				= 'panel',
			name 				= MailBuddy.addonVars.name,
			displayName 		= MailBuddy.addonVars.displayName,
			author 				= MailBuddy.addonVars.author,
			version 			= MailBuddy.addonVars.version,
			registerForRefresh 	= true,
			registerForDefaults = true,
			slashCommand 		= "/mbs",
		}
		MailBuddy.SettingsPanel = LAM:RegisterAddonPanel(MailBuddy.addonVars.name.."panel", panelData)

    --[[ Try to add auto complete to LAM 2.o edit box but it doesn't work. Maybe the inherits="ZO_DefaultEditForBackdrop" is relevant?
        local UpdateMailBuddySettingsFields = function(panel)
			if panel == MailBuddy.SettingsPanel then
		        --Update the standard recipient name edit field with an auto complete feature
				if MailBuddy_StandardRecipientName_SettingsEdit ~= nil then
				    local editControlGroup = ZO_EditControlGroup:New()
				    MailBuddy.autoCompleteRecipientSettings = ZO_AutoComplete:New(MailBuddy_StandardRecipientName_SettingsEdit, { AUTO_COMPLETE_FLAG_ALL }, nil, AUTO_COMPLETION_ONLINE_OR_OFFLINE, MAX_AUTO_COMPLETION_RESULTS)
			        editControlGroup:AddEditControl(MailBuddy_StandardRecipientName_SettingsEdit, MailBuddy.autoCompleteRecipientSettings)
		        end
				CALLBACK_MANAGER:UnregisterCallback("LAM-RefreshPanel", UpdateMailBuddySettingsFields)
			end
		end
		CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", UpdateMailBuddySettingsFields)
    ]]

        --The preview label for the fon's data inside the LAM settings panel for this addon (left to the font dropdown box)
        local previewLabel1
        local previewLabel2
        local previewLabel3
        local previewLabel4
        local fontPreview = function(panel)
            if panel == MailBuddy.SettingsPanel then
                previewLabel1 = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[10], CT_LABEL)
                previewLabel1:SetAnchor(RIGHT, panel.controlsToRefresh[10].dropdown:GetControl(), LEFT, -10, 0)
                previewLabel1:SetText("@Accountname")
                previewLabel1:SetHidden(false)
                MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)

                previewLabel2 = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[14], CT_LABEL)
                previewLabel2:SetAnchor(RIGHT, panel.controlsToRefresh[14].dropdown:GetControl(), LEFT, -10, 0)
                previewLabel2:SetText("Character name")
                previewLabel2:SetHidden(false)
                MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)

                previewLabel3 = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[18], CT_LABEL)
                previewLabel3:SetAnchor(RIGHT, panel.controlsToRefresh[18].dropdown:GetControl(), LEFT, -10, 0)
                previewLabel3:SetText("SUBJECT")
                previewLabel3:SetHidden(false)
                MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)

                previewLabel4 = WINDOW_MANAGER:CreateControl(nil, panel.controlsToRefresh[22], CT_LABEL)
                previewLabel4:SetAnchor(RIGHT, panel.controlsToRefresh[22].dropdown:GetControl(), LEFT, -10, 0)
                previewLabel4:SetText("Subject")
                previewLabel4:SetHidden(false)
                MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 4)
                CALLBACK_MANAGER:UnregisterCallback("LAM-RefreshPanel", fontPreview)
            end
        end
        CALLBACK_MANAGER:RegisterCallback("LAM-PanelControlsCreated", fontPreview)

        local languageOptions = {
            [1] = MailBuddy.localizationVars.mb_loc["options_language_dropdown_selection1"],
            [2] = MailBuddy.localizationVars.mb_loc["options_language_dropdown_selection2"],
            [3] = MailBuddy.localizationVars.mb_loc["options_language_dropdown_selection3"],
            [4] = MailBuddy.localizationVars.mb_loc["options_language_dropdown_selection4"],
            [5] = MailBuddy.localizationVars.mb_loc["options_language_dropdown_selection5"],
        }

        local savedVariablesOptions = {
            [1] = MailBuddy.localizationVars.mb_loc["options_savedVariables_dropdown_selection1"],
            [2] = MailBuddy.localizationVars.mb_loc["options_savedVariables_dropdown_selection2"],
        }

		local optionsTable =
	    {	-- BEGIN OF OPTIONS TABLE
			{
				type = 'description',
				text = MailBuddy.localizationVars.mb_loc["options_description"],
			},
	--==============================================================================
            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_header1"],
            },
            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_language"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_language_tooltip"],
                choices = languageOptions,
                getFunc = function() return languageOptions[MailBuddy.settingsVars.defaultSettings.language] end,
                setFunc = function(value)
                    for i,v in pairs(languageOptions) do
                        if v == value then
                            MailBuddy.settingsVars.defaultSettings.language = i
                            --Tell the settings that you have manually chosen the language and want to keep it
                            --Read in function MailBuddy.Localization() after ReloadUI()
                            MailBuddy.settingsVars.settings.languageChoosen = true
                            ReloadUI()
                        end
                    end
                end,
                warning = MailBuddy.localizationVars.mb_loc["options_language_description1"],
            },
            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_savedvariables"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_savedvariables_tooltip"],
                choices = savedVariablesOptions,
                getFunc = function() return savedVariablesOptions[MailBuddy.settingsVars.defaultSettings.saveMode] end,
                setFunc = function(value)
                    for i,v in pairs(savedVariablesOptions) do
                        if v == value then
                            MailBuddy.settingsVars.defaultSettings.saveMode = i
                            ReloadUI()
                        end
                    end
                end,
                warning = MailBuddy.localizationVars.mb_loc["options_language_description1"],
            },
			{
	        	type = 'header',
	        	name = MailBuddy.localizationVars.mb_loc["options_appearance"],
	        },
            {
				type = "checkbox",
				name = MailBuddy.localizationVars.mb_loc["options_alternative_layout"],
				tooltip = MailBuddy.localizationVars.mb_loc["options_alternative_layout_tooltip"],
				getFunc = function() return MailBuddy.settingsVars.settings.useAlternativeLayout end,
				setFunc = function(value)
                	MailBuddy.settingsVars.settings.useAlternativeLayout = not MailBuddy.settingsVars.settings.useAlternativeLayout
                    MailBuddy.ShowBox("recipients", false, false, false, false)
                    MailBuddy.ShowBox("subjects", false, false, false, false)
                    MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip = MailBuddy.settingsVars.settings.useAlternativeLayout
                end,
	            default = MailBuddy.settingsVars.settings.useAlternativeLayout,
	            width   = "full",
			},
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_show_alternative_layout_tooltip"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_show_alternative_layout_tooltip_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip end,
                setFunc = function(value)
                    MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip = not MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip
                end,
                default = MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip,
                width   = "full",
                disabled = function() return not MailBuddy.settingsVars.settings.useAlternativeLayout end
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_play_sounds"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_play_sounds_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.playSounds end,
                setFunc = function(value)
                    MailBuddy.settingsVars.settings.playSounds = not MailBuddy.settingsVars.settings.playSounds
                end,
                default = MailBuddy.settingsVars.settings.playSounds,
                width   = "full",
            },

            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_fonts"],
            },
            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_recipient_label"],
                choices = LMP:List('font'),
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][1].family end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["recipients"][1].family = value
                    MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
                end,
                default = MailBuddy.settingsVars.settings.font["recipients"][1].family,
            },
            {
                type = "slider",
                name = MailBuddy.localizationVars.mb_loc["options_font_recipient_label_size"],
                min = 8,
                max = 32,
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][1].size end,
                setFunc = function(size) MailBuddy.settingsVars.settings.font["recipients"][1].size = size
                    MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
                end,
                default = MailBuddy.settingsVars.settings.font["recipients"][1].size,
            },
            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_recipient_label_style"],
                choices = MailBuddy.settingsVars.fontStyles,
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][1].style end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["recipients"][1].style = value
                    MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["recipients"][1].style,
            },
            {
                type = "colorpicker",
                name = MailBuddy.localizationVars.mb_loc["options_font_recipient_label_color"],
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][1].color.r, MailBuddy.settingsVars.settings.font["recipients"][1].color.g, MailBuddy.settingsVars.settings.font["recipients"][1].color.b, MailBuddy.settingsVars.settings.font["recipients"][1].color.a end,
                setFunc = function(r,g,b,a) MailBuddy.settingsVars.settings.font["recipients"][1].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                    MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["recipients"][1].color,
            },

            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_recipients_box"],
                choices = LMP:List('font'),
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][2].family end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["recipients"][2].family = value
                    MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                    MailBuddy.UpdateAllLabels("recipients", -1, -1)
                end,
                default = MailBuddy.settingsVars.settings.font["recipients"][2].family,
            },
            {
                type = "slider",
                name = MailBuddy.localizationVars.mb_loc["options_font_recipients_box_size"],
                min = 8,
                max = 32,
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][2].size end,
                setFunc = function(size) MailBuddy.settingsVars.settings.font["recipients"][2].size = size
                    MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                    MailBuddy.UpdateAllLabels("recipients", -1, -1)
                end,
                default = MailBuddy.settingsVars.settings.font["recipients"][2].size,
            },
            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_recipients_box_style"],
                choices = MailBuddy.settingsVars.fontStyles,
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][2].style end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["recipients"][2].style = value
                    MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                    MailBuddy.UpdateAllLabels("recipients", -1, -1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["recipients"][2].style,
            },
            {
                type = "colorpicker",
                name = MailBuddy.localizationVars.mb_loc["options_font_recipients_box_color"],
                getFunc = function() return MailBuddy.settingsVars.settings.font["recipients"][2].color.r, MailBuddy.settingsVars.settings.font["recipients"][2].color.g, MailBuddy.settingsVars.settings.font["recipients"][2].color.b, MailBuddy.settingsVars.settings.font["recipients"][2].color.a end,
                setFunc = function(r,g,b,a) MailBuddy.settingsVars.settings.font["recipients"][2].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                    MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                    MailBuddy.UpdateAllLabels("recipients", -1, -1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["recipients"][2].color,
            },

            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_subject_label"],
                choices = LMP:List('font'),
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][1].family end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["subjects"][1].family = value
                    MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
                end,
                default = MailBuddy.settingsVars.settings.font["subjects"][1].family,
            },
            {
                type = "slider",
                name = MailBuddy.localizationVars.mb_loc["options_font_subject_label_size"],
                min = 8,
                max = 32,
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][1].size end,
                setFunc = function(size) MailBuddy.settingsVars.settings.font["subjects"][1].size = size
                    MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
                end,
                default = MailBuddy.settingsVars.settings.font["subjects"][1].size,
            },
            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_subject_label_style"],
                choices = MailBuddy.settingsVars.fontStyles,
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][1].style end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["subjects"][1].style = value
                    MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["subjects"][1].style,
            },
            {
                type = "colorpicker",
                name = MailBuddy.localizationVars.mb_loc["options_font_subject_label_color"],
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][1].color.r, MailBuddy.settingsVars.settings.font["subjects"][1].color.g, MailBuddy.settingsVars.settings.font["subjects"][1].color.b, MailBuddy.settingsVars.settings.font["subjects"][1].color.a end,
                setFunc = function(r,g,b,a) MailBuddy.settingsVars.settings.font["subjects"][1].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                    MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                    MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["subjects"][1].color,
            },

            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_subjects_box"],
                choices = LMP:List('font'),
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][2].family end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["subjects"][2].family = value
                    MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                    MailBuddy.UpdateAllLabels("subjects", -1, -1)
                end,
                default = MailBuddy.settingsVars.settings.font["subjects"][2].family,
            },
            {
                type = "slider",
                name = MailBuddy.localizationVars.mb_loc["options_font_subjects_box_size"],
                min = 8,
                max = 32,
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][2].size end,
                setFunc = function(size) MailBuddy.settingsVars.settings.font["subjects"][2].size = size
                    MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                    MailBuddy.UpdateAllLabels("subjects", -1, -1)
                end,
                default = MailBuddy.settingsVars.settings.font["subjects"][2].size,
            },
            {
                type = 'dropdown',
                name = MailBuddy.localizationVars.mb_loc["options_font_subjects_box_style"],
                choices = MailBuddy.settingsVars.fontStyles,
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][2].style end,
                setFunc = function(value) MailBuddy.settingsVars.settings.font["subjects"][2].style = value
                    MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                    MailBuddy.UpdateAllLabels("subjects", -1, -1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["subjects"][2].style,
            },
            {
                type = "colorpicker",
                name = MailBuddy.localizationVars.mb_loc["options_font_subjects_box_color"],
                getFunc = function() return MailBuddy.settingsVars.settings.font["subjects"][2].color.r, MailBuddy.settingsVars.settings.font["subjects"][2].color.g, MailBuddy.settingsVars.settings.font["subjects"][2].color.b, MailBuddy.settingsVars.settings.font["subjects"][2].color.a end,
                setFunc = function(r,g,b,a) MailBuddy.settingsVars.settings.font["subjects"][2].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                    MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                    MailBuddy.UpdateAllLabels("subjects", -1, -1)
                end,
                width = "half",
                default = MailBuddy.settingsVars.settings.font["subjects"][2].color,
            },

            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_additional"],
            },
			{
				type = "checkbox",
				name = MailBuddy.localizationVars.mb_loc["options_toggle_recipients_box_click"],
				tooltip = MailBuddy.localizationVars.mb_loc["options_toggle_recipients_box_click_tooltip"],
				getFunc = function() return MailBuddy.settingsVars.settings.additional["RecipientsBoxVisibility"] end,
				setFunc = function(value) MailBuddy.settingsVars.settings.additional["RecipientsBoxVisibility"] = not MailBuddy.settingsVars.settings.additional["RecipientsBoxVisibility"] end,
	            default = MailBuddy.settingsVars.settings.additional["RecipientsBoxVisibility"],
                disabled = function() return MailBuddy.settingsVars.settings.useAlternativeLayout end,
	            width   = "full",
			},
			{
				type = "checkbox",
				name = MailBuddy.localizationVars.mb_loc["options_toggle_subjects_box_click"],
				tooltip = MailBuddy.localizationVars.mb_loc["options_toggle_subjects_box_click_tooltip"],
				getFunc = function() return MailBuddy.settingsVars.settings.additional["SubjectsBoxVisibility"] end,
				setFunc = function(value) MailBuddy.settingsVars.settings.additional["SubjectsBoxVisibility"] = not MailBuddy.settingsVars.settings.additional["SubjectsBoxVisibility"] end,
	            default = MailBuddy.settingsVars.settings.additional["SubjectsBoxVisibility"],
                disabled = function() return MailBuddy.settingsVars.settings.useAlternativeLayout end,
	            width   = "full",
			},
            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_standard_mail"],
            },
	   		{
				type = "editbox",
				name = MailBuddy.localizationVars.mb_loc["options_standard_recipient"],
				tooltip = MailBuddy.localizationVars.mb_loc["options_standard_recipient_tooltip"],
				getFunc = function() return MailBuddy.settingsVars.settings.standard["To"] end,
				setFunc = function(newValue)
	            	MailBuddy.settingsVars.settings.standard["To"] = newValue
	            end,
				width = "full",
				default = MailBuddy.settingsVars.settings.standard["To"],
                reference = "MailBuddy_StandardRecipientName_SettingsEdit",
                disabled = function() return MailBuddy.settingsVars.settings.remember.recipient["last"] end,
			},
            {
                type = "editbox",
                name = MailBuddy.localizationVars.mb_loc["options_standard_subject"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_standard_subject_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.standard["Subject"] end,
                setFunc = function(newValue)
                    MailBuddy.settingsVars.settings.standard["Subject"] = newValue
                end,
                width = "full",
                default = MailBuddy.settingsVars.settings.standard["Subject"],
                disabled = function() return MailBuddy.settingsVars.settings.remember.subject["last"] end,
            },
            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_mail_brain"],
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_reuse_recipient"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_reuse_recipient_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.remember.recipient["last"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.remember.recipient["last"] = not MailBuddy.settingsVars.settings.remember.recipient["last"] end,
                default = MailBuddy.settingsVars.settings.remember.recipient["last"],
                width   = "full",
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_reuse_subject"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_reuse_subject_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.remember.subject["last"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.remember.subject["last"] = not MailBuddy.settingsVars.settings.remember.subject["last"] end,
                default = MailBuddy.settingsVars.settings.remember.subject["last"],
                width   = "full",
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_reuse_body"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_reuse_body_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.remember.body["last"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.remember.body["last"] = not MailBuddy.settingsVars.settings.remember.body["last"] end,
                default = MailBuddy.settingsVars.settings.remember.body["last"],
                width   = "full",
            },
            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_automatism"],
            },
			{
				type = "checkbox",
				name = MailBuddy.localizationVars.mb_loc["options_auto_hide_recipients_box"],
				tooltip = MailBuddy.localizationVars.mb_loc["options_auto_hide_recipients_box_tooltip"],
				getFunc = function() return MailBuddy.settingsVars.settings.automatism.hide["RecipientsBox"] end,
				setFunc = function(value) MailBuddy.settingsVars.settings.automatism.hide["RecipientsBox"] = not MailBuddy.settingsVars.settings.automatism.hide["RecipientsBox"] end,
	            default = MailBuddy.settingsVars.settings.automatism.hide["RecipientsBox"],
	            width   = "full",
			},
			{
				type = "checkbox",
				name = MailBuddy.localizationVars.mb_loc["options_auto_hide_subjects_box"],
				tooltip = MailBuddy.localizationVars.mb_loc["options_auto_hide_subjects_box_tooltip"],
				getFunc = function() return MailBuddy.settingsVars.settings.automatism.hide["SubjectsBox"] end,
				setFunc = function(value) MailBuddy.settingsVars.settings.automatism.hide["SubjectsBox"] = not MailBuddy.settingsVars.settings.automatism.hide["SubjectsBox"] end,
	            default = MailBuddy.settingsVars.settings.automatism.hide["SubjectsBox"],
	            width   = "full",
			},
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_auto_close_recipients_box"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_auto_close_recipients_box_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.automatism.close["RecipientsBox"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.automatism.close["RecipientsBox"] = not MailBuddy.settingsVars.settings.automatism.close["RecipientsBox"] end,
                default = MailBuddy.settingsVars.settings.automatism.close["RecipientsBox"],
                width   = "full",
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_auto_close_subjects_box"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_auto_close_subjects_box_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.automatism.close["SubjectsBox"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.automatism.close["SubjectsBox"] = not MailBuddy.settingsVars.settings.automatism.close["SubjectsBox"] end,
                default = MailBuddy.settingsVars.settings.automatism.close["SubjectsBox"],
                width   = "full",
            },
            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_autofocus"],
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_auto_focus_recipients_field"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_auto_focus_recipients_field_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.automatism.focus["To"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.automatism.focus["To"] = not MailBuddy.settingsVars.settings.automatism.focus["To"] end,
                default = MailBuddy.settingsVars.settings.automatism.focus["To"],
                width   = "full",
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_auto_focus_auto_open_recipients_field"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_auto_focus_auto_open_recipients_field_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.automatism.focusOpen["To"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.automatism.focusOpen["To"] = not MailBuddy.settingsVars.settings.automatism.focusOpen["To"] end,
                default = MailBuddy.settingsVars.settings.automatism.focusOpen["To"],
				disabled = function() return not MailBuddy.settingsVars.settings.automatism.focus["To"] end,
                width   = "full",
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_auto_focus_subjects_field"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_auto_focus_subjects_field_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.automatism.focus["Subject"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.automatism.focus["Subject"] = not MailBuddy.settingsVars.settings.automatism.focus["Subject"] end,
                default = MailBuddy.settingsVars.settings.automatism.focus["Subject"],
                width   = "full",
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_auto_focus_auto_open_subjects_field"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_auto_focus_auto_open_subjects_field_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.automatism.focusOpen["Subject"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.automatism.focusOpen["Subject"] = not MailBuddy.settingsVars.settings.automatism.focusOpen["Subject"] end,
                default = MailBuddy.settingsVars.settings.automatism.focusOpen["Subject"],
				disabled = function() return not MailBuddy.settingsVars.settings.automatism.focus["Subject"] end,
                width   = "full",
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_auto_focus_body_field"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_auto_focus_body_field_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.automatism.focus["Body"] end,
                setFunc = function(value) MailBuddy.settingsVars.settings.automatism.focus["Body"] = not MailBuddy.settingsVars.settings.automatism.focus["Body"] end,
                default = MailBuddy.settingsVars.settings.automatism.focus["Body"],
                width   = "full",
            },
            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_header_sender"],
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_show_account_name"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_show_account_name_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.showAccountName end,
                setFunc = function(value) MailBuddy.settingsVars.settings.showAccountName = not MailBuddy.settingsVars.settings.showAccountName end,
                default = MailBuddy.settingsVars.settings.showAccountName,
                width   = "full",
                disabled = function() return MailBuddy.settingsVars.settings.showCharacterName end,
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_show_character_name"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_show_character_name_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.showCharacterName end,
                setFunc = function(value) MailBuddy.settingsVars.settings.showCharacterName = not MailBuddy.settingsVars.settings.showCharacterName end,
                default = MailBuddy.settingsVars.settings.showCharacterName,
                width   = "full",
                disabled = function() return MailBuddy.settingsVars.settings.showAccountName end,
            },
            {
                type = 'header',
                name = MailBuddy.localizationVars.mb_loc["options_header_inbox"],
            },
            {
                type = "checkbox",
                name = MailBuddy.localizationVars.mb_loc["options_show_mail_count"],
                tooltip = MailBuddy.localizationVars.mb_loc["options_show_mail_count_tooltip"],
                getFunc = function() return MailBuddy.settingsVars.settings.showTotalMailCountInInbox end,
                setFunc = function(value) MailBuddy.settingsVars.settings.showTotalMailCountInInbox = not MailBuddy.settingsVars.settings.showTotalMailCountInInbox end,
                default = MailBuddy.settingsVars.settings.showTotalMailCountInInbox,
                width   = "full",
            },

		} -- END OF OPTIONS TABLE
		LAM:RegisterOptionControls(MailBuddy.addonVars.name.."panel", optionsTable)
	end
--------------------------------------------------------------------------------

	function MailBuddy.GetPage(pageType, oldPage, doPlaySound)
        if pageType == nil or pageType == "" then return end
        oldPage = oldPage or 0
        doPlaySound = doPlaySound or false

        if pageType == "recipients" then
            if MailBuddy.settingsVars.settings.curRecipientPage ~= oldPage then
                --Pages for the recipients
                if (MailBuddy.settingsVars.settings.curRecipientPage == "1") then
                    MailBuddy_RecipientsPage1:SetHidden(false)
                    MailBuddy_RecipientsPage2:SetHidden(true)
                    MailBuddy_RecipientsPage3:SetHidden(true)
                    MailBuddy_MailSendRecipientsBoxButtonGlow1:SetHidden(false)
                    MailBuddy_MailSendRecipientsBoxButtonGlow2:SetHidden(true)
                    MailBuddy_MailSendRecipientsBoxButtonGlow3:SetHidden(true)
                    if doPlaySound then
                        MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                    end
                    elseif (MailBuddy.settingsVars.settings.curRecipientPage == "2") then
                    MailBuddy_RecipientsPage2:SetHidden(false)
                    MailBuddy_RecipientsPage1:SetHidden(true)
                    MailBuddy_RecipientsPage3:SetHidden(true)
                    MailBuddy_MailSendRecipientsBoxButtonGlow2:SetHidden(false)
                    MailBuddy_MailSendRecipientsBoxButtonGlow1:SetHidden(true)
                    MailBuddy_MailSendRecipientsBoxButtonGlow3:SetHidden(true)
                    if doPlaySound then
                        MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                    end
                elseif (MailBuddy.settingsVars.settings.curRecipientPage == "3") then
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
            if MailBuddy.settingsVars.settings.curSubjectPage ~= oldPage then
                --Pages for the subjects
                if (MailBuddy.settingsVars.settings.curSubjectPage == "1") then
                    MailBuddy_SubjectsPage1:SetHidden(false)
                    MailBuddy_SubjectsPage2:SetHidden(true)
                    MailBuddy_SubjectsPage3:SetHidden(true)
                    MailBuddy_MailSendSubjectsBoxButtonGlow1:SetHidden(false)
                    MailBuddy_MailSendSubjectsBoxButtonGlow2:SetHidden(true)
                    MailBuddy_MailSendSubjectsBoxButtonGlow3:SetHidden(true)
                    if doPlaySound then
                        MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                    end
                elseif (MailBuddy.settingsVars.settings.curSubjectPage == "2") then
                    MailBuddy_SubjectsPage2:SetHidden(false)
                    MailBuddy_SubjectsPage1:SetHidden(true)
                    MailBuddy_SubjectsPage3:SetHidden(true)
                    MailBuddy_MailSendSubjectsBoxButtonGlow2:SetHidden(false)
                    MailBuddy_MailSendSubjectsBoxButtonGlow1:SetHidden(true)
                    MailBuddy_MailSendSubjectsBoxButtonGlow3:SetHidden(true)
                    if doPlaySound then
                        MailBuddy.PlaySoundNow(SOUNDS["BOOK_PAGE_TURN"])
                    end
                elseif (MailBuddy.settingsVars.settings.curSubjectPage == "3") then
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

	function MailBuddy.mapPageAndEntry(p_pageIndex, p_Type)
		if p_pageIndex == nil or p_Type == nil then return end
		local pageEntry
		if p_pageIndex ~= 0 then
			--Get the recipient page and entry
		    if p_Type == "recipient" then
	            for pageNr, maxEntries in pairs (MailBuddy.recipientPages.maxEntriesUntilHere) do
		        	if p_pageIndex <= maxEntries then
	                    if pageNr > 1 then
		                    pageEntry = p_pageIndex - ((pageNr-1) * MailBuddy.recipientPages.entriesPerPage)
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
		                    pageEntry = p_pageIndex - ((pageNr-1) * MailBuddy.subjectPages.entriesPerPage)
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
        if  not MailBuddy.settingsVars.settings.automatism.focus["To"]
            and not MailBuddy.settingsVars.settings.automatism.focus["Subject"]
            and not MailBuddy.settingsVars.settings.automatism.focus["Body"] then return end
        if MailBuddy.settingsVars.settings.automatism.focus["Body"] and ZO_MailSendToField:GetText() ~= "" and ZO_MailSendSubjectField:GetText() ~= "" then
            SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
            ZO_MailSendBodyField:TakeFocus()
            SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
        elseif MailBuddy.settingsVars.settings.automatism.focus["To"] and ZO_MailSendToField:GetText() == "" and ZO_MailSendSubjectField:GetText() ~= "" then
            SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
            ZO_MailSendToField:TakeFocus()
            SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
            if MailBuddy.settingsVars.settings.automatism.focusOpen["To"] then
        		MailBuddy.ShowBox("recipients", false, false, true, true)
            end
        elseif MailBuddy.settingsVars.settings.automatism.focus["Subject"] and ZO_MailSendToField:GetText() ~= "" and ZO_MailSendSubjectField:GetText() == "" then
            SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
            ZO_MailSendSubjectField:TakeFocus()
            SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
            if MailBuddy.settingsVars.settings.automatism.focusOpen["Subject"] then
		        MailBuddy.ShowBox("subjects", false, false, true, true)
            end
        end
    end

    --Close the recipients/subjects lists automatically
    function MailBuddy.AutoCloseBox(boxType, doOverride)
        if boxType == nil or boxType == "" then return end
        doOverride = doOverride or false
        local isGuildRoster = false
        local isFriendsList = false

        if ZO_KeyboardFriendsList ~= nil and not ZO_KeyboardFriendsList:IsHidden() then isFriendsList = true
        elseif ZO_GuildRoster ~= nil and not ZO_GuildRoster:IsHidden() then isGuildRoster = true end

        if    (boxType == "subjects" and (doOverride or MailBuddy.settingsVars.settings.automatism.close["SubjectsBox"]))
           or (boxType == "recipients" and (doOverride or MailBuddy.settingsVars.settings.automatism.close["RecipientsBox"])) then
            MailBuddy.ShowBox(boxType, false, true, false, false)
        end
    end

	function MailBuddy.UpdateNumTotalMails()
        --Show the current total count of mails?
		if MailBuddy.settingsVars.settings.showTotalMailCountInInbox then
			zo_callLater(function()
				if ZO_MailInboxUnreadLabel ~= nil then
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

    function MailBuddy.RememberMailData()
        --Remember the last used recipient and subject text
        MailBuddy.settingsVars.settings.remember.recipient["text"] = MailBuddy.GetZOMailRecipient(true)
        MailBuddy.settingsVars.settings.remember.subject["text"]   = MailBuddy.GetZOMailSubject(true)
        MailBuddy.settingsVars.settings.remember.body["text"]      = MailBuddy.GetZOMailBody()
    end

    function MailBuddy.SetRememberedMailData()
        SetStandardRecipientAndSubject()
        SetRememberedRecipientSubjectAndBody()
    end

    --Initialization of this addon
	local function Initialize(eventCode, addOnName)
	        if (addOnName ~= MailBuddy.addonVars.name) then
	            return
	        end

            --Unregister the addon loaded event again so it won't be called twice!
	        EVENT_MANAGER:UnregisterForEvent(MailBuddy.addonVars.name, eventCode)

            --Load the saved variables etc.
            MailBuddy.LoadUserSettings()

            --Load localization file
            MailBuddy.preventerVars.KeyBindingTexts = false
            MailBuddy.Localization()

	        --Build the settings panel
	        MailBuddy.CreateLAMPanel()

            --Create the text for the keybinding
	        ZO_CreateStringId("SI_BINDING_NAME_MAILBUDDY_COPY", MailBuddy.GetLocText("SI_BINDING_NAME_MAILBUDDY_COPY", true))

            --Select the current page at recipients and subjects (from the saved variables)
	        MailBuddy.GetPage("recipients", 0, false)
            MailBuddy.GetPage("subjects", 0, false)

		--New after patch 1.6
			--======== FRIENDS LIST ================================================================
			--Register a callback function for the friends list scene
			FRIENDS_LIST_SCENE:RegisterCallback("StateChange", function(oldState, newState)
		        if 	   newState == SCENE_SHOWN then
                    AddButtonToFriendsList()

		        elseif newState == SCENE_HIDING then
                    MailBuddy.settingsVars.settings.lastShown.recipients["FriendsList"] = not MailBuddy.recipientsBox:IsHidden()
                end
			end)
            --PreHook the MouseEnter and Exit functions for the friends list rows + names in the rows
			ZO_PreHook("ZO_FriendsListRowDisplayName_OnMouseEnter", function(control)
            	--d("Mouse enter friend name: " .. control:GetName())
               GetMouseOverFriends(control)
            end)
			ZO_PreHook("ZO_FriendsListRowDisplayName_OnMouseExit", function(control)
            	--d("Mouse exit friend name: " .. control:GetName())
   				KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyFriend)
            end)
			ZO_PreHook("ZO_FriendsListRow_OnMouseExit", function(control)
            	--d("Mouse exit friends row: " .. control:GetName())
   				KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyFriend)
            end)

			--======== GUILD ROSTER ================================================================
			--Register a callback function for the guild roster scene
			GUILD_ROSTER_SCENE:RegisterCallback("StateChange", function(oldState, newState)
		        if 	   newState == SCENE_SHOWN then
                    AddButtonToGuildRoster()

                elseif newState == SCENE_HIDING then
                    MailBuddy.settingsVars.settings.lastShown.recipients["GuildRoster"] = not MailBuddy.recipientsBox:IsHidden()
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
   				KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyGuildMember)
            end)
			ZO_PreHook("ZO_KeyboardGuildRosterRow_OnMouseExit", function(control)
            	--d("Mouse exit guild roster row: " .. control:GetName())
   				KEYBIND_STRIP:RemoveKeybindButtonGroup(keystripDefCopyGuildMember)
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
                    if MailBuddy.settingsVars.settings.automatism.hide["RecipientsBox"] then
                        MailBuddy.ShowBox("recipients", false, true, false, false)
                    else
                        local doClose = false
                        local doOpen = MailBuddy.settingsVars.settings.lastShown.recipients["MailSend"]
                        if doOpen == false then doClose = true end
                        MailBuddy.ShowBox("recipients", false, doClose, doOpen, false)
                    end
                    if MailBuddy.settingsVars.settings.automatism.hide["SubjectsBox"] then
                        MailBuddy.ShowBox("subjects", false, true, false, false)
                    else
                        local doClose = false
                        local doOpen = MailBuddy.settingsVars.settings.lastShown.subjects["MailSend"]
                        if doOpen == false then doClose = true end
                        MailBuddy.ShowBox("subjects", false, doClose, doOpen, false)
                    end

                    --Add the "from" label above the "to" label and show the current account name if activated in the settings
                    if MailBuddy.settingsVars.settings.showAccountName or MailBuddy.settingsVars.settings.showCharacterName then
                       	if MailBuddy.mailSendFromLabel == nil then
                           	MailBuddy.mailSendFromLabel = WINDOW_MANAGER:CreateControl("MailBuddy_MailSendFromLabel", ZO_MailSend, CT_LABEL)
						end
                        if MailBuddy.mailSendFromLabel ~= nil then
							--Set the name to display at the label
                            local nameToShow = ""
                            if MailBuddy.settingsVars.settings.showAccountName then
                            	nameToShow = GetDisplayName()
                            elseif MailBuddy.settingsVars.settings.showCharacterName then
	                            local playerName = GetUnitName("player")
                                nameToShow = playerName
                            end
                        	--Change the label values
							MailBuddy.mailSendFromLabel:SetFont("ZoFontWinH3")
							MailBuddy.mailSendFromLabel:SetColor(ZO_NORMAL_TEXT:UnpackRGBA())
							MailBuddy.mailSendFromLabel:SetScale(1)
							MailBuddy.mailSendFromLabel:SetDrawLayer(DT_HIGH)
							MailBuddy.mailSendFromLabel:SetDrawTier(DT_HIGH)
							MailBuddy.mailSendFromLabel:SetAnchor(TOPLEFT, ZO_MailSendToLabel, TOPLEFT, 0, -30)
							MailBuddy.mailSendFromLabel:SetDimensions(326, 23)
				        	MailBuddy.mailSendFromLabel:SetHidden(false)
							MailBuddy.mailSendFromLabel:SetText(MailBuddy.localizationVars.mb_loc["options_mail_from"] .. "   " .. nameToShow)
						end
                   	elseif not MailBuddy.settingsVars.settings.showAccountName and not MailBuddy.settingsVars.settings.showCharacterName then
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
                    MailBuddy.settingsVars.settings.lastShown.recipients["MailSend"] = not MailBuddy.recipientsBox:IsHidden()
                    MailBuddy.settingsVars.settings.lastShown.subjects["MailSend"] = not MailBuddy.subjectsBox:IsHidden()
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
                if MailBuddy.settingsVars.settings.useAlternativeLayout then
                    if button == 2 then
                        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
                    end
                end
            end)
            --PreHook the OnMouseUp Handler at the ZOs mail to edit field
            ZO_PreHookHandler(ZO_MailSendToField, "OnMouseUp", function(control, button, upInside)
                if MailBuddy.settingsVars.settings.useAlternativeLayout then
                    ZO_Tooltips_HideTextTooltip()
                    if upInside and button == 2 then
                        MailBuddy.ShowBox("recipients", true, false, false, true)
                        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
                    end
                end
            end)
            --PreHook the OnMouseEnter Handler at the ZOs mail to edit field
            ZO_PreHookHandler(ZO_MailSendToField, "OnMouseEnter", function(control)
                if MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip and MailBuddy.settingsVars.settings.useAlternativeLayout then
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
                if MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip and MailBuddy.settingsVars.settings.useAlternativeLayout then
                    ZO_Tooltips_HideTextTooltip()
                end
            end)
            --PreHook the OnMouseDown Handler at the ZOs mail subject edit field
            ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseDown", function(control, button)
                if MailBuddy.settingsVars.settings.useAlternativeLayout then
                    ZO_Tooltips_HideTextTooltip()
                    if button == 2 then
                        SOUNDS["EDIT_CLICK"] = SOUNDS["NONE"]
                    end
                end
            end)
            --PreHook the OnMouseUp Handler at the ZOs mail subject edit field
            ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseUp", function(control, button, upInside)
                if MailBuddy.settingsVars.settings.useAlternativeLayout then
                    if upInside and button == 2 then
                        MailBuddy.ShowBox("subjects", true, false, false, true)
                        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
                    end
                end
            end)
            --PreHook the OnMouseEnter Handler at the ZOs mail subject edit field
            ZO_PreHookHandler(ZO_MailSendSubjectField, "OnMouseEnter", function(control)
                if MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip and MailBuddy.settingsVars.settings.useAlternativeLayout then
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
                if MailBuddy.settingsVars.settings.showAlternativeLayoutTooltip and MailBuddy.settingsVars.settings.useAlternativeLayout then
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
            MailBuddy_MailSendRecipientLabelActiveText:SetText(string.format(MailBuddy.settingsVars.settings.curRecipientAbbreviated))
            MailBuddy.UpdateEditFieldToolTip(MailBuddy_MailSendRecipientLabelActiveText, MailBuddy.settingsVars.settings.curRecipient, MailBuddy.settingsVars.settings.curRecipientAbbreviated)
	        MailBuddy_MailSendSubjectLabelActiveText:SetText(string.format(MailBuddy.settingsVars.settings.curSubjectAbbreviated))
            MailBuddy.UpdateEditFieldToolTip(MailBuddy_MailSendSubjectLabelActiveText, MailBuddy.settingsVars.settings.curSubject, MailBuddy.settingsVars.settings.curSubjectAbbreviated)

			--Preset the standard mail recipient and subject from the settings after mail was send/not sent (error)
	        EVENT_MANAGER:RegisterForEvent(MailBuddy.addonVars.name, EVENT_MAIL_SEND_SUCCESS, function()
            	zo_callLater(function()
                    MailBuddy.SetRememberedMailData()
                end, 150)
            end)
	        EVENT_MANAGER:RegisterForEvent(MailBuddy.addonVars.name, EVENT_MAIL_SEND_FAILED, function()
            	zo_callLater(function()
                    MailBuddy.SetRememberedMailData()
                end, 150)
            end)

	   	-- Registers addon to loadedAddon library
		LIBLA:RegisterAddon(MailBuddy.addonVars.name, MailBuddy.addonVars.addonVersionOptionsNumber)

	end

    --Event Registry--
	EVENT_MANAGER:RegisterForEvent(MailBuddy.addonVars.name, EVENT_PLAYER_ACTIVATED, PlayerActivatedCallback)
	EVENT_MANAGER:RegisterForEvent(MailBuddy.addonVars.name, EVENT_ADD_ON_LOADED, Initialize)

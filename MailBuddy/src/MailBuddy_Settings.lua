--The addon table/array
local MB = MailBuddy
local addonVars = MB.addonVars
local addonName = addonVars.name
local settingsVars = MB.settingsVars

local worldName = GetWorldName()
local displayName = GetDisplayName()

local CM = CALLBACK_MANAGER
local WM = WINDOW_MANAGER

local svName = addonVars.savedVariablesName
local svNameOld = addonVars.savedVariablesName_OLD
local svVersionOld = addonVars.savedVariablesVersion_OLD
local svVersion = settingsVars.settingsVersion
local svSubtable = settingsVars.settingsSubtable
local svSubtableForAll = settingsVars.settingsForAllSubtable

--Clear player/account name from the recipients list, as you are not allowed to send mails to yourself
local function RemoveOwnCharactersFromSavedRecipients(index, recipientName)
    if index == nil or recipientName == nil then return false end
    if recipientName == MB.playerName or recipientName == MB.accountName then
        --One of your characters or your account name was added to teh recipients list
        --> It will be removed now and clearedfrom the SavedVariables at the next reloadui/zone change/logout
        MB.settingsVars.settings.SetRecipient[index] = ""
        MB.settingsVars.settings.SetRecipientAbbreviated[index] = ""
        return true
    end
    return false
end

--Any tasks open after a SavedVariables migration was done?
local function checkSavedVariablesMigrationTasks()
    local migrationInfoOutput = MB.migrationInfoOutput
    --Were SavedVariables migrated from non-server dependent ones?
    --And do we need a reloadui here?
--d("[checkSavedVariablesMigrationTasks]migrationReloadUI: " ..tostring(MB.migrationReloadUI))
    if MB.migrationReloadUI ~= nil then
        if MB.migrationReloadUI == 1 then
            MB.migrationReloadUI = nil
            MB.settingsVars.settings.migrationJustFinished = nil
--d(">Reloading the UI - 11111")
            ReloadUI()

        elseif MB.migrationReloadUI == 2 then
            MB.migrationReloadUI = nil
            MB.settingsVars.settings.migrationJustFinished = nil
            -->Just go on and use the default values as SavedVars
--d(">No UI reload needed - 22222")
            ReloadUI()

        elseif MB.migrationReloadUI == 3 then
            MB.migrationReloadUI = nil
            MB.settingsVars.settings.migrationJustFinished = true
--d(">Reloading the UI - 33333")
            ReloadUI()
        end
    else
        if MB.settingsVars.settings.migratedSVToServer == true and MB.settingsVars.settings.migrationJustFinished == true then
            MB.settingsVars.settings.migrationJustFinished = nil

            --Migration finished - Output info
            migrationInfoOutput("Successfully migrated the SavedVariables to the server \'" ..tostring(worldName) .. "\'", true, true)
            migrationInfoOutput(">Non-server dependent SavedVariables for your account \'"..GetDisplayName().."\' can be deleted via the slash command \'/mailbuddydeleteoldsv\'!", true, false)
            migrationInfoOutput(">Attention: If you want to copy the SVs to another server login to that other server first BEFORE deleting the non-server dependent SavedVariables, because they will be taken as the base to copy!", true, false)
        end
    end
end
MB.checkSavedVariablesMigrationTasks = checkSavedVariablesMigrationTasks

local function migrateSavedVarsToServerDependent()
    local migrationInfoOutput = MB.migrationInfoOutput
    local function abortMigrationAndReloadUI(settingsVariable)
        settingsVariable.migratedSVToServer = true
        MB.migrationReloadUI    = 2
        return
    end

    --Variable for EVENT_PLAYER_ACTIVATED
    MB.migrationReloadUI = nil

    --Create new account wide settings ForAll to store the migration flag
    MB.settingsVars.defaultSettings = ZO_SavedVars:NewAccountWide(svName, 999, svSubtableForAll, MB.settingsVars.firstRunSettings, worldName, nil)

    --Migrate the SV from non-server to server SV
--d("[MailBuddy]migratedSVToServer: " ..tostring(MB.settingsVars.defaultSettings.migratedSVToServer))
    if MB.settingsVars.defaultSettings.migratedSVToServer == nil then
        migrationInfoOutput("Migrating the SavedVariables to the server \'" ..tostring(worldName) .. "\' now...", true, false)
        if not _G[svNameOld] or not _G[svNameOld]["Default"] or not _G[svNameOld]["Default"][displayName] then
--d(">no old sv found -> go on with migrationReloadUI = 2 -> using default SVs")
            --No settings were saved yet -> New user. No migration needed!
            return abortMigrationAndReloadUI(MB.settingsVars.defaultSettings)
        end

        --Do the old non-server dependent settings SV exist
        local svOld = _G[svNameOld]["Default"][displayName] --including account wide AND character name data!
        if svOld ~= nil and svOld["$AccountWide"] ~= nil then
--d(">old sv found -> go on with copy of old SVs")
            local svOldCopy = ZO_ShallowTableCopy(svOld)
            local svOldCopyAccountWide = svOldCopy["$AccountWide"]
            local svOldCopyDefaultFirstRun = svOldCopyAccountWide[svSubtableForAll]
            --Migrate the default ForAll settings
            svOldCopyDefaultFirstRun.migratedSVToServer = false
            MB.settingsVars.defaultSettings = ZO_SavedVars:NewAccountWide(svName, 999, svSubtableForAll, svOldCopyDefaultFirstRun, worldName, nil)
            MB.settingsVars.defaultSettings.migratedSVToServer = false
            --Migrate the character name settings to IDs, if any given
            for charName, _ in pairs(MB.characterNameRaw2Id) do
--d(">>checking charname SV: " ..tostring(charName))
                if svOldCopy[charName] ~= nil then
                    MB.settingsVars.settings = ZO_SavedVars:NewCharacterIdSettings(svName, svVersion, svSubtable, svOldCopy[charName], worldName)
                end
            end
            --Migrate the account wide settings
            local svOldCopySettings = svOldCopyAccountWide[svSubtable]
--d(">>>creating new SVs with servername")
            MB.settingsVars.settings = ZO_SavedVars:NewAccountWide(svName, svVersion, svSubtable, svOldCopySettings, worldName, nil)
            migrationInfoOutput("Migration of the SavedVariables to the server \'" ..tostring(worldName) .. "\' done.\nReloading the UI now to save the data to the disk.", true, true)
            MB.settingsVars.defaultSettings.migratedSVToServer = false
            MB.migrationReloadUI    = 1
--d(">>>migrationReloadUI = 1 - Reloading the UI")
            --Reload the UI in order to save the MB.settingsVars.defaultSettings.migratedSVToServer variables before the next
            --ZO_SavedVars:NewAccountWide will overwrite them!
        else
--d("<settings old not found! Migration not needed. migrationReloadUI = 2")
            --migrationInfoOutput("Migration of the SavedVariables to the server \'" ..tostring(worldName) .. "\' not started as there is no non-server SV data available to migrate!", false, false)
            --migrationInfoOutput(">Using default values for the server dependent SavedVariables.", false, false)
            return abortMigrationAndReloadUI(MB.settingsVars.defaultSettings)
        end
    else
--d("[SavedVariables migration] db.migratedSVToServer: " ..tostring(MB.settingsVars.defaultSettings.migratedSVToServer))

        --SV were migrated already
        if MB.settingsVars.defaultSettings.migratedSVToServer == false then
            migrationInfoOutput("Successfully migrated the SavedVariables to the server \'" ..tostring(worldName) .. "\'", true, true)
            migrationInfoOutput(">Non-server dependent SavedVariables for your account \'"..GetDisplayName().."\' can be deleted via the slash command \'/mailbuddydeleteoldsv\'!", true, false)
            migrationInfoOutput(">Attention: If you want to copy the SVs to another server login to that other server first BEFORE deleting the non-server dependent SavedVariables, because they will be taken as the base to copy!", true, false)
            MB.settingsVars.defaultSettings.migratedSVToServer = true
--d(">>>migrationReloadUI = 3")
            MB.migrationReloadUI    = 3
        end
    end
end

--=============================================================================================================
--	LOAD USER SETTINGS
--=============================================================================================================
--Load the SavedVariables now
function MB.LoadUserSettings()
    if addonVars.gSettingsLoaded then return end

    --Prepare the keybindings in the keybindstrip
    MB.keyStripVars.keystripDefCopyFriend = {
        {
            name = GetString(SI_BINDING_NAME_MAILBUDDY_FRIEND_COPY),
            keybind = "MAILBUDDY_COPY",
            callback = function() MB.CopyNameUnderControl() end,
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
        }
    }
    MB.keyStripVars.keystripDefCopyGuildMember = {
        {
            name = GetString(SI_BINDING_NAME_MAILBUDDY_GUILD_MEMBER_COPY),
            keybind = "MAILBUDDY_COPY",
            callback = function() MB.CopyNameUnderControl() end,
            alignment = KEYBIND_STRIP_ALIGN_CENTER,
        }
    }

    --=========== BEGIN - SAVED VARIABLES ==========================================
    --Migrate the SavedVariables from non-character ID to unique character IDs
    -->Done internally by ZO_SavedVars

    --Migrate old non-server dependent SavedVariables to new server dependent ones
    migrateSavedVarsToServerDependent()

--d("[Loaded SavedVariables from server]")
    --Load the user's MB.settingsVars.settings from SavedVariables file -> Account wide of basic version 999 at first
    MB.settingsVars.defaultSettings = ZO_SavedVars:NewAccountWide(svName, 999, svSubtableForAll, MB.settingsVars.firstRunSettings, worldName, nil)
    --Check, by help of basic version 999 MB.settingsVars.settings, if the settings should be loaded for each character or account wide
    --Use the current addon version to read the MB.settingsVars.settings now
    if (MB.settingsVars.defaultSettings.saveMode == 1) then
        MB.settingsVars.settings = ZO_SavedVars:NewCharacterIdSettings(svName, svVersion, svSubtable, MB.settingsVars.defaults, worldName)
    else
        MB.settingsVars.settings = ZO_SavedVars:NewAccountWide(svName, svVersion, svSubtable, MB.settingsVars.defaults, worldName, nil)
    end
    --=========== END - SAVED VARIABLES ============================================

    --Read the settings and set the mail recipient names
    for idx, recipientName in pairs(MB.settingsVars.settings.SetRecipient) do
        --d("Recipient name: " .. recipientName .. ", index: " .. idx)
        if recipientName ~= "" and not RemoveOwnCharactersFromSavedRecipients(idx, recipientName) then
            local page, pageEntry = MB.mapPageAndEntry(idx, "recipient")
            if page ~= nil and pageEntry ~= nil then
                local editControl = WM:GetControlByName(MB.recipientPages.pages[page][pageEntry], "")
                if editControl ~= nil then
                    local recipientNameAbbreviated = MB.settingsVars.settings.SetRecipientAbbreviated[idx] or recipientName
                    editControl:SetText(string.format(recipientNameAbbreviated))
                    MB.UpdateEditFieldToolTip(editControl, recipientName, recipientNameAbbreviated)
                end
            end
        end
    end

    --Read the settings and set the mail subjects
    for idx, subjectText in pairs(MB.settingsVars.settings.SetSubject) do
        if subjectText ~= "" then
            local page, pageEntry = MB.mapPageAndEntry(idx, "subject")
            if page ~= nil and pageEntry ~= nil then
                local subjectEditControl = WM:GetControlByName(MB.subjectPages.pages[page][pageEntry], "")
                if subjectEditControl ~= nil then
                    local subjectTextAbbreviated = MB.settingsVars.settings.SetSubjectAbbreviated[idx] or subjectText
                    subjectEditControl:SetText(string.format(subjectTextAbbreviated))
                    MB.UpdateEditFieldToolTip(subjectEditControl, subjectText, subjectTextAbbreviated)
                end
            end
        end
    end

    --Set settings = loaded
    addonVars.gSettingsLoaded = true
    --=============================================================================================================
end

--------------------------------------------------------------------------------
--Create the options panel with LAM 2.0
--BuildAddonMenu
function MB.CreateLAMPanel()
    local panelData = {
        type 				= 'panel',
        name 				= addonName,
        displayName 		= addonVars.displayName,
        author 				= addonVars.author,
        version 			= addonVars.version,
        website             = addonVars.website,
        feedback            = addonVars.feedback,
        donation            = addonVars.donation,
        registerForRefresh 	= true,
        registerForDefaults = true,
        slashCommand 		= "/mbs",
    }
    local settings = MB.settingsVars.settings
    local LAM = MB.LAM
    local LMP = MB.LMP
    local mbLocPrefix = MB.LocalizationPrefix

    MB.SettingsPanel = LAM:RegisterAddonPanel(addonName.."panel", panelData)

--[[ Try to add auto complete to LAM 2.o edit box but it doesn't work. Maybe the inherits="ZO_DefaultEditForBackdrop" is relevant?
    local UpdateMailBuddySettingsFields = function(panel)
        if panel == MB.SettingsPanel then
            --Update the standard recipient name edit field with an auto complete feature
            if MailBuddy_StandardRecipientName_SettingsEdit ~= nil then
                local editControlGroup = ZO_EditControlGroup:New()
                MB.autoCompleteRecipientSettings = ZO_AutoComplete:New(MailBuddy_StandardRecipientName_SettingsEdit, { AUTO_COMPLETE_FLAG_ALL }, nil, AUTO_COMPLETION_ONLINE_OR_OFFLINE, MAX_AUTO_COMPLETION_RESULTS)
                editControlGroup:AddEditControl(MailBuddy_StandardRecipientName_SettingsEdit, MB.autoCompleteRecipientSettings)
            end
            CM:UnregisterCallback("LAM-RefreshPanel", UpdateMailBuddySettingsFields)
        end
    end
    CM:RegisterCallback("LAM-PanelControlsCreated", UpdateMailBuddySettingsFields)
]]

    --The preview label for the font's data inside the LAM settings panel for this addon (left to the font dropdown box)
    local previewLabel1
    local previewLabel2
    local previewLabel3
    local previewLabel4
    local fontPreview = function(panel)
        if panel == MB.SettingsPanel then
            previewLabel1 = WM:CreateControl(nil, panel.controlsToRefresh[10], CT_LABEL)
            previewLabel1:SetAnchor(RIGHT, panel.controlsToRefresh[10].dropdown:GetControl(), LEFT, -10, 0)
            previewLabel1:SetText("@Accountname")
            previewLabel1:SetHidden(false)
            MB.UpdateFontAndColor(previewLabel1, "recipients", 1)

            previewLabel2 = WM:CreateControl(nil, panel.controlsToRefresh[14], CT_LABEL)
            previewLabel2:SetAnchor(RIGHT, panel.controlsToRefresh[14].dropdown:GetControl(), LEFT, -10, 0)
            previewLabel2:SetText("Character name")
            previewLabel2:SetHidden(false)
            MB.UpdateFontAndColor(previewLabel2, "recipients", 2)

            previewLabel3 = WM:CreateControl(nil, panel.controlsToRefresh[18], CT_LABEL)
            previewLabel3:SetAnchor(RIGHT, panel.controlsToRefresh[18].dropdown:GetControl(), LEFT, -10, 0)
            previewLabel3:SetText("SUBJECT")
            previewLabel3:SetHidden(false)
            MB.UpdateFontAndColor(previewLabel3, "subjects", 1)

            previewLabel4 = WM:CreateControl(nil, panel.controlsToRefresh[22], CT_LABEL)
            previewLabel4:SetAnchor(RIGHT, panel.controlsToRefresh[22].dropdown:GetControl(), LEFT, -10, 0)
            previewLabel4:SetText("Subject")
            previewLabel4:SetHidden(false)
            MB.UpdateFontAndColor(previewLabel4, "subjects", 2)
            CM:UnregisterCallback("LAM-RefreshPanel", fontPreview)
        end
    end
    CM:RegisterCallback("LAM-PanelControlsCreated", fontPreview)

    local languageOptions = {
        [1] = GetString(mbLocPrefix .. "options_language_dropdown_selection1"),
        [2] = GetString(mbLocPrefix .. "options_language_dropdown_selection2"),
        [3] = GetString(mbLocPrefix .. "options_language_dropdown_selection3"),
    }
    local languageOptionsValues = {}
    for langId, _ in ipairs(languageOptions) do
        languageOptionsValues[langId] = langId
    end

    local savedVariablesOptions = {
        [1] = GetString(mbLocPrefix .. "options_savedVariables_dropdown_selection1"),
        [2] = GetString(mbLocPrefix .. "options_savedVariables_dropdown_selection2"),
    }
    local savedVariablesOptionsValues = {}
    for svSaveId, _ in ipairs(languageOptions) do
        savedVariablesOptionsValues[svSaveId] = svSaveId
    end

    local optionsTable =
    {	-- BEGIN OF OPTIONS TABLE
        {
            type = 'description',
            text = GetString(mbLocPrefix .. "options_description"),
        },
--==============================================================================
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_header1"),
        },
        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_language"),
            tooltip = GetString(mbLocPrefix .. "options_language_tooltip"),
            choices = languageOptions,
            choicesValues = languageOptionsValues,
            getFunc = function() return MB.settingsVars.defaultSettings.language end,
            setFunc = function(value)
                MB.settingsVars.defaultSettings.language = value
                --ReloadUI()
            end,
            requiresReload = true,
            warning = GetString(mbLocPrefix .. "options_language_description1"),
        },
        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_savedvariables"),
            tooltip = GetString(mbLocPrefix .. "options_savedvariables_tooltip"),
            choices = savedVariablesOptions,
            choicesValues = savedVariablesOptionsValues,
            getFunc = function() return MB.settingsVars.defaultSettings.saveMode end,
            setFunc = function(value)
                MB.settingsVars.defaultSettings.saveMode = value
                --ReloadUI()
            end,
            requiresReload = true,
            warning = GetString(mbLocPrefix .. "options_language_description1"),
        },
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_appearance"),
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_alternative_layout"),
            tooltip = GetString(mbLocPrefix .. "options_alternative_layout_tooltip"),
            getFunc = function() return settings.useAlternativeLayout end,
            setFunc = function(value)
                settings.useAlternativeLayout = not settings.useAlternativeLayout
                MB.ShowBox("recipients", false, false, false, false)
                MB.ShowBox("subjects", false, false, false, false)
                settings.showAlternativeLayoutTooltip = settings.useAlternativeLayout
            end,
            default = settings.useAlternativeLayout,
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_show_alternative_layout_tooltip"),
            tooltip = GetString(mbLocPrefix .. "options_show_alternative_layout_tooltip_tooltip"),
            getFunc = function() return settings.showAlternativeLayoutTooltip end,
            setFunc = function(value)
                settings.showAlternativeLayoutTooltip = not settings.showAlternativeLayoutTooltip
            end,
            default = settings.showAlternativeLayoutTooltip,
            width   = "full",
            disabled = function() return not settings.useAlternativeLayout end
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_play_sounds"),
            tooltip = GetString(mbLocPrefix .. "options_play_sounds_tooltip"),
            getFunc = function() return settings.playSounds end,
            setFunc = function(value)
                settings.playSounds = not settings.playSounds
            end,
            default = settings.playSounds,
            width   = "full",
        },

        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_fonts"),
        },
        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_recipient_label"),
            choices = LMP:List('font'),
            getFunc = function() return settings.font["recipients"][1].family end,
            setFunc = function(value) settings.font["recipients"][1].family = value
                MB.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MB.UpdateFontAndColor(MB.recipientPages.selectedLabel, "recipients", 1)
            end,
            default = settings.font["recipients"][1].family,
        },
        {
            type = "slider",
            name = GetString(mbLocPrefix .. "options_font_recipient_label_size"),
            min = 8,
            max = 32,
            getFunc = function() return settings.font["recipients"][1].size end,
            setFunc = function(size) settings.font["recipients"][1].size = size
                MB.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MB.UpdateFontAndColor(MB.recipientPages.selectedLabel, "recipients", 1)
            end,
            default = settings.font["recipients"][1].size,
        },
        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_recipient_label_style"),
            choices = MB.settingsVars.fontStyles,
            getFunc = function() return settings.font["recipients"][1].style end,
            setFunc = function(value) settings.font["recipients"][1].style = value
                MB.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MB.UpdateFontAndColor(MB.recipientPages.selectedLabel, "recipients", 1)
            end,
            width = "half",
            default = settings.font["recipients"][1].style,
        },
        {
            type = "colorpicker",
            name = GetString(mbLocPrefix .. "options_font_recipient_label_color"),
            getFunc = function() return settings.font["recipients"][1].color.r, settings.font["recipients"][1].color.g, settings.font["recipients"][1].color.b, settings.font["recipients"][1].color.a end,
            setFunc = function(r,g,b,a) settings.font["recipients"][1].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MB.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MB.UpdateFontAndColor(MB.recipientPages.selectedLabel, "recipients", 1)
            end,
            width = "half",
            default = settings.font["recipients"][1].color,
        },

        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_recipients_box"),
            choices = LMP:List('font'),
            getFunc = function() return settings.font["recipients"][2].family end,
            setFunc = function(value) settings.font["recipients"][2].family = value
                MB.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MB.UpdateAllLabels("recipients", -1, -1)
            end,
            default = settings.font["recipients"][2].family,
        },
        {
            type = "slider",
            name = GetString(mbLocPrefix .. "options_font_recipients_box_size"),
            min = 8,
            max = 32,
            getFunc = function() return settings.font["recipients"][2].size end,
            setFunc = function(size) settings.font["recipients"][2].size = size
                MB.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MB.UpdateAllLabels("recipients", -1, -1)
            end,
            default = settings.font["recipients"][2].size,
        },
        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_recipients_box_style"),
            choices = MB.settingsVars.fontStyles,
            getFunc = function() return settings.font["recipients"][2].style end,
            setFunc = function(value) settings.font["recipients"][2].style = value
                MB.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MB.UpdateAllLabels("recipients", -1, -1)
            end,
            width = "half",
            default = settings.font["recipients"][2].style,
        },
        {
            type = "colorpicker",
            name = GetString(mbLocPrefix .. "options_font_recipients_box_color"),
            getFunc = function() return settings.font["recipients"][2].color.r, settings.font["recipients"][2].color.g, settings.font["recipients"][2].color.b, settings.font["recipients"][2].color.a end,
            setFunc = function(r,g,b,a) settings.font["recipients"][2].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MB.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MB.UpdateAllLabels("recipients", -1, -1)
            end,
            width = "half",
            default = settings.font["recipients"][2].color,
        },

        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_subject_label"),
            choices = LMP:List('font'),
            getFunc = function() return settings.font["subjects"][1].family end,
            setFunc = function(value) settings.font["subjects"][1].family = value
                MB.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MB.UpdateFontAndColor(MB.subjectPages.selectedLabel, "subjects", 1)
            end,
            default = settings.font["subjects"][1].family,
        },
        {
            type = "slider",
            name = GetString(mbLocPrefix .. "options_font_subject_label_size"),
            min = 8,
            max = 32,
            getFunc = function() return settings.font["subjects"][1].size end,
            setFunc = function(size) settings.font["subjects"][1].size = size
                MB.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MB.UpdateFontAndColor(MB.subjectPages.selectedLabel, "subjects", 1)
            end,
            default = settings.font["subjects"][1].size,
        },
        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_subject_label_style"),
            choices = MB.settingsVars.fontStyles,
            getFunc = function() return settings.font["subjects"][1].style end,
            setFunc = function(value) settings.font["subjects"][1].style = value
                MB.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MB.UpdateFontAndColor(MB.subjectPages.selectedLabel, "subjects", 1)
            end,
            width = "half",
            default = settings.font["subjects"][1].style,
        },
        {
            type = "colorpicker",
            name = GetString(mbLocPrefix .. "options_font_subject_label_color"),
            getFunc = function() return settings.font["subjects"][1].color.r, settings.font["subjects"][1].color.g, settings.font["subjects"][1].color.b, settings.font["subjects"][1].color.a end,
            setFunc = function(r,g,b,a) settings.font["subjects"][1].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MB.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MB.UpdateFontAndColor(MB.subjectPages.selectedLabel, "subjects", 1)
            end,
            width = "half",
            default = settings.font["subjects"][1].color,
        },

        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_subjects_box"),
            choices = LMP:List('font'),
            getFunc = function() return settings.font["subjects"][2].family end,
            setFunc = function(value) settings.font["subjects"][2].family = value
                MB.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MB.UpdateAllLabels("subjects", -1, -1)
            end,
            default = settings.font["subjects"][2].family,
        },
        {
            type = "slider",
            name = GetString(mbLocPrefix .. "options_font_subjects_box_size"),
            min = 8,
            max = 32,
            getFunc = function() return settings.font["subjects"][2].size end,
            setFunc = function(size) settings.font["subjects"][2].size = size
                MB.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MB.UpdateAllLabels("subjects", -1, -1)
            end,
            default = settings.font["subjects"][2].size,
        },
        {
            type = 'dropdown',
            name = GetString(mbLocPrefix .. "options_font_subjects_box_style"),
            choices = MB.settingsVars.fontStyles,
            getFunc = function() return settings.font["subjects"][2].style end,
            setFunc = function(value) settings.font["subjects"][2].style = value
                MB.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MB.UpdateAllLabels("subjects", -1, -1)
            end,
            width = "half",
            default = settings.font["subjects"][2].style,
        },
        {
            type = "colorpicker",
            name = GetString(mbLocPrefix .. "options_font_subjects_box_color"),
            getFunc = function() return settings.font["subjects"][2].color.r, settings.font["subjects"][2].color.g, settings.font["subjects"][2].color.b, settings.font["subjects"][2].color.a end,
            setFunc = function(r,g,b,a) settings.font["subjects"][2].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MB.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MB.UpdateAllLabels("subjects", -1, -1)
            end,
            width = "half",
            default = settings.font["subjects"][2].color,
        },

        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_additional"),
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_toggle_recipients_box_click"),
            tooltip = GetString(mbLocPrefix .. "options_toggle_recipients_box_click_tooltip"),
            getFunc = function() return settings.additional["RecipientsBoxVisibility"] end,
            setFunc = function(value) settings.additional["RecipientsBoxVisibility"] = not settings.additional["RecipientsBoxVisibility"] end,
            default = settings.additional["RecipientsBoxVisibility"],
            disabled = function() return settings.useAlternativeLayout end,
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_toggle_subjects_box_click"),
            tooltip = GetString(mbLocPrefix .. "options_toggle_subjects_box_click_tooltip"),
            getFunc = function() return settings.additional["SubjectsBoxVisibility"] end,
            setFunc = function(value) settings.additional["SubjectsBoxVisibility"] = not settings.additional["SubjectsBoxVisibility"] end,
            default = settings.additional["SubjectsBoxVisibility"],
            disabled = function() return settings.useAlternativeLayout end,
            width   = "full",
        },
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_standard_mail"),
        },
        {
            type = "editbox",
            name = GetString(mbLocPrefix .. "options_standard_recipient"),
            tooltip = GetString(mbLocPrefix .. "options_standard_recipient_tooltip"),
            getFunc = function() return settings.standard["To"] end,
            setFunc = function(newValue)
                settings.standard["To"] = newValue
            end,
            width = "full",
            default = settings.standard["To"],
            reference = "MailBuddy_StandardRecipientName_SettingsEdit",
            disabled = function() return settings.remember.recipient["last"] end,
        },
        {
            type = "editbox",
            name = GetString(mbLocPrefix .. "options_standard_subject"),
            tooltip = GetString(mbLocPrefix .. "options_standard_subject_tooltip"),
            getFunc = function() return settings.standard["Subject"] end,
            setFunc = function(newValue)
                settings.standard["Subject"] = newValue
            end,
            width = "full",
            default = settings.standard["Subject"],
            disabled = function() return settings.remember.subject["last"] end,
        },
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_mail_brain"),
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_reuse_recipient"),
            tooltip = GetString(mbLocPrefix .. "options_reuse_recipient_tooltip"),
            getFunc = function() return settings.remember.recipient["last"] end,
            setFunc = function(value) settings.remember.recipient["last"] = not settings.remember.recipient["last"] end,
            default = settings.remember.recipient["last"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_reuse_subject"),
            tooltip = GetString(mbLocPrefix .. "options_reuse_subject_tooltip"),
            getFunc = function() return settings.remember.subject["last"] end,
            setFunc = function(value) settings.remember.subject["last"] = not settings.remember.subject["last"] end,
            default = settings.remember.subject["last"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_reuse_body"),
            tooltip = GetString(mbLocPrefix .. "options_reuse_body_tooltip"),
            getFunc = function() return settings.remember.body["last"] end,
            setFunc = function(value) settings.remember.body["last"] = not settings.remember.body["last"] end,
            default = settings.remember.body["last"],
            width   = "full",
        },
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_automatism"),
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_hide_recipients_box"),
            tooltip = GetString(mbLocPrefix .. "options_auto_hide_recipients_box_tooltip"),
            getFunc = function() return settings.automatism.hide["RecipientsBox"] end,
            setFunc = function(value) settings.automatism.hide["RecipientsBox"] = not settings.automatism.hide["RecipientsBox"] end,
            default = settings.automatism.hide["RecipientsBox"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_hide_subjects_box"),
            tooltip = GetString(mbLocPrefix .. "options_auto_hide_subjects_box_tooltip"),
            getFunc = function() return settings.automatism.hide["SubjectsBox"] end,
            setFunc = function(value) settings.automatism.hide["SubjectsBox"] = not settings.automatism.hide["SubjectsBox"] end,
            default = settings.automatism.hide["SubjectsBox"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_close_recipients_box"),
            tooltip = GetString(mbLocPrefix .. "options_auto_close_recipients_box_tooltip"),
            getFunc = function() return settings.automatism.close["RecipientsBox"] end,
            setFunc = function(value) settings.automatism.close["RecipientsBox"] = not settings.automatism.close["RecipientsBox"] end,
            default = settings.automatism.close["RecipientsBox"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_close_subjects_box"),
            tooltip = GetString(mbLocPrefix .. "options_auto_close_subjects_box_tooltip"),
            getFunc = function() return settings.automatism.close["SubjectsBox"] end,
            setFunc = function(value) settings.automatism.close["SubjectsBox"] = not settings.automatism.close["SubjectsBox"] end,
            default = settings.automatism.close["SubjectsBox"],
            width   = "full",
        },
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_autofocus"),
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_focus_recipients_field"),
            tooltip = GetString(mbLocPrefix .. "options_auto_focus_recipients_field_tooltip"),
            getFunc = function() return settings.automatism.focus["To"] end,
            setFunc = function(value) settings.automatism.focus["To"] = not settings.automatism.focus["To"] end,
            default = settings.automatism.focus["To"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_focus_auto_open_recipients_field"),
            tooltip = GetString(mbLocPrefix .. "options_auto_focus_auto_open_recipients_field_tooltip"),
            getFunc = function() return settings.automatism.focusOpen["To"] end,
            setFunc = function(value) settings.automatism.focusOpen["To"] = not settings.automatism.focusOpen["To"] end,
            default = settings.automatism.focusOpen["To"],
            disabled = function() return not settings.automatism.focus["To"] end,
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_focus_subjects_field"),
            tooltip = GetString(mbLocPrefix .. "options_auto_focus_subjects_field_tooltip"),
            getFunc = function() return settings.automatism.focus["Subject"] end,
            setFunc = function(value) settings.automatism.focus["Subject"] = not settings.automatism.focus["Subject"] end,
            default = settings.automatism.focus["Subject"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_focus_auto_open_subjects_field"),
            tooltip = GetString(mbLocPrefix .. "options_auto_focus_auto_open_subjects_field_tooltip"),
            getFunc = function() return settings.automatism.focusOpen["Subject"] end,
            setFunc = function(value) settings.automatism.focusOpen["Subject"] = not settings.automatism.focusOpen["Subject"] end,
            default = settings.automatism.focusOpen["Subject"],
            disabled = function() return not settings.automatism.focus["Subject"] end,
            width   = "full",
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_auto_focus_body_field"),
            tooltip = GetString(mbLocPrefix .. "options_auto_focus_body_field_tooltip"),
            getFunc = function() return settings.automatism.focus["Body"] end,
            setFunc = function(value) settings.automatism.focus["Body"] = not settings.automatism.focus["Body"] end,
            default = settings.automatism.focus["Body"],
            width   = "full",
        },
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_header_sender"),
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_show_account_name"),
            tooltip = GetString(mbLocPrefix .. "options_show_account_name_tooltip"),
            getFunc = function() return settings.showAccountName end,
            setFunc = function(value) settings.showAccountName = not settings.showAccountName end,
            default = settings.showAccountName,
            width   = "full",
            disabled = function() return settings.showCharacterName end,
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_show_character_name"),
            tooltip = GetString(mbLocPrefix .. "options_show_character_name_tooltip"),
            getFunc = function() return settings.showCharacterName end,
            setFunc = function(value) settings.showCharacterName = not settings.showCharacterName end,
            default = settings.showCharacterName,
            width   = "full",
            disabled = function() return settings.showAccountName end,
        },
        {
            type = 'header',
            name = GetString(mbLocPrefix .. "options_header_inbox"),
        },
        {
            type = "checkbox",
            name = GetString(mbLocPrefix .. "options_show_mail_count"),
            tooltip = GetString(mbLocPrefix .. "options_show_mail_count_tooltip"),
            getFunc = function() return settings.showTotalMailCountInInbox end,
            setFunc = function(value) settings.showTotalMailCountInInbox = not settings.showTotalMailCountInInbox end,
            default = settings.showTotalMailCountInInbox,
            width   = "full",
        },

    } -- END OF OPTIONS TABLE
    LAM:RegisterOptionControls(addonName.."panel", optionsTable)
end
MailBuddy = MailBuddy or {}

local addonVars = MailBuddy.addonVars


--Create the options panel with LAM 2.0
--BuildAddonMenu
function MailBuddy.CreateLAMPanel()
    local panelData = {
        type 				= 'panel',
        name 				= addonVars.name,
        displayName 		= addonVars.displayName,
        author 				= addonVars.author,
        version 			= addonVars.version,
        registerForRefresh 	= true,
        registerForDefaults = true,
        slashCommand 		= "/mbs",
    }
    local locVars =         MailBuddy.localizationVars.mb_loc
    local defSettings =     MailBuddy.settingsVars.defaultSettings
    local defaultSettings = MailBuddy.settingsVars.defaults
    local settings =        MailBuddy.settingsVars.settings


    MailBuddy.SettingsPanel = MailBuddy.LAM:RegisterAddonPanel(addonVars.name.."panel", panelData)

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
        [1] = locVars["options_language_dropdown_selection1"],
        [2] = locVars["options_language_dropdown_selection2"],
        [3] = locVars["options_language_dropdown_selection3"],
        [4] = locVars["options_language_dropdown_selection4"],
        [5] = locVars["options_language_dropdown_selection5"],
    }
    local languageOptionsValues = {
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 4,
        [5] = 5,
    }

    local savedVariablesOptions = {
        [1] = locVars["options_savedVariables_dropdown_selection1"],
        [2] = locVars["options_savedVariables_dropdown_selection2"],
    }
    local savedVariablesOptionsValues = {
        [1] = 1,
        [2] = 2,
    }

    local optionsTable =
    {	-- BEGIN OF OPTIONS TABLE
        {
            type = 'description',
            text = locVars["options_description"],
        },
--==============================================================================
        {
            type = 'header',
            name = locVars["options_header1"],
        },
        {
            type = 'dropdown',
            name = locVars["options_language"],
            tooltip = locVars["options_language_tooltip"],
            choices =       languageOptions,
            choicesValues = languageOptionsValues,
            getFunc = function() return languageOptionsValues[defSettings.language] end,
            setFunc = function(value)
                defSettings.language = value
                --Tell the settings that you have manually chosen the language and want to keep it
                --Read in function MailBuddy.Localization() after ReloadUI()
                settings.languageChoosen = true
                ReloadUI()
            end,
            warning = locVars["options_language_description1"],
        },
        {
            type = 'dropdown',
            name = locVars["options_savedvariables"],
            tooltip = locVars["options_savedvariables_tooltip"],
            choices = savedVariablesOptions,
            choicesValues = savedVariablesOptionsValues,
            getFunc = function() return savedVariablesOptionsValues[defSettings.saveMode] end,
            setFunc = function(value)
                defSettings.saveMode = value
                ReloadUI()
            end,
            warning = locVars["options_language_description1"],
        },
        {
            type = 'header',
            name = locVars["options_appearance"],
        },
        {
            type = "checkbox",
            name = locVars["options_alternative_layout"],
            tooltip = locVars["options_alternative_layout_tooltip"],
            getFunc = function() return settings.useAlternativeLayout end,
            setFunc = function(value)
                settings.useAlternativeLayout = not settings.useAlternativeLayout
                MailBuddy.ShowBox("recipients", false, false, false, false)
                MailBuddy.ShowBox("subjects", false, false, false, false)
                settings.showAlternativeLayoutTooltip = settings.useAlternativeLayout
            end,
            default = defaultSettings.useAlternativeLayout,
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_show_alternative_layout_tooltip"],
            tooltip = locVars["options_show_alternative_layout_tooltip_tooltip"],
            getFunc = function() return settings.showAlternativeLayoutTooltip end,
            setFunc = function(value)
                settings.showAlternativeLayoutTooltip = not settings.showAlternativeLayoutTooltip
            end,
            default = defaultSettings.showAlternativeLayoutTooltip,
            width   = "full",
            disabled = function() return not settings.useAlternativeLayout end
        },
        {
            type = "checkbox",
            name = locVars["options_play_sounds"],
            tooltip = locVars["options_play_sounds_tooltip"],
            getFunc = function() return settings.playSounds end,
            setFunc = function(value)
                settings.playSounds = not settings.playSounds
            end,
            default = defaultSettings.playSounds,
            width   = "full",
        },

        {
            type = 'header',
            name = locVars["options_fonts"],
        },
        {
            type = 'dropdown',
            name = locVars["options_font_recipient_label"],
            choices = MailBuddy.LMP:List('font'),
            getFunc = function() return settings.font["recipients"][1].family end,
            setFunc = function(value) settings.font["recipients"][1].family = value
                MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
            end,
            default = defaultSettings.font["recipients"][1].family,
        },
        {
            type = "slider",
            name = locVars["options_font_recipient_label_size"],
            min = 8,
            max = 32,
            getFunc = function() return settings.font["recipients"][1].size end,
            setFunc = function(size) settings.font["recipients"][1].size = size
                MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
            end,
            default = defaultSettings.font["recipients"][1].size,
        },
        {
            type = 'dropdown',
            name = locVars["options_font_recipient_label_style"],
            choices = MailBuddy.settingsVars.fontStyles,
            getFunc = function() return settings.font["recipients"][1].style end,
            setFunc = function(value) settings.font["recipients"][1].style = value
                MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
            end,
            width = "half",
            default = defaultSettings.font["recipients"][1].style,
        },
        {
            type = "colorpicker",
            name = locVars["options_font_recipient_label_color"],
            getFunc = function() return settings.font["recipients"][1].color.r, settings.font["recipients"][1].color.g, settings.font["recipients"][1].color.b, settings.font["recipients"][1].color.a end,
            setFunc = function(r,g,b,a) settings.font["recipients"][1].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MailBuddy.UpdateFontAndColor(previewLabel1, "recipients", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.recipientPages.selectedLabel, "recipients", 1)
            end,
            width = "half",
            default = defaultSettings.font["recipients"][1].color,
        },

        {
            type = 'dropdown',
            name = locVars["options_font_recipients_box"],
            choices = MailBuddy.LMP:List('font'),
            getFunc = function() return settings.font["recipients"][2].family end,
            setFunc = function(value) settings.font["recipients"][2].family = value
                MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MailBuddy.UpdateAllLabels("recipients", -1, -1)
            end,
            default = defaultSettings.font["recipients"][2].family,
        },
        {
            type = "slider",
            name = locVars["options_font_recipients_box_size"],
            min = 8,
            max = 32,
            getFunc = function() return settings.font["recipients"][2].size end,
            setFunc = function(size) settings.font["recipients"][2].size = size
                MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MailBuddy.UpdateAllLabels("recipients", -1, -1)
            end,
            default = defaultSettings.font["recipients"][2].size,
        },
        {
            type = 'dropdown',
            name = locVars["options_font_recipients_box_style"],
            choices = MailBuddy.settingsVars.fontStyles,
            getFunc = function() return settings.font["recipients"][2].style end,
            setFunc = function(value) settings.font["recipients"][2].style = value
                MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MailBuddy.UpdateAllLabels("recipients", -1, -1)
            end,
            width = "half",
            default = defaultSettings.font["recipients"][2].style,
        },
        {
            type = "colorpicker",
            name = locVars["options_font_recipients_box_color"],
            getFunc = function() return settings.font["recipients"][2].color.r, settings.font["recipients"][2].color.g, settings.font["recipients"][2].color.b, settings.font["recipients"][2].color.a end,
            setFunc = function(r,g,b,a) settings.font["recipients"][2].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MailBuddy.UpdateFontAndColor(previewLabel2, "recipients", 2)
                MailBuddy.UpdateAllLabels("recipients", -1, -1)
            end,
            width = "half",
            default = defaultSettings.font["recipients"][2].color,
        },

        {
            type = 'dropdown',
            name = locVars["options_font_subject_label"],
            choices = MailBuddy.LMP:List('font'),
            getFunc = function() return settings.font["subjects"][1].family end,
            setFunc = function(value) settings.font["subjects"][1].family = value
                MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
            end,
            default = defaultSettings.font["subjects"][1].family,
        },
        {
            type = "slider",
            name = locVars["options_font_subject_label_size"],
            min = 8,
            max = 32,
            getFunc = function() return settings.font["subjects"][1].size end,
            setFunc = function(size) settings.font["subjects"][1].size = size
                MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
            end,
            default = defaultSettings.font["subjects"][1].size,
        },
        {
            type = 'dropdown',
            name = locVars["options_font_subject_label_style"],
            choices = MailBuddy.settingsVars.fontStyles,
            getFunc = function() return settings.font["subjects"][1].style end,
            setFunc = function(value) settings.font["subjects"][1].style = value
                MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
            end,
            width = "half",
            default = defaultSettings.font["subjects"][1].style,
        },
        {
            type = "colorpicker",
            name = locVars["options_font_subject_label_color"],
            getFunc = function() return settings.font["subjects"][1].color.r, settings.font["subjects"][1].color.g, settings.font["subjects"][1].color.b, settings.font["subjects"][1].color.a end,
            setFunc = function(r,g,b,a) settings.font["subjects"][1].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MailBuddy.UpdateFontAndColor(previewLabel3, "subjects", 1)
                MailBuddy.UpdateFontAndColor(MailBuddy.subjectPages.selectedLabel, "subjects", 1)
            end,
            width = "half",
            default = defaultSettings.font["subjects"][1].color,
        },

        {
            type = 'dropdown',
            name = locVars["options_font_subjects_box"],
            choices = MailBuddy.LMP:List('font'),
            getFunc = function() return settings.font["subjects"][2].family end,
            setFunc = function(value) settings.font["subjects"][2].family = value
                MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MailBuddy.UpdateAllLabels("subjects", -1, -1)
            end,
            default = defaultSettings.font["subjects"][2].family,
        },
        {
            type = "slider",
            name = locVars["options_font_subjects_box_size"],
            min = 8,
            max = 32,
            getFunc = function() return settings.font["subjects"][2].size end,
            setFunc = function(size) settings.font["subjects"][2].size = size
                MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MailBuddy.UpdateAllLabels("subjects", -1, -1)
            end,
            default = defaultSettings.font["subjects"][2].size,
        },
        {
            type = 'dropdown',
            name = locVars["options_font_subjects_box_style"],
            choices = MailBuddy.settingsVars.fontStyles,
            getFunc = function() return settings.font["subjects"][2].style end,
            setFunc = function(value) settings.font["subjects"][2].style = value
                MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MailBuddy.UpdateAllLabels("subjects", -1, -1)
            end,
            width = "half",
            default = defaultSettings.font["subjects"][2].style,
        },
        {
            type = "colorpicker",
            name = locVars["options_font_subjects_box_color"],
            getFunc = function() return settings.font["subjects"][2].color.r, settings.font["subjects"][2].color.g, settings.font["subjects"][2].color.b, settings.font["subjects"][2].color.a end,
            setFunc = function(r,g,b,a) settings.font["subjects"][2].color = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
                MailBuddy.UpdateFontAndColor(previewLabel4, "subjects", 2)
                MailBuddy.UpdateAllLabels("subjects", -1, -1)
            end,
            width = "half",
            default = defaultSettings.font["subjects"][2].color,
        },

        {
            type = 'header',
            name = locVars["options_additional"],
        },
        {
            type = "checkbox",
            name = locVars["options_toggle_recipients_box_click"],
            tooltip = locVars["options_toggle_recipients_box_click_tooltip"],
            getFunc = function() return settings.additional["RecipientsBoxVisibility"] end,
            setFunc = function(value) settings.additional["RecipientsBoxVisibility"] = not settings.additional["RecipientsBoxVisibility"] end,
            default = defaultSettings.additional["RecipientsBoxVisibility"],
            disabled = function() return settings.useAlternativeLayout end,
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_toggle_subjects_box_click"],
            tooltip = locVars["options_toggle_subjects_box_click_tooltip"],
            getFunc = function() return settings.additional["SubjectsBoxVisibility"] end,
            setFunc = function(value) settings.additional["SubjectsBoxVisibility"] = not settings.additional["SubjectsBoxVisibility"] end,
            default = defaultSettings.additional["SubjectsBoxVisibility"],
            disabled = function() return settings.useAlternativeLayout end,
            width   = "full",
        },
        {
            type = 'header',
            name = locVars["options_standard_mail"],
        },
        {
            type = "editbox",
            name = locVars["options_standard_recipient"],
            tooltip = locVars["options_standard_recipient_tooltip"],
            getFunc = function() return settings.standard["To"] end,
            setFunc = function(newValue)
                settings.standard["To"] = newValue
            end,
            width = "full",
            default = defaultSettings.standard["To"],
            reference = "MailBuddy_StandardRecipientName_SettingsEdit",
            disabled = function() return settings.remember.recipient["last"] end,
        },
        {
            type = "editbox",
            name = locVars["options_standard_subject"],
            tooltip = locVars["options_standard_subject_tooltip"],
            getFunc = function() return settings.standard["Subject"] end,
            setFunc = function(newValue)
                settings.standard["Subject"] = newValue
            end,
            width = "full",
            default = defaultSettings.standard["Subject"],
            disabled = function() return settings.remember.subject["last"] end,
        },
        {
            type = 'header',
            name = locVars["options_mail_brain"],
        },
        {
            type = "checkbox",
            name = locVars["options_reuse_recipient"],
            tooltip = locVars["options_reuse_recipient_tooltip"],
            getFunc = function() return settings.remember.recipient["last"] end,
            setFunc = function(value) settings.remember.recipient["last"] = not settings.remember.recipient["last"] end,
            default = defaultSettings.remember.recipient["last"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_reuse_subject"],
            tooltip = locVars["options_reuse_subject_tooltip"],
            getFunc = function() return settings.remember.subject["last"] end,
            setFunc = function(value) settings.remember.subject["last"] = not settings.remember.subject["last"] end,
            default = defaultSettings.remember.subject["last"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_reuse_body"],
            tooltip = locVars["options_reuse_body_tooltip"],
            getFunc = function() return settings.remember.body["last"] end,
            setFunc = function(value) settings.remember.body["last"] = not settings.remember.body["last"] end,
            default = defaultSettings.remember.body["last"],
            width   = "full",
        },
        {
            type = 'header',
            name = locVars["options_automatism"],
        },
        {
            type = "checkbox",
            name = locVars["options_auto_hide_recipients_box"],
            tooltip = locVars["options_auto_hide_recipients_box_tooltip"],
            getFunc = function() return settings.automatism.hide["RecipientsBox"] end,
            setFunc = function(value) settings.automatism.hide["RecipientsBox"] = not settings.automatism.hide["RecipientsBox"] end,
            default = defaultSettings.automatism.hide["RecipientsBox"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_auto_hide_subjects_box"],
            tooltip = locVars["options_auto_hide_subjects_box_tooltip"],
            getFunc = function() return settings.automatism.hide["SubjectsBox"] end,
            setFunc = function(value) settings.automatism.hide["SubjectsBox"] = not settings.automatism.hide["SubjectsBox"] end,
            default = defaultSettings.automatism.hide["SubjectsBox"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_auto_close_recipients_box"],
            tooltip = locVars["options_auto_close_recipients_box_tooltip"],
            getFunc = function() return settings.automatism.close["RecipientsBox"] end,
            setFunc = function(value) settings.automatism.close["RecipientsBox"] = not settings.automatism.close["RecipientsBox"] end,
            default = defaultSettings.automatism.close["RecipientsBox"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_auto_close_subjects_box"],
            tooltip = locVars["options_auto_close_subjects_box_tooltip"],
            getFunc = function() return settings.automatism.close["SubjectsBox"] end,
            setFunc = function(value) settings.automatism.close["SubjectsBox"] = not settings.automatism.close["SubjectsBox"] end,
            default = defaultSettings.automatism.close["SubjectsBox"],
            width   = "full",
        },
        {
            type = 'header',
            name = locVars["options_autofocus"],
        },
        {
            type = "checkbox",
            name = locVars["options_auto_focus_recipients_field"],
            tooltip = locVars["options_auto_focus_recipients_field_tooltip"],
            getFunc = function() return settings.automatism.focus["To"] end,
            setFunc = function(value) settings.automatism.focus["To"] = not settings.automatism.focus["To"] end,
            default = defaultSettings.automatism.focus["To"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_auto_focus_auto_open_recipients_field"],
            tooltip = locVars["options_auto_focus_auto_open_recipients_field_tooltip"],
            getFunc = function() return settings.automatism.focusOpen["To"] end,
            setFunc = function(value) settings.automatism.focusOpen["To"] = not settings.automatism.focusOpen["To"] end,
            default = defaultSettings.automatism.focusOpen["To"],
            disabled = function() return not settings.automatism.focus["To"] end,
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_auto_focus_subjects_field"],
            tooltip = locVars["options_auto_focus_subjects_field_tooltip"],
            getFunc = function() return settings.automatism.focus["Subject"] end,
            setFunc = function(value) settings.automatism.focus["Subject"] = not settings.automatism.focus["Subject"] end,
            default = defaultSettings.automatism.focus["Subject"],
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_auto_focus_auto_open_subjects_field"],
            tooltip = locVars["options_auto_focus_auto_open_subjects_field_tooltip"],
            getFunc = function() return settings.automatism.focusOpen["Subject"] end,
            setFunc = function(value) settings.automatism.focusOpen["Subject"] = not settings.automatism.focusOpen["Subject"] end,
            default = defaultSettings.automatism.focusOpen["Subject"],
            disabled = function() return not settings.automatism.focus["Subject"] end,
            width   = "full",
        },
        {
            type = "checkbox",
            name = locVars["options_auto_focus_body_field"],
            tooltip = locVars["options_auto_focus_body_field_tooltip"],
            getFunc = function() return settings.automatism.focus["Body"] end,
            setFunc = function(value) settings.automatism.focus["Body"] = not settings.automatism.focus["Body"] end,
            default = defaultSettings.automatism.focus["Body"],
            width   = "full",
        },
        {
            type = 'header',
            name = locVars["options_header_sender"],
        },
        {
            type = "checkbox",
            name = locVars["options_show_account_name"],
            tooltip = locVars["options_show_account_name_tooltip"],
            getFunc = function() return settings.showAccountName end,
            setFunc = function(value) settings.showAccountName = not settings.showAccountName end,
            default = defaultSettings.showAccountName,
            width   = "full",
            disabled = function() return settings.showCharacterName end,
        },
        {
            type = "checkbox",
            name = locVars["options_show_character_name"],
            tooltip = locVars["options_show_character_name_tooltip"],
            getFunc = function() return settings.showCharacterName end,
            setFunc = function(value) settings.showCharacterName = not settings.showCharacterName end,
            default = defaultSettings.showCharacterName,
            width   = "full",
            disabled = function() return settings.showAccountName end,
        },
        {
            type = 'header',
            name = locVars["options_header_inbox"],
        },
        {
            type = "checkbox",
            name = locVars["options_show_mail_count"],
            tooltip = locVars["options_show_mail_count_tooltip"],
            getFunc = function() return settings.showTotalMailCountInInbox end,
            setFunc = function(value) settings.showTotalMailCountInInbox = not settings.showTotalMailCountInInbox end,
            default = defaultSettings.showTotalMailCountInInbox,
            width   = "full",
        },

    } -- END OF OPTIONS TABLE
    MailBuddy.LAM:RegisterOptionControls(MailBuddy.addonVars.name.."panel", optionsTable)
end
MailBuddy = MailBuddy or {}

--=============================================================================================================
--	LOAD USER SETTINGS
--=============================================================================================================
--Load the SavedVariables now
function MailBuddy.LoadUserSettings()
    local addonVars = MailBuddy.addonVars

    if not addonVars.gSettingsLoaded then
        --Prepare the keybindings in the keybindstrip
        MailBuddy.keystripDefCopyFriend = {
            {
                name = MailBuddy.GetLocText("SI_BINDING_NAME_MAILBUDDY_FRIEND_COPY", true),
                keybind = "MAILBUDDY_COPY",
                callback = function() MailBuddy.CopyNameUnderControl() end,
                alignment = KEYBIND_STRIP_ALIGN_CENTER,
            }
        }
        MailBuddy.keystripDefCopyGuildMember = {
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

        local settingsVars = MailBuddy.settingsVars

        --=========== BEGIN - SAVED VARIABLES ==========================================
        --Load the user's MailBuddy.settingsVars.settings from SavedVariables file -> Account wide of basic version 999 at first
        MailBuddy.settingsVars.defaultSettings = ZO_SavedVars:NewAccountWide(addonVars.savedVariablesName, 999, "SettingsForAll", settingsVars.firstRunSettings)

        --Check, by help of basic version 999 MailBuddy.settingsVars.settings, if the settings should be loaded for each character or account wide
        --Use the current addon version to read the MailBuddy.settingsVars.settings now
        if (settingsVars.defaultSettings.saveMode == 1) then
            MailBuddy.settingsVars.settings = ZO_SavedVars:New(addonVars.savedVariablesName, settingsVars.settingsVersion , "Settings", settingsVars.defaults)
            --MailBuddy.settingsVars.settings = ZO_SavedVars:NewCharacterIdSettings(addonVars.savedVariablesName, MailBuddy.settingsVars.settingsVersion , "Settings", MailBuddy.settingsVars.defaults)
        elseif (settingsVars.defaultSettings.saveMode == 2) then
            MailBuddy.settingsVars.settings = ZO_SavedVars:NewAccountWide(addonVars.savedVariablesName, settingsVars.settingsVersion, "Settings", settingsVars.defaults)
        end
        --=========== END - SAVED VARIABLES ============================================

        local settings = MailBuddy.settingsVars.settings

        --Read the settings and set the mail recipient names
        for idx, recipientName in pairs(settings.SetRecipient) do
            --d("Recipient name: " .. recipientName .. ", index: " .. idx)
            if recipientName ~= "" and not RemoveOwnCharactersFromSavedRecipients(idx, recipientName) then
                local page, pageEntry = MailBuddy.mapPageAndEntry(idx, "recipient")
                if page ~= nil and pageEntry ~= nil then
                    local editControl = WINDOW_MANAGER:GetControlByName(MailBuddy.recipientPages.pages[page][pageEntry], "")
                    if editControl ~= nil then
                        local recipientNameAbbreviated = settings.SetRecipientAbbreviated[idx] or recipientName
                        editControl:SetText(string.format(recipientNameAbbreviated))
                        MailBuddy.UpdateEditFieldToolTip(editControl, recipientName, recipientNameAbbreviated)
                    end
                end
            end
        end

        --Read the settings and set the mail subjects
        for idx, subjectText in pairs(settings.SetSubject) do
            if subjectText ~= "" then
                local page, pageEntry = MailBuddy.mapPageAndEntry(idx, "subject")
                if page ~= nil and pageEntry ~= nil then
                    local subjectEditControl = WINDOW_MANAGER:GetControlByName(MailBuddy.subjectPages.pages[page][pageEntry], "")
                    if subjectEditControl ~= nil then
                        local subjectTextAbbreviated = settings.SetSubjectAbbreviated[idx] or subjectText
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

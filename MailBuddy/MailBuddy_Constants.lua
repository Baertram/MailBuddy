    --The addon table/array
    MailBuddy = {}
    local MB = MailBuddy
    MB.UI = {}

    --Information about the addon
    local addonVars = {}
    MB.addonVars = addonVars
    addonVars.name              = "MailBuddy"
    addonVars.displayName       = "|cFFFF00MailBuddy|r"
    addonVars.author            = "Minceraft, Baertram"
	addonVars.addonVersionOptionsNumber = 3.1
    addonVars.version = tostring(addonVars.addonVersionOptionsNumber)
    addonVars.website       	= "https://www.esoui.com/downloads/info866-MailBuddy.html"
    addonVars.feedback       	= "https://www.esoui.com/forums/private.php?do=newpm&u=2028"
    addonVars.donation       	= "https://www.esoui.com/portal.php?id=136&a=faq&faqid=131"

    addonVars.savedVariablesName_OLD    = "MailBuddy_SavedVars"
    addonVars.savedVariablesVersion_OLD = 2.4
    addonVars.savedVariablesName        = "MailBuddy_Server_SavedVars"
    addonVars.gSettingsLoaded = false

    --Prefix for the GetString calls
    MB.LocalizationPrefix = "MAILBUDDY_"

    --Libraries
    MB.LAM = LibAddonMenu2
    MB.LMP = LibMediaProvider

    --The arrays for the saved variables
    MB.settingsVars	= {}
    MB.settingsVars.settingsVersion = 4.0
    MB.settingsVars.settingsSubtable = "Settings"
    MB.settingsVars.settingsForAllSubtable = "SettingsForAll"
    MB.settingsVars.fontStyles = {
        "none",
        "outline",
        "thin-outline",
        "thick-outline",
        "shadow",
        "soft-shadow-thin",
        "soft-shadow-thick",
    }
    --Additional settings arrays for the first run of this addon, default values, etc.
    MB.settingsVars.settings			= {}
    MB.settingsVars.defaultSettings	= {}
    MB.settingsVars.firstRunSettings = {}

    --The default settings (loaded if no SavedVariables are given)
    MB.settingsVars.defaults = {
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
    MB.settingsVars.firstRunSettings = {
        language 	 		    = 1, --Standard: English
        saveMode     		    = 2, --Standard: Account wide settings
    }

    --ZO_SortFilterList data
    MB.SCROLLLIST_DATATYPE_RECIPIENTS   = 1
    MB.SCROLLLIST_DATATYPE_SUBJECTS     = 2

    --The LAM settings panel
	MB.SettingsPanel = nil

    --Array with prevention variables
    MB.preventerVars = {}
    MB.preventerVars.gLocalizationDone = false
    MB.preventerVars.KeyBindingTexts   = false
    MB.preventerVars.dontUseLastRecipientName = false

	--Build list of saved text controls for the recipients
	MB.recipientPages = {}
    MB.recipientPages.pages = {}
	--Page 1
    MB.recipientPages.pages[1] = {}
    table.insert(MB.recipientPages.pages[1], 1, "MailBuddy_RecipientsPage1CustomRecipientLabel1")
    table.insert(MB.recipientPages.pages[1], 2, "MailBuddy_RecipientsPage1CustomRecipientLabel2")
    table.insert(MB.recipientPages.pages[1], 3, "MailBuddy_RecipientsPage1CustomRecipientLabel3")
    table.insert(MB.recipientPages.pages[1], 4, "MailBuddy_RecipientsPage1CustomRecipientLabel4")
    table.insert(MB.recipientPages.pages[1], 5, "MailBuddy_RecipientsPage1CustomRecipientLabel5")
    table.insert(MB.recipientPages.pages[1], 6, "MailBuddy_RecipientsPage1CustomRecipientLabel6")
    table.insert(MB.recipientPages.pages[1], 7, "MailBuddy_RecipientsPage1CustomRecipientLabel7")
	--Page 2
    MB.recipientPages.pages[2] = {}
    table.insert(MB.recipientPages.pages[2], 1, "MailBuddy_RecipientsPage2CustomRecipientLabel8")
    table.insert(MB.recipientPages.pages[2], 2, "MailBuddy_RecipientsPage2CustomRecipientLabel9")
    table.insert(MB.recipientPages.pages[2], 3, "MailBuddy_RecipientsPage2CustomRecipientLabel10")
    table.insert(MB.recipientPages.pages[2], 4, "MailBuddy_RecipientsPage2CustomRecipientLabel11")
    table.insert(MB.recipientPages.pages[2], 5, "MailBuddy_RecipientsPage2CustomRecipientLabel12")
    table.insert(MB.recipientPages.pages[2], 6, "MailBuddy_RecipientsPage2CustomRecipientLabel13")
    table.insert(MB.recipientPages.pages[2], 7, "MailBuddy_RecipientsPage2CustomRecipientLabel14")
	--Page 3
    MB.recipientPages.pages[3] = {}
    table.insert(MB.recipientPages.pages[3], 1, "MailBuddy_RecipientsPage3CustomRecipientLabel15")
    table.insert(MB.recipientPages.pages[3], 2, "MailBuddy_RecipientsPage3CustomRecipientLabel16")
    table.insert(MB.recipientPages.pages[3], 3, "MailBuddy_RecipientsPage3CustomRecipientLabel17")
    table.insert(MB.recipientPages.pages[3], 4, "MailBuddy_RecipientsPage3CustomRecipientLabel18")
    table.insert(MB.recipientPages.pages[3], 5, "MailBuddy_RecipientsPage3CustomRecipientLabel19")
    table.insert(MB.recipientPages.pages[3], 6, "MailBuddy_RecipientsPage3CustomRecipientLabel20")
    table.insert(MB.recipientPages.pages[3], 7, "MailBuddy_RecipientsPage3CustomRecipientLabel21")

	--Variables for the entries on recipient pages
    MB.recipientPages.entriesPerPage = 7
    MB.recipientPages.totalEntries = 21
    MB.recipientPages.maxEntriesUntilHere = {}
    MB.recipientPages.maxEntriesUntilHere[1] = 7
    MB.recipientPages.maxEntriesUntilHere[2] = 14
    MB.recipientPages.maxEntriesUntilHere[3] = 21
    MB.recipientPages.selectedLabel = "MailBuddy_MailSendRecipientLabelActiveText"

	--Build list of saved text controls for the subjects
	MB.subjectPages = {}
    MB.subjectPages.pages = {}
	--Page 1
    MB.subjectPages.pages[1] = {}
    table.insert(MB.subjectPages.pages[1], 1, "MailBuddy_SubjectsPage1CustomSubjectLabel1")
    table.insert(MB.subjectPages.pages[1], 2, "MailBuddy_SubjectsPage1CustomSubjectLabel2")
    table.insert(MB.subjectPages.pages[1], 3, "MailBuddy_SubjectsPage1CustomSubjectLabel3")
    table.insert(MB.subjectPages.pages[1], 4, "MailBuddy_SubjectsPage1CustomSubjectLabel4")
    table.insert(MB.subjectPages.pages[1], 5, "MailBuddy_SubjectsPage1CustomSubjectLabel5")
	--Page 2
    MB.subjectPages.pages[2] = {}
    table.insert(MB.subjectPages.pages[2], 1, "MailBuddy_SubjectsPage2CustomSubjectLabel6")
    table.insert(MB.subjectPages.pages[2], 2, "MailBuddy_SubjectsPage2CustomSubjectLabel7")
    table.insert(MB.subjectPages.pages[2], 3, "MailBuddy_SubjectsPage2CustomSubjectLabel8")
    table.insert(MB.subjectPages.pages[2], 4, "MailBuddy_SubjectsPage2CustomSubjectLabel9")
    table.insert(MB.subjectPages.pages[2], 5, "MailBuddy_SubjectsPage2CustomSubjectLabel10")
	--Page 3
    MB.subjectPages.pages[3] = {}
    table.insert(MB.subjectPages.pages[3], 1, "MailBuddy_SubjectsPage3CustomSubjectLabel11")
    table.insert(MB.subjectPages.pages[3], 2, "MailBuddy_SubjectsPage3CustomSubjectLabel12")
    table.insert(MB.subjectPages.pages[3], 3, "MailBuddy_SubjectsPage3CustomSubjectLabel13")
    table.insert(MB.subjectPages.pages[3], 4, "MailBuddy_SubjectsPage3CustomSubjectLabel14")
    table.insert(MB.subjectPages.pages[3], 5, "MailBuddy_SubjectsPage3CustomSubjectLabel15")

	--Variables for the entries on subject pages
    MB.subjectPages.entriesPerPage = 5
    MB.subjectPages.totalEntries = 15
    MB.subjectPages.maxEntriesUntilHere = {}
    MB.subjectPages.maxEntriesUntilHere[1] = 5
    MB.subjectPages.maxEntriesUntilHere[2] = 10
    MB.subjectPages.maxEntriesUntilHere[3] = 15
    MB.subjectPages.selectedLabel = "MailBuddy_MailSendSubjectLabelActiveText"

	--Boolean value to check if the keybind was pressed
    MB.keybindUsed = false

	--Get the current player name
    MB.playerName = GetUnitName("player")
    --get the current account name
    MB.accountName = GetDisplayName()

    MB.characterName2Id = {}
    MB.characterId2Name = {}
    MB.characterNameRaw2Id = {}
    MB.characterId2NameRaw = {}

    --Maximum characters shown inside the recipients/subjects list (tested with letter W, which is the widest)
    MB.maximumCharacters = {
    	["recipients"]	= 14,
        ["subjects"]	= 10,
    }
    --MailBuddy controls
    MB.subjectsBox = nil
    MB.recipientsBox = nil
    MB.editSubject = nil
    MB.editRecipient = nil
    MB.subjectsLabel = nil
    MB.recipientsLabel = nil
    MB.mailSendFromLabel = nil

    --Backup the edit click sound
    SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"] = SOUNDS["EDIT_CLICK"]

    --Keybindstrip variables
    MB.keyStripVars = {}
    MB.keyStripVars.keystripDefCopyFriend         = {}
    MB.keyStripVars.keystripDefCopyGuildMember    = {}

    --Other addons
    MB.otherAddons = {}
    MB.otherAddons.isMailRActive = false
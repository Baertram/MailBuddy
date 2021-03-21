--Global variable
MailBuddy = {}

------------------------------------------------------------------------------------------------------------------------
--Information about the addon
MailBuddy.addonVars = {}
MailBuddy.addonVars.name = "MailBuddy"
MailBuddy.addonVars.displayName = "|cFFFF00MailBuddy|r"
MailBuddy.addonVars.author = "|cFF0000Minceraft|r and |cFFFF00Baertram|r"
MailBuddy.addonVars.addonVersionOptionsNumber = 4.0
local addonVars = MailBuddy.addonVars
MailBuddy.addonVars.version = tostring(addonVars.addonVersionOptionsNumber)

------------------------------------------------------------------------------------------------------------------------
--SavedVariables name and version
MailBuddy.addonVars.savedVariablesName      = addonVars.name .. "_SavedVars"
MailBuddy.addonVars.savedVariablesVersion   = 2.4 --Last changed 2018

------------------------------------------------------------------------------------------------------------------------
--Librraies
MailBuddy.LAM   = LibAddonMenu2
MailBuddy.LMP   = LibMediaProvider
MailBuddy.LIBLA = LibLoadedAddons

------------------------------------------------------------------------------------------------------------------------
--Flags
MailBuddy.addonVars.gSettingsLoaded = false

------------------------------------------------------------------------------------------------------------------------
--Get the current client language
MailBuddy.clientLang = GetCVar("language.2")
--Get the current player name
MailBuddy.playerName = GetUnitName("player")
--get the current account name
MailBuddy.accountName = GetDisplayName()

------------------------------------------------------------------------------------------------------------------------
--The arrays for the saved variables
MailBuddy.settingsVars	= {}
MailBuddy.settingsVars.settingsVersion = addonVars.savedVariablesVersion
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

------------------------------------------------------------------------------------------------------------------------
--The LAM settings panel
MailBuddy.SettingsPanel = nil

------------------------------------------------------------------------------------------------------------------------
--Array with prevention variables
MailBuddy.preventerVars = {}
MailBuddy.preventerVars.gLocalizationDone = false
MailBuddy.preventerVars.KeyBindingTexts   = false
MailBuddy.preventerVars.dontUseLastRecipientName = false

------------------------------------------------------------------------------------------------------------------------
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

------------------------------------------------------------------------------------------------------------------------
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

------------------------------------------------------------------------------------------------------------------------
--Boolean value to check if the keybind was pressed
MailBuddy.keybindUsed = false

--Maximum characters shown inside the recipients/subjects list (tested with letter W, which is the widest)
MailBuddy.maximumCharacters = {
    ["recipients"]	= 14,
    ["subjects"]	= 10,
}

------------------------------------------------------------------------------------------------------------------------
--MailBuddy controls
MailBuddy.subjectsBox = nil
MailBuddy.recipientsBox = nil
MailBuddy.editSubject = nil
MailBuddy.editRecipient = nil
MailBuddy.subjectsLabel = nil
MailBuddy.recipientsLabel = nil
MailBuddy.mailSendFromLabel = nil

------------------------------------------------------------------------------------------------------------------------
--Localization variables
MailBuddy.localizationVars = {}
MailBuddy.localizationVars.mb_loc 	 	= {}

------------------------------------------------------------------------------------------------------------------------
--Keybindstrip variables
MailBuddy.keystripDefCopyFriend         = {}
MailBuddy.keystripDefCopyGuildMember    = {}

------------------------------------------------------------------------------------------------------------------------
--Other addons
MailBuddy.otherAddons = {}
MailBuddy.otherAddons.isMailRActive = false

------------------------------------------------------------------------------------------------------------------------
---SOUNDS
--Backup the edit click sound
SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"] = SOUNDS["EDIT_CLICK"]
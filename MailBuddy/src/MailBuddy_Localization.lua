MailBuddy = MailBuddy or {}

--Localized texts etc.
function MailBuddy.Localization()
    --Was localization already done during keybindings? Then abort here
    if MailBuddy.preventerVars.KeyBindingTexts == true and MailBuddy.preventerVars.gLocalizationDone == true then return end


    --Load the saved variables if not already given
    MailBuddy.LoadUserSettings()

    local defSettings   = MailBuddy.settingsVars.defaultSettings
    local settings      = MailBuddy.settingsVars.settings

    --Fallback to english
    if (defSettings.language == nil or
        (defSettings.language ~= 1 and defSettings.language ~= 2 and defSettings.language ~= 3 and defSettings.language ~= 4 and defSettings.language ~= 5)) then
        MailBuddy.settingsVars.defaultSettings.language = 1
    end
    --Is the standard language english set?
    if (MailBuddy.preventerVars.KeyBindingTexts == true or (defSettings.language == 1 and settings.languageChoosen == false)) then
        local lang = MailBuddy.clientLang
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
    MailBuddy.localizationVars.mb_loc = MailBuddy.mb_loc[defSettings.language]

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
    local locVars = MailBuddy.localizationVars.mb_loc
    if textName == nil or locVars == nil or locVars[textName] == nil then return "" end
    return locVars[textName]
end
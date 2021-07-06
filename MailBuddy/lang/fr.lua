local frStrings = {
		-- Options menu
        ["options_description"]                          = "Vous aide à gérer facilement vos destinataires et sujets de courrier",
		["options_header1"] 							 = "Général",
		["options_language"]							 = "Langue",
		["options_language_tooltip"]					 = "Choisir la langue",
		["options_language_dropdown_selection1"]		 = "Anglais",
		["options_language_dropdown_selection2"]		 = "Allemand",
		["options_language_dropdown_selection3"]		 = "Français",
		["options_language_dropdown_selection4"] 		 = "Espagnol",
        ["options_language_dropdown_selection5"]         = "Italian",
		["options_language_description1"]				 = "ATTENTION : Modifier un de ces réglages provoquera un rechargement",
		["options_savedvariables"]						 = "Sauvegarder",
		["options_savedvariables_tooltip"] 				 = "Sauvegarder les données de l'addon pour tous les personages du compte, ou individuellement pour chaque personage",
		["options_savedVariables_dropdown_selection1"]	 = "Individuellement",
		["options_savedVariables_dropdown_selection2"]	 = "Compte",
}


for stringId, stringValue in pairs(frStrings) do
    SafeAddString(_G["MAILBUDDY_" .. stringId], stringValue, 2)
end

local keyBindingsFr = {
    --Key bindings
    ["SI_BINDING_NAME_MAILBUDDY_COPY"]		         = "Nom -> MailBuddy",
    ["SI_BINDING_NAME_MAILBUDDY_FRIEND_COPY"]		 = "Ami -> MailBuddy",
    ["SI_BINDING_NAME_MAILBUDDY_GUILD_MEMBER_COPY"]	 = "Membre -> MailBuddy",
}
for stringId, stringValue in pairs(keyBindingsFr) do
   SafeAddString(stringId, stringValue, 2)
end
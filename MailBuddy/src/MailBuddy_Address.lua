MailBuddy = MailBuddy or {}

function MailBuddy.UpdateRecipientText(pageIndex, doDelete)
	if pageIndex == nil then return end
	doDelete = doDelete or false

    local page, pageEntry = MailBuddy.mapPageAndEntry(pageIndex, "recipient")
    if page ~= nil and pageEntry ~= nil then
		if MailBuddy.recipientPages.pages[page][pageEntry] ~= "" then
			local labelControl = WINDOW_MANAGER:GetControlByName(MailBuddy.recipientPages.pages[page][pageEntry], "")
	        if labelControl ~= nil then
				--local currentName = labelControl:GetText()
                local currentName = MailBuddy.settingsVars.settings.SetRecipient[pageIndex]
                local currentNameAbbreviated = MailBuddy.settingsVars.settings.SetRecipientAbbreviated[pageIndex] or currentName
                if currentName ~= nil and currentName ~= "" then
				    if doDelete then
						labelControl:SetText("")
						MailBuddy.settingsVars.settings.SetRecipient[pageIndex] = ""
                        MailBuddy.settingsVars.settings.SetRecipientAbbreviated[pageIndex] = ""
						MailBuddy.PlaySoundNow(SOUNDS["MAIL_ITEM_DELETED"])
	                    if MailBuddy.editRecipient ~= nil then
		                    MailBuddy.editRecipient:TakeFocus()
	                    end
					else
                        if not MailBuddy.settingsVars.settings.useAlternativeLayout then
                            MailBuddy_MailSendRecipientLabelActiveText:SetText(string.format(currentNameAbbreviated))
						    MailBuddy.UpdateEditFieldToolTip(MailBuddy_MailSendRecipientLabelActiveText, currentName, currentNameAbbreviated)
                        else
                            ZO_MailSendToField:SetText(string.format(currentName))
                        end
						MailBuddy.settingsVars.settings.curRecipient = currentName
                        MailBuddy.settingsVars.settings.curRecipientAbbreviated = currentNameAbbreviated
                        --Remember the last used recipient text
                        MailBuddy.settingsVars.settings.remember.recipient["text"] = currentName
                        MailBuddy.FocusNextField()
                        MailBuddy.PlaySoundNow(SOUNDS["QUEST_FOCUSED"])
                        MailBuddy.AutoCloseBox("recipients")
                    end
				end
	        end
	    end
    end
    --Revert to the original edit box clicked sound
    SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
end

function MailBuddy.UpdateSubjectText(pageIndex, doDelete, newText)
	if pageIndex == nil and (newText == nil or newText == "") then return end
    --Only update the MailBuddy label/ZOs mail subject field witht he given text here
	if pageIndex == nil and (newText ~= nil and newText ~= "") then
        if not MailBuddy.settingsVars.settings.useAlternativeLayout then
            MailBuddy_MailSendSubjectLabelActiveText:SetText(string.format(newText))
            MailBuddy.UpdateEditFieldToolTip(MailBuddy_MailSendSubjectLabelActiveText, newText, newText)
        else
            ZO_MailSendSubjectField:SetText(string.format(newText))
        end
        MailBuddy.settingsVars.settings.curSubject = newText
        MailBuddy.settingsVars.settings.curSubjectAbbreviated = newText
        --Remember the last used subject text
        MailBuddy.settingsVars.settings.remember.subject["text"]   = newText
        MailBuddy.FocusNextField()
        MailBuddy.PlaySoundNow(SOUNDS["QUEST_FOCUSED"])
        MailBuddy.AutoCloseBox("subjects")
        --Revert to the original edit box clicked sound
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
        return
    end
	doDelete = doDelete or false

    local page, pageEntry = MailBuddy.mapPageAndEntry(pageIndex, "subject")
    if page ~= nil and pageEntry ~= nil then
		if MailBuddy.subjectPages.pages[page][pageEntry] ~= "" then
			local labelControl = WINDOW_MANAGER:GetControlByName(MailBuddy.subjectPages.pages[page][pageEntry], "")
	        if labelControl ~= nil then
				--local currentSubject = labelControl:GetText()
    			local currentSubject = MailBuddy.settingsVars.settings.SetSubject[pageIndex]
    			local currentSubjectAbbreviated = MailBuddy.settingsVars.settings.SetSubjectAbbreviated[pageIndex] or currentSubject
				if currentSubject ~= nil and currentSubject ~= "" then
				    if doDelete then
						labelControl:SetText("")
						MailBuddy.settingsVars.settings.SetSubject[pageIndex] = ""
						MailBuddy.settingsVars.settings.SetSubjectAbbreviated[pageIndex] = ""
						MailBuddy.PlaySoundNow(SOUNDS["MAIL_ITEM_DELETED"])
                        if MailBuddy.editSubject ~= nil then
	                        MailBuddy.editSubject:TakeFocus()
                        end
					else
                        if not MailBuddy.settingsVars.settings.useAlternativeLayout then
                            MailBuddy_MailSendSubjectLabelActiveText:SetText(string.format(currentSubjectAbbreviated))
                            MailBuddy.UpdateEditFieldToolTip(MailBuddy_MailSendSubjectLabelActiveText, currentSubject, currentSubjectAbbreviated)
                        else
                            ZO_MailSendSubjectField:SetText(string.format(currentSubject))
                        end
						MailBuddy.settingsVars.settings.curSubject = currentSubject
                        MailBuddy.settingsVars.settings.curSubjectAbbreviated = currentSubjectAbbreviated
                        --Remember the last used subject text
                        MailBuddy.settingsVars.settings.remember.subject["text"]   = currentSubject
                        MailBuddy.FocusNextField()
                        MailBuddy.PlaySoundNow(SOUNDS["QUEST_FOCUSED"])
                        MailBuddy.AutoCloseBox("subjects")
                    end
				end
	        end
	    end
    end
    --Revert to the original edit box clicked sound
    SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
end

function MailBuddy.StoreRecipient()
    --Check if the keybinding was pressed inside the guild roster or friends list, or if the mail send panel is open
    --and abort if not one of the panels is opened
    if 	  ZO_GuildRoster:IsHidden()
       and ZO_KeyboardFriendsList:IsHidden()
       and ZO_MailSend:IsHidden() then
    	return
    elseif not ZO_MailSend:IsHidden() and MailBuddy.keybindUsed then
    	return
    end

--d("StoreRecipients")
    --The new entered recipient text (sent by RETURN key)
	local enteredName = MailBuddy_MailSendRecipientsBoxEditNewRecipient:GetText()
	--Abort here if no name was given and just RETURN key was pressed
	if enteredName == "" or enteredName == MailBuddy.playerName or enteredName == MailBuddy.accountName then
    	return
    else
    	--Check if the entered name is valid
		local enteredNameFirstChar = string.sub(enteredName, 1)
        if enteredNameFirstChar:match("^[@A-Za-z0-9]+") == nil then
        	return
        end

    	--Name can only be 128 characters in length
        if string.len(enteredName) > 128 then
	        enteredName = string.sub(enteredName, 1, 128)
        end
    end

	--Add the text of the already saved names to an arry for a later comparison etc.
	local SetRecipients = {}
    for i = 1, MailBuddy.recipientPages.totalEntries, 1 do
	    local page, pageEntry = MailBuddy.mapPageAndEntry(i, "recipient")
	    if page ~= nil and pageEntry ~= nil then
			local editControl = WINDOW_MANAGER:GetControlByName(MailBuddy.recipientPages.pages[page][pageEntry], "")
			if editControl ~= nil then
--d("SetRecipients["..i.."] = MailBuddy.recipientPages.pages["..page.."]["..pageEntry.."]: " .. editControl:GetName())
	   			SetRecipients[i] = editControl:GetText()
	        end
		end
    end

	--Check new entered name against given names now and add it, if not already in the list
	local alreadyInList = false
    local newEntry = {}
    newEntry.found = false
    newEntry.page = 0
    newEntry.pageEntry = 0
    newEntry.index = 0
	--Check all entered names before adding a new one
	for idx, nameText in pairs(SetRecipients) do
	    local page, pageEntry = MailBuddy.mapPageAndEntry(idx, "recipient")
	    if page ~= nil and pageEntry ~= nil then
--d("Stored name: " .. nameText .. ", New name: " .. enteredName)
			--Compare the stored name with the new entered name
			if string.lower(nameText) == string.lower(enteredName) then
				--d("[MailBuddy] Recipient name is already in the list!")
                MailBuddy.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
                d(MailBuddy.localizationVars.mb_loc["chat_output_recipient_already_in_list"])
                alreadyInList = true
				--Abort here as name is already in the list
		       	break
			end
	        --Check if an empty place is found
	        if nameText == "" then
--d("Stored name field is empty: Page " .. page .. ", index " .. pageEntry)
				--Mark empty place and remember the page + index
			    newEntry.found = true
			    newEntry.page = page
                newEntry.pageEntry = pageEntry
			    newEntry.index = idx
				--Break the loop here now as we have found an empty place to store the new name
	            break
            end
        end
    end
	--Was an empty entry found? Add the new name now
	if newEntry.found == true and newEntry.page ~= 0 and newEntry.index ~= 0 and newEntry.pageEntry ~= 0 then
        local newNameEditControl = WINDOW_MANAGER:GetControlByName(MailBuddy.recipientPages.pages[newEntry.page][newEntry.pageEntry], "")
		MailBuddy.settingsVars.settings.SetRecipient[newEntry.index] = enteredName
        local shortendName
        if string.len(enteredName) > MailBuddy.maximumCharacters["recipients"] then
        	shortendName = string.sub(enteredName, 1, (MailBuddy.maximumCharacters["recipients"])) .. "..."
        else
        	shortendName = enteredName
        end
        MailBuddy.settingsVars.settings.SetRecipientAbbreviated[newEntry.index] = shortendName
    	newNameEditControl:SetText(string.format(shortendName))
		MailBuddy.editRecipient:Clear()
		MailBuddy.UpdateEditFieldToolTip(newNameEditControl, enteredName, shortendName)
        if MailBuddy.settingsVars.settings.useAlternativeLayout then
            if ZO_MailSendToField:GetText() == "" then
                ZO_MailSendToField:SetText(string.format(enteredName))
                --Remember the last used recipient text
                MailBuddy.settingsVars.settings.remember.recipient["text"] = enteredName
            end
        end
        MailBuddy.FocusNextField()
    	MailBuddy.PlaySoundNow(nil, ITEM_SOUND_CATEGORY_RING, ITEM_SOUND_ACTION_SLOT)
        MailBuddy.AutoCloseBox("recipients")
        return
    elseif not alreadyInList then
        --d("[MailBuddy] Your recipients list is full. Please delete at least one entry!")
        MailBuddy.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
        d(MailBuddy.localizationVars.mb_loc["chat_output_recipient_list_full"])
    end
    --Revert to the original edit box clicked sound
    SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
	return
end

function MailBuddy.StoreSubject()
--d("StoreSub")
    --The new entered subject text (sent by RETURN key)
	local enteredSubject = MailBuddy_MailSendSubjectsBoxEditNewSubject:GetText()
	--Abort here if no subject was given and just RETURN key was pressed
	if enteredSubject == "" then
    	return
    else
		--Subject can only be 45 characters (currently) in length
        if string.len(enteredSubject) > MAIL_MAX_SUBJECT_CHARACTERS then
	        enteredSubject = string.sub(enteredSubject, 1, MAIL_MAX_SUBJECT_CHARACTERS)
        end
    	local lowerCaseEnteredSubject = string.lower(enteredSubject)
        if lowerCaseEnteredSubject == "return" or lowerCaseEnteredSubject == "rts" or lowerCaseEnteredSubject == "bounce" then
            --d("[MailBuddy] Subject is already fixed at the top of the list!")
            MailBuddy.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
            d(MailBuddy.localizationVars.mb_loc["chat_output_subject_already_in_fixed_list"])
            --Revert to the original edit box clicked sound
            return
        end
    end

	--Add the text of the already saved names to an arry for a later comparison etc.
	local SubjectLines = {}
    for i = 1, MailBuddy.subjectPages.totalEntries, 1 do
	    local page, pageEntry = MailBuddy.mapPageAndEntry(i, "subject")
	    if page ~= nil and pageEntry ~= nil then
--d("Page: " .. page .. ", pageEntry: " .. pageEntry)
			local editControl = WINDOW_MANAGER:GetControlByName(MailBuddy.subjectPages.pages[page][pageEntry], "")
			if editControl ~= nil then
--d("SubjectLines["..i.."] = MailBuddy.subjectPages.pages["..page.."]["..pageEntry.."]: " .. editControl:GetName())
	   			SubjectLines[i] = editControl:GetText()
	        end
		end
    end

	--Check new entered name against given names now and add it, if not already in the list
    local alreadyInList = false
	local newEntry = {}
    newEntry.found = false
    newEntry.page = 0
    newEntry.pageEntry = 0
    newEntry.index = 0
	--Check all entered names before adding a new one
	for idx, subjectText in pairs(SubjectLines) do
	    local page, pageEntry = MailBuddy.mapPageAndEntry(idx, "subject")
	    if page ~= nil and pageEntry ~= nil then
--d("Stored subject: " .. subjectText .. ", New subject: " .. enteredSubject)
			--Compare the stored subject with the new entered subject
			if string.lower(subjectText) == string.lower(enteredSubject) then
				--d("[MailBuddy] Subject is already in the list!")
                MailBuddy.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
            	d(MailBuddy.localizationVars.mb_loc["chat_output_subject_already_in_list"])
                alreadyInList = true
				--Abort here as subject is already in the list
		       	break
			end
	        --Check if an empty place is found
	        if subjectText == "" then
--d("Stored subject field is empty: Page " .. page .. ", index " .. pageEntry)
				--Mark empty place and remember the page + index
			    newEntry.found = true
			    newEntry.page = page
                newEntry.pageEntry = pageEntry
			    newEntry.index = idx
				--Break the loop here now as we have found an empty place to store the new subject
	            break
	        end
		end
	end
	--Was an empty entry found? Add the new subject now
	if newEntry.found == true and newEntry.page ~= 0 and newEntry.index ~= 0 and newEntry.pageEntry ~= 0 then
        local newSubjectEditControl = WINDOW_MANAGER:GetControlByName(MailBuddy.subjectPages.pages[newEntry.page][newEntry.pageEntry], "")
		MailBuddy.settingsVars.settings.SetSubject[newEntry.index] = enteredSubject
        local shortendSubject
        if string.len(enteredSubject) > MailBuddy.maximumCharacters["subjects"] then
			shortendSubject = string.sub(enteredSubject, 1, (MailBuddy.maximumCharacters["subjects"])) .. "..."
        else
        	shortendSubject = enteredSubject
        end
		MailBuddy.settingsVars.settings.SetSubjectAbbreviated[newEntry.index] = shortendSubject
    	newSubjectEditControl:SetText(string.format(shortendSubject))
		MailBuddy.UpdateEditFieldToolTip(newSubjectEditControl, enteredSubject, shortendSubject)
		MailBuddy.editRecipient:Clear()
        if MailBuddy.settingsVars.settings.useAlternativeLayout then
            if ZO_MailSendSubjectField:GetText() == "" then
                ZO_MailSendSubjectField:SetText(string.format(enteredSubject))
                --Remember the last used subject text
                MailBuddy.settingsVars.settings.remember.subject["text"]   = enteredSubject
            end
        end
        MailBuddy.FocusNextField()
    	MailBuddy.PlaySoundNow(nil, ITEM_SOUND_CATEGORY_RING, ITEM_SOUND_ACTION_SLOT)
        MailBuddy.AutoCloseBox("subjects")
        return
    elseif not alreadyInList then
        --d("[MailBuddy] Your subjects list is full. Please delete at least one entry!")
        MailBuddy.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
		d(MailBuddy.localizationVars.mb_loc["chat_output_subject_list_full"])
    end

	return
end













 

--The addon table/array
local MB = MailBuddy

local mbLocPrefix = MB.LocalizationPrefix

local WM = WINDOW_MANAGER

function MB.UpdateLabelTextAndTooltip(labelControl, labelText, tooltipText, ...)
    labelControl:SetText(string.format(labelText, ...))
    MB.UpdateEditFieldToolTip(labelControl, tooltipText ~= nil and tooltipText or labelText, labelText)
end

function MB.UpdateRecipientText(pageIndex, doDelete)
	if pageIndex == nil then return end
	doDelete = doDelete or false

    local page, pageEntry = MB.mapPageAndEntry(pageIndex, "recipient")
    if page ~= nil and pageEntry ~= nil then
		if MB.recipientPages.pages[page][pageEntry] ~= "" then
			local labelControl = WM:GetControlByName(MB.recipientPages.pages[page][pageEntry], "")
	        if labelControl ~= nil then
				--local currentName = labelControl:GetText()
                local currentName = MB.settingsVars.settings.SetRecipient[pageIndex]
                local currentNameAbbreviated = MB.settingsVars.settings.SetRecipientAbbreviated[pageIndex] or currentName
                if currentName ~= nil and currentName ~= "" then
				    if doDelete then
						labelControl:SetText("")
						MB.settingsVars.settings.SetRecipient[pageIndex] = ""
                        MB.settingsVars.settings.SetRecipientAbbreviated[pageIndex] = ""
						MB.PlaySoundNow(SOUNDS["MAIL_ITEM_DELETED"])
	                    if MB.editRecipient ~= nil then
		                    MB.editRecipient:TakeFocus()
	                    end
					else
                        if not MB.settingsVars.settings.useAlternativeLayout then
                            MB.UpdateLabelTextAndTooltip(MailBuddy_MailSendRecipientLabelActiveText, currentNameAbbreviated, currentName)
                        else
                            ZO_MailSendToField:SetText(string.format(currentName))
                        end
						MB.settingsVars.settings.curRecipient = currentName
                        MB.settingsVars.settings.curRecipientAbbreviated = currentNameAbbreviated
                        --Remember the last used recipient text
                        MB.settingsVars.settings.remember.recipient["text"] = currentName
                        MB.FocusNextField()
                        MB.PlaySoundNow(SOUNDS["QUEST_FOCUSED"])
                        MB.AutoCloseBox("recipients")
                    end
				end
	        end
	    end
    end
    --Revert to the original edit box clicked sound
    SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
end

function MB.UpdateSubjectText(pageIndex, doDelete, newText)
	if pageIndex == nil and (newText == nil or newText == "") then return end
    --Only update the MailBuddy label/ZOs mail subject field witht he given text here
	if pageIndex == nil and (newText ~= nil and newText ~= "") then
        if not MB.settingsVars.settings.useAlternativeLayout then
            MB.UpdateLabelTextAndTooltip(MailBuddy_MailSendSubjectLabelActiveText, newText, nil)
        else
            ZO_MailSendSubjectField:SetText(string.format(newText))
        end
        MB.settingsVars.settings.curSubject = newText
        MB.settingsVars.settings.curSubjectAbbreviated = newText
        --Remember the last used subject text
        MB.settingsVars.settings.remember.subject["text"]   = newText
        MB.FocusNextField()
        MB.PlaySoundNow(SOUNDS["QUEST_FOCUSED"])
        MB.AutoCloseBox("subjects")
        --Revert to the original edit box clicked sound
        SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
        return
    end
	doDelete = doDelete or false

    local page, pageEntry = MB.mapPageAndEntry(pageIndex, "subject")
    if page ~= nil and pageEntry ~= nil then
		if MB.subjectPages.pages[page][pageEntry] ~= "" then
			local labelControl = WM:GetControlByName(MB.subjectPages.pages[page][pageEntry], "")
	        if labelControl ~= nil then
				--local currentSubject = labelControl:GetText()
    			local currentSubject = MB.settingsVars.settings.SetSubject[pageIndex]
    			local currentSubjectAbbreviated = MB.settingsVars.settings.SetSubjectAbbreviated[pageIndex] or currentSubject
				if currentSubject ~= nil and currentSubject ~= "" then
				    if doDelete then
						labelControl:SetText("")
						MB.settingsVars.settings.SetSubject[pageIndex] = ""
						MB.settingsVars.settings.SetSubjectAbbreviated[pageIndex] = ""
						MB.PlaySoundNow(SOUNDS["MAIL_ITEM_DELETED"])
                        if MB.editSubject ~= nil then
	                        MB.editSubject:TakeFocus()
                        end
					else
                        if not MB.settingsVars.settings.useAlternativeLayout then
                            MailBuddy_MailSendSubjectLabelActiveText:SetText(string.format(currentSubjectAbbreviated))
                            MB.UpdateEditFieldToolTip(MailBuddy_MailSendSubjectLabelActiveText, currentSubject, currentSubjectAbbreviated)
                        else
                            ZO_MailSendSubjectField:SetText(string.format(currentSubject))
                        end
						MB.settingsVars.settings.curSubject = currentSubject
                        MB.settingsVars.settings.curSubjectAbbreviated = currentSubjectAbbreviated
                        --Remember the last used subject text
                        MB.settingsVars.settings.remember.subject["text"]   = currentSubject
                        MB.FocusNextField()
                        MB.PlaySoundNow(SOUNDS["QUEST_FOCUSED"])
                        MB.AutoCloseBox("subjects")
                    end
				end
	        end
	    end
    end
    --Revert to the original edit box clicked sound
    SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
end

function MB.StoreRecipient()
    --Check if the keybinding was pressed inside the guild roster or friends list, or if the mail send panel is open
    --and abort if not one of the panels is opened
    if 	  ZO_GuildRoster:IsHidden()
       and ZO_KeyboardFriendsList:IsHidden()
       and ZO_MailSend:IsHidden() then
    	return
    elseif not ZO_MailSend:IsHidden() and MB.keybindUsed then
    	return
    end

--d("StoreRecipients")
    --The new entered recipient text (sent by RETURN key)
	local enteredName = MailBuddy_MailSendRecipientsBoxEditNewRecipient:GetText()
	--Abort here if no name was given and just RETURN key was pressed
	if enteredName == "" or enteredName == MB.playerName or enteredName == MB.accountName then
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
    for i = 1, MB.recipientPages.totalEntries, 1 do
	    local page, pageEntry = MB.mapPageAndEntry(i, "recipient")
	    if page ~= nil and pageEntry ~= nil then
			local editControl = WM:GetControlByName(MB.recipientPages.pages[page][pageEntry], "")
			if editControl ~= nil then
--d("SetRecipients["..i.."] = MB.recipientPages.pages["..page.."]["..pageEntry.."]: " .. editControl:GetName())
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
	    local page, pageEntry = MB.mapPageAndEntry(idx, "recipient")
	    if page ~= nil and pageEntry ~= nil then
--d("Stored name: " .. nameText .. ", New name: " .. enteredName)
			--Compare the stored name with the new entered name
			if string.lower(nameText) == string.lower(enteredName) then
				--d("[MailBuddy] Recipient name is already in the list!")
                MB.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
                d(GetString(mbLocPrefix .."chat_output_recipient_already_in_list"))
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
        local newNameEditControl = WM:GetControlByName(MB.recipientPages.pages[newEntry.page][newEntry.pageEntry], "")
		MB.settingsVars.settings.SetRecipient[newEntry.index] = enteredName
        local shortendName
        if string.len(enteredName) > MB.maximumCharacters["recipients"] then
        	shortendName = string.sub(enteredName, 1, (MB.maximumCharacters["recipients"])) .. "..."
        else
        	shortendName = enteredName
        end
        MB.settingsVars.settings.SetRecipientAbbreviated[newEntry.index] = shortendName
    	newNameEditControl:SetText(string.format(shortendName))
		MB.editRecipient:Clear()
		MB.UpdateEditFieldToolTip(newNameEditControl, enteredName, shortendName)
        if MB.settingsVars.settings.useAlternativeLayout then
            if ZO_MailSendToField:GetText() == "" then
                ZO_MailSendToField:SetText(string.format(enteredName))
                --Remember the last used recipient text
                MB.settingsVars.settings.remember.recipient["text"] = enteredName
            end
        end
        MB.FocusNextField()
    	MB.PlaySoundNow(nil, ITEM_SOUND_CATEGORY_RING, ITEM_SOUND_ACTION_SLOT)
        MB.AutoCloseBox("recipients")
        return
    elseif not alreadyInList then
        --d("[MailBuddy] Your recipients list is full. Please delete at least one entry!")
        MB.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
        d(GetString(mbLocPrefix .."chat_output_recipient_list_full"))
    end
    --Revert to the original edit box clicked sound
    SOUNDS["EDIT_CLICK"] = SOUNDS["EDIT_CLICK_MAILBUDDY_BACKUP"]
	return
end

function MB.StoreSubject()
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
            MB.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
            d(GetString(mbLocPrefix .."chat_output_subject_already_in_fixed_list"))
            --Revert to the original edit box clicked sound
            return
        end
    end

	--Add the text of the already saved names to an arry for a later comparison etc.
	local SubjectLines = {}
    for i = 1, MB.subjectPages.totalEntries, 1 do
	    local page, pageEntry = MB.mapPageAndEntry(i, "subject")
	    if page ~= nil and pageEntry ~= nil then
--d("Page: " .. page .. ", pageEntry: " .. pageEntry)
			local editControl = WM:GetControlByName(MB.subjectPages.pages[page][pageEntry], "")
			if editControl ~= nil then
--d("SubjectLines["..i.."] = MB.subjectPages.pages["..page.."]["..pageEntry.."]: " .. editControl:GetName())
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
	    local page, pageEntry = MB.mapPageAndEntry(idx, "subject")
	    if page ~= nil and pageEntry ~= nil then
--d("Stored subject: " .. subjectText .. ", New subject: " .. enteredSubject)
			--Compare the stored subject with the new entered subject
			if string.lower(subjectText) == string.lower(enteredSubject) then
				--d("[MailBuddy] Subject is already in the list!")
                MB.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
            	d(GetString(mbLocPrefix .."chat_output_subject_already_in_list"))
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
        local newSubjectEditControl = WM:GetControlByName(MB.subjectPages.pages[newEntry.page][newEntry.pageEntry], "")
		MB.settingsVars.settings.SetSubject[newEntry.index] = enteredSubject
        local shortendSubject
        if string.len(enteredSubject) > MB.maximumCharacters["subjects"] then
			shortendSubject = string.sub(enteredSubject, 1, (MB.maximumCharacters["subjects"])) .. "..."
        else
        	shortendSubject = enteredSubject
        end
		MB.settingsVars.settings.SetSubjectAbbreviated[newEntry.index] = shortendSubject
    	newSubjectEditControl:SetText(string.format(shortendSubject))
		MB.UpdateEditFieldToolTip(newSubjectEditControl, enteredSubject, shortendSubject)
		MB.editRecipient:Clear()
        if MB.settingsVars.settings.useAlternativeLayout then
            if ZO_MailSendSubjectField:GetText() == "" then
                ZO_MailSendSubjectField:SetText(string.format(enteredSubject))
                --Remember the last used subject text
                MB.settingsVars.settings.remember.subject["text"]   = enteredSubject
            end
        end
        MB.FocusNextField()
    	MB.PlaySoundNow(nil, ITEM_SOUND_CATEGORY_RING, ITEM_SOUND_ACTION_SLOT)
        MB.AutoCloseBox("subjects")
        return
    elseif not alreadyInList then
        --d("[MailBuddy] Your subjects list is full. Please delete at least one entry!")
        MB.PlaySoundNow(SOUNDS["GENERAL_ALERT_ERROR"])
		d(GetString(mbLocPrefix .."chat_output_subject_list_full"))
    end

	return
end













 

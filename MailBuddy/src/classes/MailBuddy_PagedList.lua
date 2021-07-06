--======================================================================================================================
--MailBuddy - PagedList control (copy of ZO_PagedList which only seems to be a gamepad control)
MailBuddyPagedList = ZO_SortFilterList:Subclass() --original ZO_PagedList uses ZO_SortFilterListBase but then we'd be msising the functions like GetSelectedData

local SEARCH_TYPE_BY_NAME = 1

function MailBuddyPagedList:New(control, dataType)
	local list = ZO_SortFilterList.New(self, control)
	self:Initialize(control, dataType)
	return list
end

function MailBuddyPagedList:Initialize(control, dataType)
    ZO_SortFilterListBase.Initialize(self, control)

    self.control = control
    self.list = control:GetNamedChild("List")

    self.selectionChangedCallback = nil
    local selectionChangeCallback = function(control)
        if self.selectionChangedCallback then
            local data = nil
            if control then
                data = control.data.data
            end
            self.selectionChangedCallback(data)
        end
    end
    -- self.focus:SetFocusChangedCallback(selectionChangeCallback)

    self.dataType = dataType
    self.searchType = SEARCH_TYPE_BY_NAME

    self.dataTypes = {}
    self.masterList = {}

    self.pages = {}
    self.currPageNum = 1
    self.numPages = 0
    self.rememberSpot = false


    local headerContainer = control:GetNamedChild("Headers")
    if(headerContainer) then
        self.headerContainer = headerContainer
        local showArrows = false
        self.sortHeaderGroup = ZO_SortHeaderGroup:New(headerContainer, showArrows)
        --self.sortHeaderGroup:SetColors(ZO_SELECTED_TEXT, ZO_NORMAL_TEXT, ZO_SELECTED_TEXT, ZO_DISABLED_TEXT)
        self.sortHeaderGroup:RegisterCallback(ZO_SortHeaderGroup.HEADER_CLICKED, function(key, order) self:OnSortHeaderClicked(key, order) end)
        self.sortHeaderGroup:AddHeadersFromContainer() --loads the header columns from the control in the order of the <controls> of the XML virtual template. hidden="true" will NOT be added!
    end

    local footerControl = control:GetNamedChild("Footer")
    if(footerControl) then
        self.footer = {
            control = footerControl,
            previousButton = footerControl:GetNamedChild("PreviousButton"),
            nextButton = footerControl:GetNamedChild("NextButton"),
            pageNumberLabel = footerControl:GetNamedChild("PageNumberText"),
        }
    end

    --Search box and search functions
    self.searchBox = control:GetNamedChild("SearchBox")
    if self.searchBox then
        self.searchBox:SetHandler("OnTextChanged", function() self:RefreshFilters() end)
        self.searchBox:SetHandler("OnMouseUp", function(ctrl, mouseButton, upInside)
            if mouseButton == MOUSE_BUTTON_INDEX_RIGHT and upInside then
                self:OnSearchEditBoxContextMenu(self.searchBox)
            end
        end)
        self.search = ZO_StringSearch:New()
        self.search:AddProcessor(self.dataType, function(stringSearch, data, searchTerm, cache)
            return(self:ProcessItemEntry(stringSearch, data, searchTerm, cache))
        end)
    end

    self.onEnterRow = function(control, data)
        self:OnEnterRow(control, data.data)
    end

    self.onLeaveRow = function(control, data)
        self:OnLeaveRow(control, data.data)
    end

    self.onPlaySoundFunction = ZO_PagedListPlaySound

    local hideKeybind = footerControl ~= nil

    self.pagedListKeybindStripDescriptor =
    {
        alignment = KEYBIND_STRIP_ALIGN_LEFT,
        -- Previous
        {
            --Ethereal binds show no text, the name field is used to help identify the keybind when debugging. This text does not have to be localized.
            name = "Paged List Previous Page",
            keybind = "UI_SHORTCUT_SECONDARY",
            order = 100,
            callback = function()
                self:PreviousPage()
            end,

            ethereal = hideKeybind,
        },

        -- Next
        {
            --Ethereal binds show no text, the name field is used to help identify the keybind when debugging. This text does not have to be localized.
            name = "Paged List Next Page",
            keybind = "UI_SHORTCUT_TERTIARY",
            order = 100,
            callback = function()
                self:NextPage()
            end,

            ethereal = hideKeybind,
        },
    }
end

-- ZO_SortFilterList:RefreshData()      =>  BuildMasterList()   =>  FilterList()  =>  SortList()    =>  CommitList()
-- ZO_SortFilterList:RefreshFilters()                           =>  FilterList()  =>  SortList()    =>  CommitList()
-- ZO_SortFilterList:RefreshSort()                                                =>  SortList()    =>  CommitList()

function MailBuddyPagedList:RefreshData()
    d("[class MailBuddyPagedList:RefreshData]")
    self:BuildMasterList()
    self:FilterList()
    self:SortList()
    self:CommitList()
end

function MailBuddyPagedList:RefreshFilters()
    d("[class MailBuddyPagedList:RefreshFilters]")
    self:FilterList()
    self:SortList()
    self:CommitList()
end

function MailBuddyPagedList:RefreshSort()
    d("[class MailBuddyPagedList:RefreshSort]")
    self:SortList()
    self:CommitList()
end

function MailBuddyPagedList:RefreshVisible()
    d("[class MailBuddyPagedList:RefreshVisible]")
    local page = self.pages[self.currPageNum]
    if page == nil then
        return
    end
    local lastIndex = (page.startIndex + page.count - 1)
    local previousControl
    for i = page.startIndex, lastIndex do
        local data = self.masterList[i]
        local control = data.control
        local selected = self:IsSelected(data.data)
        self.dataTypes[control.templateName].setupCallback(control, data.data, selected)
    end

    self:OnListChanged()
end

function MailBuddyPagedList:BuildMasterList()
    d("[class MailBuddyPagedList:BuildMasterList]")
    -- intended to be overriden
    -- should populate the dataList by calling AddEntry

end

function MailBuddyPagedList:FilterList()
    d("[class MailBuddyPagedList:FilterList]")
    -- intended to be overriden
    -- should take the dataList and filter it

    --Get the search method chosen at the search dropdown
    --self.searchType = self.searchDrop:GetSelectedItemData().id
    self.searchType = SEARCH_TYPE_BY_NAME
    if self.searchBox then
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        ZO_ClearNumericallyIndexedTable(scrollData)

        --Check the search text
        local searchInput = self.searchBox:GetText()

        --Rebuild the masterlist so the total list and counts are correct!
        for i = 1, #self.masterList do
            --Get the data of each set item
            local data = self.masterList[i]
            --Search for text/set bonuses
            if searchInput == "" or self:CheckForMatch(data, searchInput) then
                table.insert(scrollData, ZO_ScrollList_CreateDataEntry(self.dataType, data))
            end
        end

    end
end

function MailBuddyPagedList:SortList()
    -- can optionally be overriden
    -- should take the dataList and sort it

    --Called by self.sortHeaderGroup:SelectAndResetSortForKey
    d("[class MailBuddyPagedList:SortList]")

    --Build the sortkeys depending on the settings
    --[[
    self:BuildSortKeys()
    --Get the current sort header's key and direction
    self.currentSortKey = self.sortHeaderGroup:GetCurrentSortKey()
    self.currentSortOrder = self.sortHeaderGroup:GetSortDirection()
	if (self.currentSortKey ~= nil and self.currentSortOrder ~= nil) then
        --Update the scroll list and re-sort it -> Calls "SetupItemRow" internally!
		local scrollData = ZO_ScrollList_GetDataList(self.list)
        if scrollData and #scrollData > 0 then
            table.sort(scrollData, self.sortFunction)
            self:RefreshVisible()
        end
	end
	]]

    -- The default implemenation will sort according to the sort keys specified in the SetupSort function
    if self.sortKeys then
        table.sort(self.masterList, function(listEntry1, listEntry2) return self:CompareSortEntries(listEntry1, listEntry2) end)
    end
end

function MailBuddyPagedList:CommitList()
    d("[class MailBuddyPagedList:CommitList]")
    self:BuildPages()
    self:BuildPage(self.currPageNum)
    self:RefreshFooter()
    self:OnListChanged()
end

function MailBuddyPagedList:CheckForMatch( data, searchInput )
    local searchType = self.searchType
    if searchType ~= nil then
        --Search by name
        if searchType == SEARCH_TYPE_BY_NAME then
            local isMatch = false
            local searchInputNumber = tonumber(searchInput)
            if searchInputNumber ~= nil then
                local searchValueType = type(searchInputNumber)
                if searchValueType == "number" then
                    isMatch = searchInputNumber == data.setId or false
                end
            else
                isMatch = self.search:IsMatch(searchInput, data)
            end
            return isMatch
        end
    end
	return(false)
end

function MailBuddyPagedList:ProcessItemEntry( stringSearch, data, searchTerm )
	if ( zo_plainstrfind(data.name:lower(), searchTerm) ) then
		return(true)
	end
	return(false)
end

function MailBuddyPagedList:OnSearchEditBoxContextMenu(searchEditboxControl)
    -- intended to be overriden
    -- allows a search editbox context menu to show (ZO_Menu, or LibCustomMenu)
end

function MailBuddyPagedList:OnListChanged()
    -- intended to be overriden
    -- allows a subclass to react when list contents change
end

function MailBuddyPagedList:OnPageChanged()
    -- intended to be overriden
    -- allows a subclass to react when list page changes
end

function MailBuddyPagedList:TakeFocus()
    --self.focus:Activate()
end

function MailBuddyPagedList:ClearFocus()
    --self.focus:Deactivate()
end

function MailBuddyPagedList:Activate()
    --self:TakeFocus()
    KEYBIND_STRIP:AddKeybindButtonGroup(self.pagedListKeybindStripDescriptor)
end

function MailBuddyPagedList:Deactivate(retainFocus)
    KEYBIND_STRIP:RemoveKeybindButtonGroup(self.pagedListKeybindStripDescriptor)
    --self.focus:Deactivate(retainFocus)
end

function MailBuddyPagedList:ActivateHeader()
    if self.sortHeaderGroup then
        self.sortHeaderGroup:SetDirectionalInputEnabled(true)
        self.sortHeaderGroup:EnableSelection(true)
    end
end

function MailBuddyPagedList:DeactivateHeader()
    if self.sortHeaderGroup then
        self.sortHeaderGroup:SetDirectionalInputEnabled(false)
        self.sortHeaderGroup:EnableSelection(false)
    end
end

function MailBuddyPagedList:SetSortHeaderTooltip(sortHeaderColumn, tooltipText, point, offsetX, offsetY)
    sortHeaderColumn.sortHeaderGroup = self.sortHeaderGroup
    if not tooltipText then return end
    ZO_SortHeader_SetTooltip(sortHeaderColumn, tooltipText, point or TOP, offsetX or 0, offsetY or 0)
end

function MailBuddyPagedList:SetupSort(sortKeys, initialKey, initialDirection)
    self.sortKeys = sortKeys
    self.currentSortKey = initialKey
    self.currentSortOrder = initialDirection
end

function MailBuddyPagedList:BuildSortKeys()
    d("[class MailBuddyPagedList:BuildSortKeys]")
    --Get the tiebraker for the 2nd sort after the selected column
    self.sortKeys = self.defaultSortKeys or {
        --["timestamp"]               = { isId64          = true, tiebreaker = "name"  }, --isNumeric = true
        --["knownInSetItemCollectionBook"] = { caseInsensitive = true, isNumeric = true, tiebreaker = "name" },
        ["name"]                    = { caseInsensitive = true },
        --["armorOrWeaponTypeName"]   = { caseInsensitive = true, tiebreaker = "name" },
        --["slotName"]                = { caseInsensitive = true, tiebreaker = "name" },
        --["traitName"]               = { caseInsensitive = true, tiebreaker = "name" },
        --["quality"]                 = { caseInsensitive = true, tiebreaker = "name" },
        --["username"]                = { caseInsensitive = true, tiebreaker = "name" },
        --["locality"]                = { caseInsensitive = true, tiebreaker = "name" },
    }
end

function MailBuddyPagedList:SetSelectionChangedCallback(callback)
    self.selectionChangedCallback = callback
end

function MailBuddyPagedList:SetLeaveListAtBeginningCallback(callback)
   -- self.focus:SetLeaveFocusAtBeginningCallback(callback)
end

function MailBuddyPagedList:OnEnterRow(control, data)
    self:Row_OnMouseEnter(control)
end

function MailBuddyPagedList:OnLeaveRow(control, data)
    self:Row_OnMouseExit(control)
end

--AddDataTemplate("ZO_GamepadItemEntryTemplate", ZO_SharedGamepadEntry_OnSetup, ZO_GamepadMenuEntryTemplateParametricListFunction)
function MailBuddyPagedList:AddDataTemplate(templateName, height, setupCallback, controlPoolPrefix)
    if not self.dataTypes[templateName] then
        local dataTypeInfo = {
            pool = ZO_ControlPool:New(templateName, self.list, controlPoolPrefix or templateName),
            height = height,
            setupCallback = setupCallback
        }
        self.dataTypes[templateName] = dataTypeInfo
    end
end

function MailBuddyPagedList:AddEntry(templateName, data)
     if self.dataTypes[templateName] then

        local entry =
        {
            templateName = templateName,
            data = data
        }

        self.masterList[#self.masterList + 1] = entry
    end
end

function MailBuddyPagedList:Clear()
    self.masterList = {}
    for templateName, dataTypeInfo in pairs(self.dataTypes) do
        dataTypeInfo.pool:ReleaseAllObjects()
    end
end

function MailBuddyPagedList:IsSelected(data)
    --[[
    local focusItem = self.focus:GetFocusItem()
    if focusItem then
        return focusItem.data.data == data
    end
    return false
    ]]
end

function MailBuddyPagedList:SetPage(pageNum)
    local newPageNum = zo_clamp(pageNum, 1, self.numPages)
    if newPageNum ~= self.currPageNum then
        if newPageNum > self.currPageNum then
            self.onPlaySoundFunction(ZO_PAGEDLIST_MOVEMENT_TYPES.PAGE_FORWARD)
        else
            self.onPlaySoundFunction(ZO_PAGEDLIST_MOVEMENT_TYPES.PAGE_BACK)
        end
        self.currPageNum = newPageNum
        self:BuildPage(self.currPageNum)
        self:RefreshFooter()
        self:OnListChanged()
    end
end

function MailBuddyPagedList:PreviousPage()
    self:SetPage(self.currPageNum - 1)
end

function MailBuddyPagedList:NextPage()
    self:SetPage(self.currPageNum + 1)
end

function MailBuddyPagedList:AcquireControl(dataIndex, relativeControl)
    local PADDING = 0

    local templateName = self.masterList[dataIndex].templateName
    local control, key = self.dataTypes[templateName].pool:AcquireObject()

    if relativeControl then
        control:SetAnchor(TOPLEFT, relativeControl, BOTTOMLEFT, 0, PADDING)
    else
        control:SetAnchor(TOPLEFT, self.list, TOPLEFT, 0, PADDING)
    end

    control.key = key
    control.templateName = templateName
    control.dataIndex = dataIndex

    return control, true
end

function MailBuddyPagedList:ReleaseControl(control)
    local templateName = control.templateName
    local pool = self.dataTypes[templateName].pool
    pool:ReleaseObject(control.key)
end

function MailBuddyPagedList:BuildPages()
    self.pages = {}

    local currPageHeight = 0
    local currPageNum = 1

    local pageWidth, pageHeight = self.list:GetDimensions()


    self.pages[currPageNum] = {startIndex = 1, count = 0}

    for i,data in ipairs(self.masterList) do
        local templateName = data.templateName

        local height = self.dataTypes[templateName].height
        if (currPageHeight + height) > pageHeight then
            currPageHeight = 0
            currPageNum = currPageNum + 1
            self.pages[currPageNum] = {startIndex = i, count = 0}
        end

        currPageHeight = currPageHeight + height
        self.pages[currPageNum].count = self.pages[currPageNum].count + 1
    end

    if(self.emptyRow) then
        self.emptyRow:SetHidden(#self.masterList > 0)
    end

    self.numPages = currPageNum

    if self.rememberSpot then
        self.currPageNum = zo_min(self.currPageNum, currPageNum)
    else
        self.currPageNum = 1
    end
end

function MailBuddyPagedList:GetDataList()
    return ZO_ScrollList_GetDataList(self.list)
end

function MailBuddyPagedList:GetItemCount()
    return #self:GetDataList()
end

local INCLUDE_SAVED_INDEX = true
function MailBuddyPagedList:BuildPage(pageNum)
    local savedIndex = 1
    self:Clear()

    local page = self.pages[pageNum]

    local lastIndex = (page.startIndex + page.count - 1)
    local previousControl
    for i = page.startIndex, lastIndex do

        local data = self.masterList[i]
        local control = self:AcquireControl(i, previousControl)
        data.control = control
        local selected = self:IsSelected(data.data)
        self.dataTypes[control.templateName].setupCallback(control, data.data, selected)
        local entry = {
            control = control,
            highlight = control:GetNamedChild("Highlight"),
            data = data,
            activate = self.onEnterRow,
            deactivate = self.onLeaveRow,
        }
        --self.focus:AddEntry(entry)
        self:AddEntry(entry)

        previousControl = control

        if(self.alternateRowBackgrounds) then
            local rowBackground = GetControl(control, "BG")
            if(rowBackground) then
                local hidden = (i % 2) == 0
                rowBackground:SetHidden(hidden)
            end
        end
    end

    --[[
    if self.rememberSpot then
        local itemsOnPage = self:GetItemCount()
        if savedIndex then
            savedIndex = zo_min(savedIndex, itemsOnPage)
        end

        --self.focus:SetFocusByIndex(savedIndex or 1)
    else
        --self.focus:SetFocusByIndex(1)
    end
    ]]
end

function MailBuddyPagedList:OnSortHeaderClicked(key, order)
    self.currentSortKey = key
    self.currentSortOrder = order
    self:RefreshSort()
end

function MailBuddyPagedList:CompareSortEntries(listEntry1, listEntry2)
    return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, self.sortKeys, self.currentSortOrder)
end

function MailBuddyPagedList:RefreshFooter()
    if not self.footer then return end

    local enablePrevious = self.currPageNum > 1
    self.footer.previousButton:SetEnabled(enablePrevious)

    local enableNext = self.currPageNum < #self.pages
    self.footer.nextButton:SetEnabled(enableNext)

    local pageNumberText = zo_strformat(SI_GAMEPAD_PAGED_LIST_PAGE_NUMBER, self.currPageNum)
    self.footer.pageNumberLabel:SetText(pageNumberText)

    self.footer.control:SetHidden(#self.pages <= 1)
end

function MailBuddyPagedList:SetAlternateRowBackgrounds(alternate)
    self.alternateRowBackgrounds = alternate
end

function MailBuddyPagedList:SetPlaySoundFunction(fn)
    self.onPlaySoundFunction = fn
end

--[[
function MailBuddyPagedList:SetRememberSpotInList(rememberSpot)
    self.rememberSpot = rememberSpot
end
]]

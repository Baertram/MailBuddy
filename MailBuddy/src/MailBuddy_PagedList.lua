--The addon table/array
local MB = MailBuddy

--local mbLocPrefix = MB.LocalizationPrefix

local WM = WINDOW_MANAGER

--The possible ZO_SortFilterLists
MB.PagedLists = {}

--The class for the paged list
MB.PagedListClass = MailBuddyPagedList:Subclass()
local pagedListClasss = MB.PagedListClass

--======================================================================================================================
--======================================================================================================================
--======================================================================================================================
--Recipients
MB.PagedLists.recipients = pagedListClasss:New(MailBuddyRecipientsFrame, MB.SCROLLLIST_DATATYPE_RECIPIENTS)
local recipients = MB.PagedLists.recipients

function MB.InitializeRecipientsList()
    local listControl = recipients.list
    recipients:CreateScrollListDataType(listControl)
    recipients:RefreshData()
	recipients:SetupSortHeaders()
end

function recipients:SetupRowFunction(rowControl, data, scrollList)
d("recipients:SetupRowFunction - name: " ..tostring(data.name))
    rowControl.data = data
    rowControl.name = GetControl(rowControl, "Name")
    rowControl.name:SetText(data.name)
    rowControl.name:SetHidden(false)
end

-- create datatype for scrollist
function recipients:CreateScrollListDataType(control)
    local typeId = self.dataType
    local templateName = "MailBuddyRecipientRow"
    local height = 30
    local setupFunction = function(...) self:SetupRowFunction(...) end
    local hideCallback = nil
    local dataTypeSelectSound = nil
    local resetControlCallback = nil
    --local selectTemplate = "ZO_ThinListHighlight"
    --local selectCallback = function(...) self:OnSelectCallback(...) end

    ZO_ScrollList_AddDataType(control, typeId, templateName, height, setupFunction, hideCallback, dataTypeSelectSound, resetControlCallback)
    --ZO_ScrollList_EnableSelection(control, selectTemplate, selectCallback)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
    self:SetAlternateRowBackgrounds(true)

    local footerControl = self.control:GetNamedChild("Footer")
    footerControl:SetHidden(false)
end

function recipients:BuildMasterList()
    self.masterList = {}
    local recis = MB.settingsVars.settings.SetRecipient
    for _, recipientName in ipairs(recis) do
        table.insert(self.masterList, {
            type = self.searchType,
            name = recipientName,
        })
    end
end

function recipients:SetupSortHeaders()
    self.currentSortKey = "name"
    self.currentSortOrder = ZO_SORT_ORDER_UP
    self.defaultSortKeys =  {
        ["name"]                    = { caseInsensitive = true },
    }
    self:SetupSort(self.defaultSortKeys, "name", ZO_SORT_ORDER_UP)

    local headerContainer = self.sortHeaderGroup.headerContainer
    pagedListClasss.SetSortHeaderTooltip(self, headerContainer:GetNamedChild("Name"), "Name", TOP, 0, -5)

    self.sortHeaderGroup:SelectAndResetSortForKey(self.currentSortKey)
    -- Will call ZO_SortHeaderGroup:SelectHeaderByKey -> OnHeaderClicked -> FireCallbacks(self.HEADER_CLICKED, ...) -> ZO_SortFilterList:InitializeSortFilterList ->
    --Callback of HEADER_CLICKED -> self:OnSortHeaderClicked(key, order) -> self:RefreshSort() -> self:SortList() (-> Custom: self:BuildSortKeys()) -> self:CommitScrollList()
end

--[[
-- sorts the listdata, saves the data and commits the data to the scrollinglist
function recipients:UpdateScrollList(listControl, rowType)
    local dataCopy = ZO_DeepTableCopy(self.masterList)
    local dataList = ZO_ScrollList_GetDataList(listControl)

    ZO_ScrollList_Clear(listControl)

    for key, value in ipairs(dataCopy) do
        local entry = ZO_ScrollList_CreateDataEntry(rowType, value)
        table.insert(dataList, entry)
    end

    table.sort(dataList, function(a,b) return a.name < b.name end)

    ZO_ScrollList_Commit(listControl)
end
]]

--======================================================================================================================
--======================================================================================================================
--======================================================================================================================
--Subjects
--[[
MB.PagedLists.subjects = pagedListClasss:New(MailBuddySubjectsFrame, MB.SCROLLLIST_DATATYPE_SUBJECTS)
local subjects = MB.PagedLists.subjects

function MB.InitializeSubjectsList()
    local listControl = subjects.list
    subjects:CreateScrollListDataType(listControl)
    local listEntries = subjects:Populate()
    subjects:UpdateScrollList(listControl, listEntries, MB.SCROLLLIST_DATATYPE_SUBJECTS)
end
]]

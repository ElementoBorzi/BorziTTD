
local BorziTTD = LibStub("AceAddon-3.0"):GetAddon("BorziTTD")

local options, configOptions = nil, {}
--[[ This options table is used in the GUI config. ]]-- 
local function getOptions() 
	if not options then
		options = {
		    type = "group",
			name ="BorziTTD",			
		    args = {
				general = {
					order = 1,
					type = "group",
					name = "General",
					args = {
						settings = {
							order = 1,
							type = "group",
							inline = true,
							name = "Settings",
							get = function(info)
								local key = info.arg or info[#info]
								return BorziTTD.db.profile.settings[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								BorziTTD.db.profile.settings[key] = value
							end,
							args = {
								enabledesc = {
									order = 1,
									type = "description",
									fontSize = "medium",
									name = "Enable/Disable BorziTTD"
								},
								enable = {
									order = 2,
									type = "toggle",
									name = "Enable"
						        },
								text = {
									order = 4,
									type = "input",
									name = "Text before TTD: "
						        },
								refresh = {
									order = 4,
									type = "input",
									name = "Time to refresh: "
						        },
							}
						},
						position = {
							order = 5,
							type = "group",
							inline = true,
							name = "Current Position:",
							get = function(info)
								local key = info.arg or info[#info]
								return BorziTTD.db.profile.position[key]
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								BorziTTD.db.profile.position[key] = value
							end,
							args = {
								arg1 = {
									order = 1,
									type = "input",
									name = "Centralized 1"
								},
								arg2 = {
									order = 2,
									type = "input",
									name = "Centralized 2"
								},
								arg3 = {
									order = 3,
									type = "input",
									name = "X"						
								},								
								arg4 = {
									order = 4,
									type = "input",
									name = "Y",					
								},													
							}
						}
					}
				}
		    }
		}
		for k,v in pairs(configOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end
	
	return options
end

local function openConfig() 
	InterfaceOptionsFrame_OpenToCategory(BorziTTD.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(BorziTTD.optionsFrames.BorziTTD)
	InterfaceOptionsFrame:Raise()
end

function BorziTTD:SetupOptions()
	self.optionsFrames = {}

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BorziTTD", getOptions)
	self.optionsFrames.BorziTTD = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BorziTTD", nil, nil, "general")

	configOptions["Profiles"] = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	self.optionsFrames["Profiles"] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BorziTTD", "Profiles", "BorziTTD", "Profiles")

	LibStub("AceConsole-3.0"):RegisterChatCommand("BorziTTD", openConfig)
end

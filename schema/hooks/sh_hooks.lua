function SCHEMA:PluginShouldLoad(uniqueID)
	return !table.HasValue(self.disabledPlugins, uniqueID)
end
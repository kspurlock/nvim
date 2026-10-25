local TypeIcons = require("nvim-tree.api").Decorator:extend()

function TypeIcons:new()
	self.enabled = true
	self.highlight_range = "none"
	self.icon_placement = "before"
end

function TypeIcons:icons(node)
	local icon, highlight
	if node.nodes then
		if node.type == "link" then
			icon = ""
		else
			icon = node.open and "" or ""
		end
		highlight = "NvimTreeFolderIcon"
	elseif node.type == "link" then
		icon, highlight = "", "NvimTreeSymlinkIcon"
	else
		icon, highlight = require("nvim-web-devicons").get_icon(
			node.name, node.extension or node.name:match("%.([^.]*)$"), { default = true }
		)
	end
	return { { str = icon or "", hl = { highlight or "NvimTreeFileIcon" } } }
end

return TypeIcons

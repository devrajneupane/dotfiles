local M = {}

-- Lua does not have a length function for tables...
function M.length(table)
	local count = 0
	for _, _ in ipairs(table) do
		count = count + 1
	end
	return count
end

function M.quote()
	local https = require("ssl.https")
	local response, status = https.request("https://api.quotable.io/random?tags=technology,famous-quotes&maxLength=500")

	if status == 200 then
		local start_index, end_index = string.find(response, '{".*}')
		if start_index and end_index then
			local quote = string.sub(response, start_index, end_index)
			local data = vim.json.decode(quote)
			return data.content, data.author
		else
			return "Failed to fetch quote."
		end
	else
		return "Failed to fetch quote."
	end
end

return M

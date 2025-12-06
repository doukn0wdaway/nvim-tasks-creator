local M = {}

local function generate_huid()
	local utc_time = os.date("!*t")
	local huid = string.format(
		"%04d%02d%02d-%02d%02d%02d",
		utc_time.year,
		utc_time.month,
		utc_time.day,
		utc_time.hour,
		utc_time.min,
		utc_time.sec
	)
	return huid
end

-- TODO:(20251206-063023) make it better
function M.create_task()
	local line = vim.api.nvim_get_current_line()

	local todo_text = line:match("TODO:%s*(.+)")
	if not todo_text then
		print("No TODO found in current line")
		return
	end

	local huid = generate_huid()

	local new_line = line:gsub("TODO:%s*(.+)", "TODO:(" .. huid .. ") %1")
	vim.api.nvim_set_current_line(new_line)

	local task_dir = "./tasks/" .. huid
	vim.fn.mkdir(task_dir, "p")

	local file_path = task_dir .. "/task.md"
	local file = io.open(file_path, "w")
	file:write(todo_text)
	file:close()

	print("Task created with ID:", huid)
end

return M

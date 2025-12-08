local M = {}

local opts = {
	folder_name = "_tasks",
}

function M.setup(user_opts)
	if user_opts then
		for k, v in pairs(user_opts) do
			opts[k] = v
		end
	end
end

local function get_git_root()
	local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
	if handle then
		local git_root = handle:read("*a"):gsub("%s+", "")
		handle:close()
		if git_root ~= "" then
			return git_root
		end
	end
	return nil
end

local function get_tasks_dir()
	local git_root = get_git_root()
	if not git_root then
		vim.notify("Cannot determine git root! " .. opts.folder_name .. " directory unavailable.", vim.log.levels.ERROR)
		return nil
	end

	local path = vim.fn.expand("%:p")
	while path ~= "" do
		local candidate = path .. "/" .. opts.folder_name .. "/"
		if vim.fn.isdirectory(candidate) == 1 then
			return candidate
		end
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == path then
			break
		end
		path = parent
	end

	local tasks_dir = git_root .. "/" .. opts.folder_name .. "/"
	vim.fn.mkdir(tasks_dir, "p")
	return tasks_dir
end

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
-- TODO:(20251207-122640) goto task function (in both ways, to file and to code line by huid)

function M.create_task()
	print(get_tasks_dir())
	local line = vim.api.nvim_get_current_line()

	local todo_text = line:match("TODO:%s*(.+)")
	if not todo_text then
		print("No TODO found in current line.")
		return
	end

	local huid = generate_huid()

	local new_line = line:gsub("TODO:%s*(.+)", "TODO:(" .. huid .. ") %1")
	vim.api.nvim_set_current_line(new_line)

	local task_dir = get_tasks_dir() .. huid .. "/"
	vim.fn.mkdir(task_dir, "p")

	local file_path = task_dir .. "task.md"
	local file = io.open(file_path, "w")
	if file ~= nil then
		file:write(todo_text) -- TODO:(20251207-122250) add template here?
		file:close()
	else
		vim.notify("Failed to open a file", vim.log.levels.WARN)
	end

	vim.cmd("edit " .. file_path)
end

return M

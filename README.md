I had same idea but wasn't able to think it through well enough.
In the end the solution turned out to be quite simple - thanks to [Zozin](https://github.com/tsoding)

I just decided to port it to Neovim.

Inspired by:
[Snitch](https://github.com/tsoding/snitch)
[Tsoding VOD](https://youtu.be/QH6KOEVnSZA?si=kp_xxzY19e9Q2IVY)

---

## Installation

### lazy installation

```lua
{
  "doukn0wdaway/nvim-tasks-creator", config = function()
    vim.api.nvim_create_user_command("CreateTodoTask", function()
      require("nvim-tasks-creator").create_task()
    end, { desc = "Create a TODO task" })
  end
}

```

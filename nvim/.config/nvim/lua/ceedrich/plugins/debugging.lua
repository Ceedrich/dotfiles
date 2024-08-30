return {
	{
		"rcarriga/nvim-dap-ui",
		tag = "v4.0.0",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			dapui.setup()

			local map = vim.keymap

			map.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debugger: toggle breakpoint" })
			map.set("n", "<Leader>dl", dap.step_over, { desc = "Debugger: step over" })
			map.set("n", "<Leader>dj", dap.step_into, { desc = "Debugger: step into" })
			map.set("n", "<Leader>dk", dap.step_out, { desc = "Debugger: step out" })
			map.set("n", "<Leader>dc", dap.continue, { desc = "Debugger: continue" })

			map.set("n", "<Leader>dr", function()
				dapui.open({ reset = true })
			end, { desc = "Debugger: reset UI" })
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		setup = function()
			require("nvim-dap-virtual-text").setup({})
		end,
	},
}

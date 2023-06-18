return {
	"williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	opts = {
        max_concurrent_installers = 10,
		pip = {
			upgrade_pip = true,
		},
		ui = {
            width = 0.8,
            height = 0.8,
			border = "rounded",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)
		local packages = require("utils").mason_packages
		local mr = require("mason-registry")
		for _, package in ipairs(packages) do
			local p = mr.get_package(package)
			if not p:is_installed() then
				p:install()
			end
		end
	end,
}

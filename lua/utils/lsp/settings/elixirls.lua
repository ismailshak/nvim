return {
	settings = {
		elixirLS = {
			-- Unless I know how to use it in the future, this takes an insane
			-- amount of time to build (15+ mins) and maxes CPU usage
			dialyzerEnabled = false,
			-- I also choose to turn off the auto dep fetching feature.
			-- It often gets into a weird state that requires deleting
			-- the .elixir_ls directory and restarting your editor.
			fetchDeps = false,
		},
	},
}

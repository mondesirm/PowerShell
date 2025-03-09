New-Module -Name Posh -ScriptBlock {
	function Get-PoshThemeList { (Get-ChildItem $env:POSH_THEMES_PATH\*.omp.json).BaseName -replace '\.omp$' }

	function Set-PoshTheme($theme, $shell = 'pwsh') {
		$themes = Get-PoshThemeList

		if (!$theme) {
			$theme = New-ListBox $themes 'Select a theme'
			if ($theme -and $psEditor) { $psEditor.Window.ShowInformationMessage("Posh theme set to: $theme") }
		}

		if ($themes -contains $theme) {
			oh-my-posh init $shell --config $env:POSH_THEMES_PATH\$theme.omp.json | Invoke-Expression
			# if ($theme -and $psEditor) { $psEditor.Window.ShowInformationMessage("Posh theme set to: $theme") }
		} else {
			Write-Host "Invalid theme name: $theme" -ForegroundColor Red
			Write-Host "Available themes: $($themes -join ', ')" -ForegroundColor Yellow
		}
	}

	if ($psEditor) { Register-EditorCommand -Name 'Set-PoshTheme' -DisplayName 'Set Posh Theme' -ScriptBlock { Set-PoshTheme } -SuppressOutput }
}
New-Module -Name Spicetify -ScriptBlock {
	function Restore-Spicetify { spicetify restore }
	function Get-SpicetifyThemes { Get-ChildItem "$(spicetify -c | Split-Path)\Themes" -Directory | Where-Object { Test-Path "$($_.FullName)\color.ini" } | ForEach-Object { $_.PSChildName.ToLower() } }
	function Get-SpicetifyThemeSchemes($theme) { Get-ChildItem "$(spicetify -c | Split-Path)\Themes\$theme\color.ini" | Select-String -Pattern '^\[.*\]$' | ForEach-Object { $_.Line -replace '\[|\]' } }

	function Set-SpicetifyTheme($theme, $scheme) {
		$themes = Get-SpicetifyThemes

		if (!$theme) { $theme = New-ListBox $themes 'Select a theme' }

		if ($theme -eq (spicetify config current_theme)) {
			Write-Host 'Theme unchanged' -ForegroundColor Cyan
		} elseif ($themes -contains $theme) {
			spicetify config current_theme $theme
		} else {
			Write-Host 'Invalid theme name' -ForegroundColor Red
			Write-Host "Available themes: $($themes -join ', ')" -ForegroundColor Yellow
			return
		}

		$schemes = Get-SpicetifyThemeSchemes $theme

		if (!$scheme) { $scheme = New-ListBox $schemes 'Select a color scheme' "$(spicetify -c | Split-Path)\Themes\$theme" }

		if ($scheme -eq (spicetify config color_scheme)) {
			Write-Host 'Color scheme unchanged' -ForegroundColor Cyan
		} elseif ($schemes -contains $scheme) {
			spicetify config color_scheme $scheme
			if ($theme -and $psEditor) { $psEditor.Window.ShowInformationMessage("Spicetify theme and color scheme set to: $theme - $scheme") }
		} else {
			Write-Host 'Invalid color scheme name' -ForegroundColor Red
			Write-Host "Available color schemes for $theme`: $($schemes -join ', ')" -ForegroundColor Yellow
			return
		}

		spicetify apply
	}

	if ($psEditor) {
		$commands = 'Restore-Spicetify', 'Set-SpicetifyTheme'
		$commands | ForEach-Object { Register-EditorCommand -Name $_ -DisplayName $_ -ScriptBlock ([ScriptBlock]::Create($_)) -SuppressOutput }
	}
}
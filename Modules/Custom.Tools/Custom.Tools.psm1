New-Module -Name Custom.Tools -ScriptBlock {
	function Format-Slug($text) { ((($text | iconv -c -t ascii//TRANSLIT) -replace '[^\w\s-]' -creplace '([A-Z])', ' $1').Trim() -replace '\s+', '-' -replace '^-|-$').ToLower() }
	function Get-File($url, $files) { if (!$files) { curl -O $url } else { $files | ForEach-Object { curl -O "$url/$_" } } }
	function Get-Git($repo, $files) { Get-File "https://raw.githubusercontent.com/$repo" $files }

	function Import-Folder($name) {
		$path = Get-Item $PSScriptRoot | Select-Object -ExpandProperty Parent
		if (!$name) { Write-Host 'Folder name is required' -ForegroundColor Red }
		elseif (Test-Path "$path/$name") { Get-ChildItem "$path/$name" | ForEach-Object { Import-Module $_.FullName -Global } }
		else { Write-Host "Folder $name not found in: $path" -ForegroundColor Red }
	}

	function New-ListBox($items, $title = 'Select', $preview = '', $multiple = $false) {
		Add-Type -AssemblyName System.Windows.Forms
		Add-Type -AssemblyName System.Drawing

		if (!(Test-Path $preview)) { $preview = '' }

		$form = New-Object System.Windows.Forms.Form
		$form.Text = $title
		$form.Width = $preview ? 410 : 180
		$form.Height = 200
		$form.Topmost = $true
		$form.MaximizeBox = $false
		$form.MinimizeBox = $false
		$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
		$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

		$flowLayoutPanel = New-Object System.Windows.Forms.FlowLayoutPanel
		$flowLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
		$flowLayoutPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::LeftToRight
		$flowLayoutPanel.WrapContents = $false
		$form.Controls.Add($flowLayoutPanel)

		$listBox = New-Object System.Windows.Forms.ListBox
		$listBox.Width = 150
		$listBox.Height = 150
		if ($multiple) { $listBox.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended }
		[void] $listBox.Items.AddRange($items)
		$flowLayoutPanel.Controls.Add($listBox)

		if ($preview) {
			$pictureBox = New-Object System.Windows.Forms.PictureBox
			$pictureBox.Width = 225
			$pictureBox.Height = 150
			$pictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
			$flowLayoutPanel.Controls.Add($pictureBox)

			$listBox.Add_SelectedIndexChanged({
				if ($selectedItem = $listBox.SelectedItem) {
					'', 'images', 'screenshots' | ForEach-Object {
						$img = "$preview\$_\$selectedItem.png"
						if (Test-Path $img) {
							$pictureBox.Image = [System.Drawing.Image]::FromFile($img)
							return
						}
					}

					# $pictureBox.Image = [System.Drawing.Image]::FromFile("$preview\default.png") -or $null
				}
			})
		}

		$buttonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
		$buttonPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::LeftToRight
		$buttonPanel.AutoSize = $true
		$form.Controls.Add($buttonPanel)

		$okButton = New-Object System.Windows.Forms.Button
		$okButton.Text = 'OK'
		$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
		$buttonPanel.Controls.Add($okButton)
		$form.AcceptButton = $okButton

		$cancelButton = New-Object System.Windows.Forms.Button
		$cancelButton.Text = 'Cancel'
		$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
		$buttonPanel.Controls.Add($cancelButton)
		$form.CancelButton = $cancelButton

		return $form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK ? $listBox.SelectedItems : $null
	}
}
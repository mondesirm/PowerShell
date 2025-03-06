Register-ArgumentCompleter -CommandName Set-TimeZone -ParameterName Id -ScriptBlock {
	param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

	(Get-TimeZone -ListAvailable).Id | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { "'$_'" }
}

Register-ArgumentCompleter -CommandName Stop-Service -ParameterName Name -ScriptBlock {
	param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

	$services = Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.Name -like "$wordToComplete*" }

	$services | ForEach-Object {
		New-Object -Type System.Management.Automation.CompletionResult -ArgumentList @(
			$_.Name          # completionText
			$_.Name          # listItemText
			'ParameterValue' # resultType
			$_.Name          # toolTip
		)
	}
}

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)

	dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
		[System.Management.Automation.CompletionResult]::new(
			$_,               # completionText
			$_,               # listItemText
			'ParameterValue', # resultType
			$_                # toolTip
		)
	}
}
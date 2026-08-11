Add-Type -AssemblyName System.Speech

$engine = New-Object System.Speech.Recognition.SpeechRecognitionEngine
$choices = New-Object System.Speech.Recognition.Choices
$choices.Add("hey flixi")
$choices.Add("hey flexi")
$choices.Add("hey flixy")

$grammarBuilder = New-Object System.Speech.Recognition.GrammarBuilder
$grammarBuilder.Append($choices)
$grammar = New-Object System.Speech.Recognition.Grammar($grammarBuilder)

$engine.LoadGrammar($grammar)
$engine.SetInputToDefaultAudioDevice()

while ($true) {
    try {
        $res = $engine.Recognize([TimeSpan]::FromHours(1))
        if ($res -and $res.Text -match "hey flix|hey flex") {
            Invoke-RestMethod -Uri "http://127.0.0.1:18080/wake" -Method Post -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 3 # Debounce
        }
    } catch {
        Start-Sleep -Seconds 1
    }
}

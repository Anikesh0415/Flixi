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

Register-ObjectEvent -InputObject $engine -EventName "SpeechRecognized" -Action {
    $text = $Event.SourceEventArgs.Result.Text
    if ($text -match "hey flix|hey flex") {
        Invoke-RestMethod -Uri "http://127.0.0.1:18080/wake" -Method Post -ErrorAction SilentlyContinue
    }
}

$engine.RecognizeAsync([System.Speech.Recognition.RecognizeMode]::Multiple)

# Keep the script running forever
while ($true) {
    Start-Sleep -Seconds 1
}

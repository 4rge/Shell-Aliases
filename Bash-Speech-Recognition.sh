
## Make sure to first pip install SpeechRecognition

function spek() {
`python3 << EOF
import speech_recognition
with speech_recognition.Microphone() as source:  
    print(str(speech_recognition.Recognizer().recognize_google(speech_recognition.Recognizer().record(source, duration=5))).lower())
EOF`
}

alias sp='spek'

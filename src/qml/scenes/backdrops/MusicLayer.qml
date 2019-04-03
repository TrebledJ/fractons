import Felgo 3.0
import QtQuick 2.0

import "../../game/singles"
import "../../js/Math.js" as JMath

Scene {
	id: scene
	
	//	"logical size"
	width: 480
	height: 320
	
	property var playlist: [bgmGolliwogsCakewalk, bgmClairDeLune, bgmArabesque, bgmPrelude4, bgmWaltz15]
	property int index: 0
	signal next
	
	property alias sfxCorrectAnswer: sfxCorrectAnswer
	property alias sfxWrongAnswer: sfxWrongAnswer
	
	
	Component.onCompleted: {
		if (musicEnabled)
			bgmGolliwogsCakewalk.play();
	}
	
	//	-- Background Music --
	
	Connections {
		target: gameWindow
		
		onMusicEnabledChanged: {
			console.warn("Music Enabled Changed:", musicEnabled);
			if (musicEnabled) playlist[index].play()
			else			  playlist[index].pause()
		}
		
		onSoundEnabledChanged: {
			console.warn("Sound Enabled Changed:", soundEnabled);
			if (soundEnabled) sfxCorrectAnswer.play();
		}
	}
	
	BackgroundMusic {
		id: bgmGolliwogsCakewalk
		autoPlay: false; loops: 1
		source: "qrc:/assets/sounds/debussy-golliwogs-cakewalk.mp3"
		onPlayingChanged: {
			console.warn("GolliwogPlayingChanged:", playing);
		}

		onStopped: next()
	}
	
	BackgroundMusic {
		id: bgmClairDeLune
		autoPlay: false; loops: 1
		source: "qrc:/assets/sounds/debussy-clair-de-lune.mp3"
		onStopped: next()
	}
	
	BackgroundMusic {
		id: bgmArabesque
		autoPlay: false; loops: 1
		source: "qrc:/assets/sounds/debussy-arabesque-1.mp3"
		onStopped: next()
	}
	
	BackgroundMusic {
		id: bgmPrelude4
		autoPlay: false; loops: 1
		source: "qrc:/assets/sounds/chopin-prelude-4.mp3"
		onStopped: next()
	}
	
	BackgroundMusic {
		id: bgmWaltz15
		autoPlay: false; loops: 1
		source: "qrc:/assets/sounds/brahms-waltz-15.mp3"
		onStopped: next()
	}
	
	
	onNext: {
		index = (index + 1) % playlist.length;
		playlist[index].play();
	}
	
	//	-- Sound Effects --
	
	Connections {
		target: JGameAchievements
		onAchievementGet: sfxTada.play()
	}
	
	Connections {
		target: JFractons
		onLevelUp: sfxLevelUp.play()
	}
	
	SoundEffect {
		id: sfxLevelUp
		source: "qrc:/assets/sounds/cdefg.wav"
	}
	
	SoundEffect {
		id: sfxTada
		source: "qrc:/assets/sounds/tada.wav"
		volume: 0.2
	}
	
	SoundEffect {
		id: sfxCorrectAnswer
		source: "qrc:/assets/sounds/c.wav"
		volume: 0.5
	}
	
	SoundEffect {
		id: sfxWrongAnswer
		source: "qrc:/assets/sounds/arpy01.wav"
		volume: 0.8
	}
}

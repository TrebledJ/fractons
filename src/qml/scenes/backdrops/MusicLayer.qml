import Felgo 3.0
import QtQuick 2.0

import "../../game/singles"
import "../../js/Math.js" as JMath

Scene {
	id: scene
	
	//	"logical size"
	width: 480
	height: 320
	
	property alias sfxCorrectAnswer: sfxCorrectAnswer
	property alias sfxWrongAnswer: sfxWrongAnswer
	
	QtObject {
		id: p
		property var playlist: [bgmGolliwogsCakewalk, bgmClairDeLune, bgmArabesque, bgmPrelude4, bgmWaltz15]
		property int index: 0
	}
	
	Component.onCompleted: {
		if (musicEnabled)
			bgmGolliwogsCakewalk.play();
	}
	
	//	-- Background Music --
	
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
	
	
	function next() {
		p.index = (p.index + 1) % p.playlist.length;
		p.playlist[p.index].play();
	}
	
	function playMusic() {
		p.playlist[p.index].play();
	}
	
	function pauseMusic() {
		p.playlist[p.index].pause();
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

import Felgo 3.0
import QtQuick 2.0

import "../../game/singles"
import "../../js/Math.js" as JMath

Scene {
	id: scene
	
	//	== PROPERTY DECLARATIONS ==
	
	property alias sfxCorrectAnswer: sfxCorrectAnswer
	property alias sfxWrongAnswer: sfxWrongAnswer
	
	
	//	== JS FUNCTIONS == 
	
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
	
	width: 480; height: 320
	
	Component.onCompleted: {
		if (musicEnabled)
			bgmGolliwogsCakewalk.play();
	}
	
	
	//	== CHILD OBJECTS ==
	
	QtObject {
		id: p
		property var playlist: [bgmGolliwogsCakewalk, bgmClairDeLune, bgmArabesque, bgmPrelude4, bgmWaltz15]
		property int index: 0
	}
	
	BackgroundMusic {
		id: bgmGolliwogsCakewalk
		autoPlay: false; loops: 1
		source: "qrc:/assets/sounds/debussy-golliwogs-cakewalk.mp3"
		onPlayingChanged: console.warn("GolliwogPlayingChanged:", playing);	//	DEBUG LOGGER
		onStopped: next()
	}
	
	BackgroundMusic { id: bgmClairDeLune; autoPlay: false; loops: 1; onStopped: next(); source: "qrc:/assets/sounds/debussy-clair-de-lune.mp3" }
	BackgroundMusic { id: bgmArabesque; autoPlay: false; loops: 1; onStopped: next(); source: "qrc:/assets/sounds/debussy-arabesque-1.mp3" }
	BackgroundMusic { id: bgmPrelude4; autoPlay: false; loops: 1; onStopped: next(); source: "qrc:/assets/sounds/chopin-prelude-4.mp3" }
	BackgroundMusic { id: bgmWaltz15; autoPlay: false; loops: 1; onStopped: next(); source: "qrc:/assets/sounds/brahms-waltz-15.mp3" }
	
	SoundEffect { id: sfxLevelUp; source: "qrc:/assets/sounds/cdefg.wav" }
	SoundEffect { id: sfxTada; volume: 0.2; source: "qrc:/assets/sounds/tada.wav" }
	SoundEffect { id: sfxCorrectAnswer; volume: 0.5; source: "qrc:/assets/sounds/c.wav" }
	SoundEffect { id: sfxWrongAnswer; volume: 0.8; source: "qrc:/assets/sounds/arpy01.wav" }
	
	Connections { target: JGameAchievements; onAchievementGet: sfxTada.play() }
	Connections { target: JFractons; onLevelUp: sfxLevelUp.play() }
}

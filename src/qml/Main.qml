import Felgo 3.0
import QtQuick 2.0

import "common"
import "game/singles"
import "scenes"
import "scenes/backdrops"
import "scenes/menus"
import "scenes/modes" as Modes
import "scenes/others" as Others
import "scenes/lessons" as Lessons

//	TODO create an accounts feature that will let users switch accounts (locally, of course)

//	Consider change name XP to Fractons as currency
//	using "experience" as a levelling token seems inhumane. Consider:
//	"haha! I have more EXPERIENCE than you. :P" this isn't good psychologically-speaking
//	Khan Academy uses "Energy Points". Something abstract but countable. Totally made up. I can do that to. :-)
//	Let's call it "Fractons" to go with the title.

GameWindow {
	id: gameWindow
	
	// You get free licenseKeys from https://v-play.net/licenseKey
	// With a licenseKey you can:
	//  * Publish your games & apps for the app stores
	//  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
	//  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
	//licenseKey: "<generate one from https://v-play.net/licenseKey>"
//	licenseKey: "B995B3FCCB976891D2E1AE2AFEF301213909105D4FAA9684A32C0C3D61EC2192A1FAC7EB72369A9DA8906EB1A4BBF11B23D24C0C40889061644E97DA0D1B5D80FF7B3E63BFADAAD22EAA6F5E16BEF6DD203810C55E966BEA53115A82E569AE8A5515CBE24504FBDF48DE3287F98D84FF40D1F4916E4B0DE1E30C632528F47F3C3581033C2E739FDBBBF404B349D4A99BFB849894DC5575149D385BDE14E710F1D7260872D016E54DE53C2295A7FD75FF7D72E15CABCF0B35F035676CE2D17929574B1A5F870AC8E92343329191E519337532049F2651471D5EB196D3DD4B0AEE5ABCC80167B07713D94A3B736C7AC3C09CF442A7D9255B8D2B57C21E42EDB797DED4175CE8A0A0327B8343A1B286F18D4FAAAD216D7C4F2A8F371E0DF89984A37A8F9D6016859DCEFE177928A7D8633A"
	
	// the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
	// the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
	// you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
	// this resolution is for iPhone 4 & iPhone 4S
	screenWidth: 960
	screenHeight: 640
	
	property int animationSmallerYBound: activeScene.animationSmallerYBound
	property int animationLargerYBound: activeScene.animationLargerYBound
	
	property alias musicEnabled: settingsScene.musicEnabled
	property alias soundEnabled: settingsScene.soundEnabled
	property alias bgAnimationEnabled: settingsScene.bgAnimationEnabled
	property alias numberPadEnabled: settingsScene.numberPadEnabled
	
	Component.onCompleted: {
		//	load saved settings
		
		musicEnabled = settings.musicEnabled;
		soundEnabled = settings.soundEnabled;
		
		var bga = settings.getValue('bgAnimationEnabled');
		bgAnimationEnabled = bga !== undefined ? bga : true;
		
		var np = settings.getValue('numberPadEnabled');
		numberPadEnabled = np !== undefined ? np : false;
	}
	
	onMusicEnabledChanged: {
		console.warn("Music Enabled Changed:", musicEnabled);
		gameWindow.settings.musicEnabled = musicEnabled;
		if (musicEnabled) musicLayer.playMusic()
		else			  musicLayer.pauseMusic()
	}
	onSoundEnabledChanged: {
		console.warn("Sound Enabled Changed:", soundEnabled);
		gameWindow.settings.soundEnabled = soundEnabled;
	}
	onBgAnimationEnabledChanged: {
		console.warn("BGAnimations Enabled Changed:", bgAnimationEnabled);
		gameWindow.settings.setValue('bgAnimationEnabled', bgAnimationEnabled)
	}
	onNumberPadEnabledChanged: {
		console.warn("NumberPad Enabled Changed:", numberPadEnabled);
		gameWindow.settings.setValue('numberPadEnabled', numberPadEnabled)
	}
	
	
//	state: "home"
	state: "notifications"
//	state: "mode_operations"
	states: [
		State {
			name: "home"
			PropertyChanges { target: homeScene }
			PropertyChanges { target: gameWindow; activeScene: homeScene }
		},
		State {
			name: "exerciseMenu"
			PropertyChanges { target: exerciseMenuScene }
			PropertyChanges { target: gameWindow; activeScene: exerciseMenuScene }
		},
//		State {
//			name: "mode_bar"
//			PropertyChanges { target: modeBarScene; opacity: 1 }
//			PropertyChanges { target: gameWindow; activeScene: modeBarScene }
//		},
		State {
			name: "mode_balance"
			PropertyChanges { target: modeBalanceScene }
			PropertyChanges { target: gameWindow; activeScene: modeBalanceScene }
		},
		State {
			name: "mode_conversion"
			PropertyChanges { target: modeConversionScene }
			PropertyChanges { target: gameWindow; activeScene: modeConversionScene }
		},
		State {
			name: "mode_truth"
			PropertyChanges { target: modeTruthScene }
			PropertyChanges { target: gameWindow; activeScene: modeTruthScene }
		},
		State {
			name: "mode_operations"
			PropertyChanges { target: modeOperationsScene }
			PropertyChanges { target: gameWindow; activeScene: modeOperationsScene }
		},
		
		State {
			name: "studyMenu"
			PropertyChanges { target: studyMenuScene }
			PropertyChanges { target: gameWindow; activeScene: studyMenuScene }
		},
		State {
			name: "lesson_intro"
			PropertyChanges { target: lessonIntroductionScene }
			PropertyChanges { target: gameWindow; activeScene: lessonIntroductionScene }
		},
		State {
			name: "lesson_adding-subtracting-like"
			PropertyChanges { target: lessonAdditionSubtractionLikeScene }
			PropertyChanges { target: gameWindow; activeScene: lessonAdditionSubtractionLikeScene }
		},
		State {
			name: "lesson_balancing"
			PropertyChanges { target: lessonBalancingScene }
			PropertyChanges { target: gameWindow; activeScene: lessonBalancingScene }
		},
		
		State {
			name: "lottery"
			PropertyChanges { target: lotteryScene }
			PropertyChanges { target: gameWindow; activeScene: lotteryScene }
		},
//		State {
//			name: "mode_token"
//			PropertyChanges { target: modeTokenScene }
//			PropertyChanges { target: gameWindow; activeScene: modeTokenScene }
//		},
		
		State {
			name: "achievements"
			PropertyChanges { target: achievementsScene }
			PropertyChanges { target: gameWindow; activeScene: achievementsScene }
		},
		State {
			name: "statistics"
			PropertyChanges { target: statisticsScene }
			PropertyChanges { target: gameWindow; activeScene: statisticsScene }
		},
		State {
			name: "notifications"
			PropertyChanges { target: notificationsScene }
			PropertyChanges { target: gameWindow; activeScene: notificationsScene }
		},
		State {
			name: "settings"
			PropertyChanges { target: settingsScene }
			PropertyChanges { target: gameWindow; activeScene: settingsScene }
//			Transition
		}
	]
	
	BackgroundLayer {
		id: backgroundLayer
		z: -100
		
		animationsEnabled: bgAnimationEnabled
	}
	
	Home {
		id: homeScene
		
		onStudyButtonClicked: gameWindow.state = "studyMenu"
		onExercisesButtonClicked: gameWindow.state = "exerciseMenu"
		onLotteryButtonClicked: gameWindow.state = "lottery"
		onAchievementsButtonClicked: gameWindow.state = "achievements"
		onStatisticsButtonClicked: gameWindow.state = "statistics"
		onNotificationsButtonClicked: gameWindow.state = "notifications"
		onSettingsButtonClicked: gameWindow.state = "settings"
	}
	
	ExerciseMenu {
		id: exerciseMenuScene
		onBackButtonClicked: gameWindow.state = "home"
		onModeClicked: {
			console.debug("Mode: '" + mode + "'");
			gameWindow.state = "mode_" + String(mode).toLowerCase()
		}
	}
	
//	Modes.BarMode {
//		id: modeBarScene
//		onBackButtonClicked: gameWindow.state = "exerciseMenu"
//	}
	
	Modes.BalanceMode {
		id: modeBalanceScene
		numberPadEnabled: gameWindow.numberPadEnabled
		onBackButtonClicked:  gameWindow.state = "exerciseMenu"
		onCorrectAnswer: musicLayer.sfxCorrectAnswer.play()
		onWrongAnswer: musicLayer.sfxWrongAnswer.play()
	}
	
	Modes.ConversionMode {
		id: modeConversionScene
		numberPadEnabled: gameWindow.numberPadEnabled
		onBackButtonClicked:  gameWindow.state = "exerciseMenu"
		onCorrectAnswer: musicLayer.sfxCorrectAnswer.play()
		onWrongAnswer: musicLayer.sfxWrongAnswer.play()
	}
	
	Modes.TruthMode {
		id: modeTruthScene
		numberPadEnabled: gameWindow.numberPadEnabled
		onBackButtonClicked:  gameWindow.state = "exerciseMenu"
		onCorrectAnswer: musicLayer.sfxCorrectAnswer.play()
		onWrongAnswer: musicLayer.sfxWrongAnswer.play()
	}
	
	Modes.OperationsMode {
		id: modeOperationsScene
		numberPadEnabled: gameWindow.numberPadEnabled
		onBackButtonClicked:  gameWindow.state = "exerciseMenu"
		onCorrectAnswer: musicLayer.sfxCorrectAnswer.play()
		onWrongAnswer: musicLayer.sfxWrongAnswer.play()
	}
	
	
	StudyMenu {
		id: studyMenuScene
		onBackButtonClicked: gameWindow.state = "home"
		
		onLessonClicked: {
			console.debug("Lesson: '" + lesson + "'");
			gameWindow.state = "lesson_" + lesson;
		}
	}
	
	Lessons.Introduction {
		id: lessonIntroductionScene
		onBackButtonClicked: gameWindow.state = "studyMenu"
	}
	
	Lessons.AdditionSubtractionLike {
		id: lessonAdditionSubtractionLikeScene
		onBackButtonClicked: gameWindow.state = "studyMenu"
	}
	
	Lessons.Balancing {
		id: lessonBalancingScene
		onBackButtonClicked: gameWindow.state = "studyMenu"
	}
	
	Lottery {
		id: lotteryScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
//	Modes.TokenMode {
//		id: modeTokenScene
//		onBackButtonClicked: gameWindow.state = "lottery"
//	}
	
	Others.Achievements {
		id: achievementsScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
	Others.Statistics {
		id: statisticsScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
	Others.Notifications {
		id: notificationsScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
	Others.Settings {
		id: settingsScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
	NotificationsLayer {}
	MusicLayer { id: musicLayer }
	
	function gotoExercise(mode, difficulty) {
		console.log("Going to exercise", mode, "with a", difficulty, "difficulty.");
		
		
		//	set state to mode
		gameWindow.state = "mode_" + mode.toLowerCase();
		
		//	set difficulty
		if (difficulty === "" || difficulty === undefined || activeScene.difficulties.length === 0)
			return;
		
		var index = activeScene.difficulties.findIndex(function(e){ return e.toLowerCase() === difficulty.toLowerCase(); });
		if (index === -1)
			index = 0;	//	default to 0 index if not found
		
		activeScene.difficultyIndex = index;
	}
	
	function pushBackgroundAnimation(text, parentObject, visibleListener, fontSize) {
		
		var obj = {
			text: text,
			parentObject: parentObject,
			visibleListener: visibleListener,
			fontSize: fontSize,
		};
		
		backgroundLayer.animationQueue.push(obj);
	}
	
}

import VPlay 2.0
import QtQuick 2.0

import "common"
import "scenes"
import "scenes/modes" as Modes
import "scenes/others" as Others
import "scenes/lessons" as Lessons

//	TODO create an accounts feature that will let users switch accounts (locally, of course)

//	TODO consider change name XP to Fractureuns as currency
//	using "experience" as a levelling token seems inhumane. Consider:
//	"haha! I have more EXPERIENCE than you. :P" this isn't good psychologically-speaking
//	Khan Academy uses "Energy Points". Something abstract but countable. Totally made up. I can do that to. :-)
//	Let's call it "Fractureuns" to go with the title.

GameWindow {
	id: gameWindow
	
	// You get free licenseKeys from https://v-play.net/licenseKey
	// With a licenseKey you can:
	//  * Publish your games & apps for the app stores
	//  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
	//  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
	//licenseKey: "<generate one from https://v-play.net/licenseKey>"
	
	// the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
	// the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
	// you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
	// this resolution is for iPhone 4 & iPhone 4S
	screenWidth: 960
	screenHeight: 640
	
	Component.onCompleted: {
//		jNotifications.notify("Greetings", "Hello there, welcome to Fractureuns.", 5);
	}
	
	
//	state: "home"
//	state: "achievements"
	state: "lesson_zero"
	states: [
		State {
			name: "home"
			PropertyChanges { target: homeScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: homeScene }
		},
		State {
			name: "exerciseMenu"
			PropertyChanges { target: exerciseMenuScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: exerciseMenuScene }
		},
		State {
			name: "mode_standard"
			PropertyChanges { target: modeStandardScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: modeStandardScene }
		},
//		State {
//			name: "mode_bar"
//			PropertyChanges { target: modeBarScene; opacity: 1 }
//			PropertyChanges { target: gameWindow; activeScene: modeBarScene }
//		},
		State {
			name: "mode_balance"
			PropertyChanges { target: modeBalanceScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: modeBalanceScene }
		},
		State {
			name: "mode_conversion"
			PropertyChanges { target: modeConversionScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: modeConversionScene }
		},
		State {
			name: "mode_truth"
			PropertyChanges { target: modeTruthScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: modeTruthScene }
		},
		
		State {
			name: "studyMenu"
			PropertyChanges { target: studyMenuScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: studyMenuScene }
		},
		State {
			name: "lesson_zero"
			PropertyChanges { target: lessonZeroScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: lessonZeroScene }
		},
		State {
			name: "lesson_one"
			PropertyChanges { target: lessonOneScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: lessonOneScene }
		},
		
		State {
			name: "achievements"
			PropertyChanges { target: achievementsScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: achievementsScene }
		},
		State {
			name: "statistics"
			PropertyChanges { target: statisticsScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: statisticsScene }
		},
		State {
			name: "settings"
			PropertyChanges { target: settingsScene; state: "show" }
			PropertyChanges { target: gameWindow; activeScene: settingsScene }
//			Transition
		}
	]
	
	//	TODO Change transition from home to exerciseMenu or studyMenu to a slide
//	transitions: [
//		Transition {
//			from: "home"; to: "exerciseMenu"
//			NumberAnimation {
//				target: homeScene
//				property: "x"
//				duration: 300
//				easing.type: Easing.OutCubic
//				to: -homeScene.width
//			}
//		}
//	]
	
	HomeScene {
		id: homeScene
		
		onExercisesButtonClicked: gameWindow.state = "exerciseMenu"
		onStudyButtonClicked: gameWindow.state = "studyMenu"
		onAchievementsButtonClicked: gameWindow.state = "achievements"
		onStatisticsButtonClicked: gameWindow.state = "statistics"
		onSettingsButtonClicked: gameWindow.state = "settings"
	}
	
	ExerciseMenuScene {
		id: exerciseMenuScene
		onBackButtonClicked: gameWindow.state = "home"
		onModeClicked: {
			console.debug("Mode: '" + mode + "'");
			gameWindow.state = "mode_" + String(mode).toLowerCase()
		}
	}
	
	Modes.StandardMode {
		id: modeStandardScene
		onBackButtonClicked: gameWindow.state = "exerciseMenu"
	}
	
//	Modes.BarMode {
//		id: modeBarScene
//		onBackButtonClicked: gameWindow.state = "exerciseMenu"
//	}
	
	Modes.BalanceMode {
		id: modeBalanceScene
		onBackButtonClicked: gameWindow.state = "exerciseMenu"
	}
	
	Modes.ConversionMode {
		id: modeConversionScene
		onBackButtonClicked: gameWindow.state = "exerciseMenu"
	}
	
	Modes.TruthMode {
		id: modeTruthScene
		onBackButtonClicked: gameWindow.state = "exerciseMenu"
	}
	
	
	StudyMenu {
		id: studyMenuScene
		onBackButtonClicked: gameWindow.state = "home"
		
		onLessonClicked: {
			console.debug("Lesson: '" + lesson + "'");
			gameWindow.state = "lesson_" + lesson;
		}
	}
	
	Lessons.Zero {
		id: lessonZeroScene
		onBackButtonClicked: gameWindow.state = "studyMenu"
	}
	
	Lessons.One {
		id: lessonOneScene
		onBackButtonClicked: gameWindow.state = "studyMenu"
		onPracticeButtonClicked: gotoExercise(mode, difficulty)
	}
	
	
	Others.Achievements {
		id: achievementsScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
	Others.Statistics {
		id: statisticsScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
	Others.Settings {
		id: settingsScene
		onBackButtonClicked: gameWindow.state = "home"
	}
	
	function gotoExercise(mode, difficulty) {
		console.log("Going to exercise", mode, "with a", difficulty, "difficulty.");
		
		//	set state to mode
		gameWindow.state = "mode_" + mode.toLowerCase();
		
		if (difficulty === "" || activeScene.difficulties.length === 0)
			return;
		
		var index = activeScene.difficulties.findIndex(function(e){ return e.toLowerCase() === difficulty.toLowerCase(); });
		activeScene.difficultyIndex = index;
	}
	
}

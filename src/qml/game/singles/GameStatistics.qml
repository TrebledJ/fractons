pragma Singleton
import QtQuick 2.0

Item {
	id: item
	
	//	== SIGNAL & PROPERTY DECLARATIONS ==
	
	signal dailyDataModified
	signal pastQuestionsModified
	
	property var dailyData: ({})
	property var pastQuestions: []
	
	
	//	== JS FUNCTIONS ==
	
	function loadStatistics() {
		var tempData = JStorage.getValue('stats/general');
		if (tempData === undefined) console.error("[Fractons] Key: 'stats/general' returned undefined from storage.");
		dailyData = tempData !== undefined ? tempData : {};
		
		var tempQuestions = JStorage.getValue('stats/questions');
		if (tempQuestions === undefined) console.error("[Fractons] Key: 'stats/questions' returned undefined from storage.");
		pastQuestions = tempQuestions !== undefined ? tempQuestions : [];
		
	}
	
	function incDailyAttempted() {
		var key = constructDate();
		if (!(key in dailyData))
		{
			dailyData[key] = {
				attempted: 0,
				correct: 0,
				fractonsEarned: 0
			}
		}
		dailyData[key].attempted += 1;
		dailyDataModified();
	}
	
	function incDailyCorrect() {
		var key = constructDate();
		if (!(key in dailyData))
		{
			dailyData[key] = {
				attempted: 0,
				correct: 0,
				fractonsEarned: 0
			}
		}
		dailyData[key].correct += 1;
		dailyDataModified();
	}
	
	function addDailyFractons(num) {
		if (isNaN(num) || num === undefined)
		{
			console.error("[GameStatistics] Expected num to be a number, got", num, "instead.");
			return;
		}
		
		var key = constructDate();
		if (!(key in dailyData))
		{
			dailyData[key] = {
				attempted: 0,
				correct: 0,
				fractonsEarned: 0
			}
		}
		
		dailyData[key].fractonsEarned += Number(num);
		dailyDataModified();
	}
	
	function constructDate(date) {
		if (date === undefined)
			date = new Date(Date.now());
		
		return date.getFullYear() + '-' + (1+date.getMonth()) + '-' + date.getDate();
	}
	
	function pushQuestion(mode, difficulty, question, input, answer, isCorrect) {
		var obj = {
			mode: mode,
			difficulty: difficulty,
			question: question,
			input: input,
			answer: answer,
			isCorrect: isCorrect
		};
		pastQuestions.push(obj);
		pastQuestionsModified();
	}
	
	
	//	== ATTACHED PROPERTIES & SIGNAL HANDLERS ==
	
	Component.onCompleted: {
		console.warn("Reloading JGameStatistics...");
		loadStatistics();
	}
	
	onDailyDataModified: {
		console.log("Daily data changed!");
		JStorage.setValue('stats/general', dailyData);
	}
	onPastQuestionsModified: {
		console.log("Past questions changed!");
		JStorage.setValue('stats/questions', pastQuestions);
	}
	
}

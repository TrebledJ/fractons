###### Last Updated: Saturday, February 26, 2019

# The Statistics Scene

## Brief

To display a set of past statistics, we will need to store past results.

The statistics scene will display:

(in several tabs?)

1. A bar chart showing progress. On the x-axis, we have time. Each data point holds two categories: number of correctly answered questions, and the number of attempted questions. (Look into [BarSeries](https://doc.qt.io/qt-5/qml-qtcharts-barseries.html)). Another categorical set could be the number of fractons earned on a day. Thus, each day will require the following data:
	* the number of questions Attempted
	* the number of questions Correctly Answered
	* the number of Fractons Earned
2. Past questions (accessed by clicking on the bar chart). The questions consist of:  
	* the Question itself
	* the User's answer
	* the Correct answer
	* whether the answers are the same



## Storage
The following JSON formats are proposed for use in storing past questions.

For storing general statistics for the chart:

	// CHOSEN
	key: stats_general
	value: {
		date as <string>: {
			attempted: <int>,
			correct: <int>,
			fractonsEarned: <int>
		}
		.
		.
		.
		ad-infinitum
	}
	
or

	key: stats_general
	value: [
		{
			date: <string>,
			attempted: <int>,
			correct: <int>,
			fractonsEarned: <int>
		}
		.
		.
		.
		ad-infinitum
	]
	
For storing statistics into recent questions:

	key: stats_questions
	value: [
		{
			mode: <string>,
			difficulty: <string>,
			question: <string>,
			input: <string>,
			answer: <string>,
			isCorrect: <bool>
		}
		.
		.
		.
		ad-infinitum
	]
	












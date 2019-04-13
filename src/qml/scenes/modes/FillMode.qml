import QtQuick 2.0
import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../game/singles"
import "../../graphicmath"

import "../../js/Fraction.js" as JFraction
import "../../js/Math.js" as JMath
import "../../js/Utils.js" as JUtils

ModesBase {
	id: modesBase

	readonly property int easy: 0
	readonly property int medium: 1
	readonly property int hard: 2
	property int countSelected: 0

	
	//	== JS FUNCTIONS ==
	
	//	checks if text has a parsing error
	function hasParsingError(text) {
		return false;
	}
	
	//	checks text against input validation
	function checkInput(text) {
		if (countSelected === 0)
		{
			rejectInput("At least one square should be shaded.")
			return false;
		}
		
		acceptInput();
		return true;
	}
	
	//	checks the answer provided by text
	function checkAnswer(text) {
		return new JFraction.Fraction(countSelected, grid.numCells).equals(question.fraction);
	}
	
	//	returns an answer that would have been marked as correct
	function getCorrectAnswer() {
		var f = question.fraction.copy();
		f.n *= grid.numCells;
		var f2 = f.simplified();
		var n = f2.n;
		
		return 'There should be ' + n + ' shaded squares, but only ' + countSelected + ' were shaded';
	}
	
	//	generates a new, random question
	function generateRandomQuestion() {
		grid.clear();
		
//		var d = JMath.choose(JUtils.popArray(JMath.factors(100), 0));	//	pop to remove 1 at index 0
//		var n = JMath.randI(1, d);
		
		var maxSize = [8, 10, 16][difficultyIndex];
		
		var d = JMath.randI(2, maxSize);
		var n = JMath.randI(1, d);
		question.fraction = new JFraction.Fraction(n, d);
		
		
//		var maxFactor = Math.floor(maxSize / d);
//		var factor = JMath.randI(1, maxFactor);
//		grid.gridSize = d * factor;
		
		var possibleSizes = [];
		for (var i = 2; i <= maxSize; i++)
			if ((i*i*n) % d === 0)
				possibleSizes.push(i);
		
		grid.gridSize = JMath.choose(possibleSizes);
	}
	
	
	
	//	== If there is more than one difficulty: == //
	
	//	encodes the current question's state
	function getQuestionState() {
		return {
			gridSize: grid.gridSize,
			fraction: question.fraction
		};
	}
	
	//	decodes the state provided
	function parseQuestionState(state) {
		grid.gridSize = state.gridSize;
		question.fraction = state.fraction;
		
		grid.clear();
	}
	
	
	//	== OBJECT PROPERTIES, ATTACHED PROPERTIES & SIGNAL-HANDLERS ==
	difficulties: ["Easy", "Medium", "Hard"]
	
	modeName: 'Fill'
	rewardAmount: [2, 3, 5][difficultyIndex]
	unit: "fractons"
	
	answerField.visible: false	//	hide the answer field
	acceptableInput: "1234567890/".split('');
	
	help: Item {
		Column {
			width: parent.width
			spacing: 20
			
			TextBase { text: "Fill Mode" }
			ParagraphText { text: "In this mode, you gain ƒractons by shading in a given fraction of a grid." }
			TextBase { id: help_exampleText; text: "Example:" }
			Row {
				id: help_exampleRow
				anchors.horizontalCenter: parent.horizontalCenter
				spacing: 50
				
				Fraction { anchors.verticalCenter: parent.verticalCenter; fraction: new JFraction.Fraction(3, 4) }
				
				Item {
					width: help_grid.width; height: help_grid.height
					
					Grid {
						id: help_grid
						width: 120; height: 120
						Repeater {
							model: 16
							Rectangle {
								property bool isChecked: (index % 4) < 3
								width: 30; height: 30
								color: "navy"; opacity: isChecked ? 1 : 0.4
								border { width: 1; color: "yellow" }
							}
						}
					}
					
					TextBase {
						anchors {
							left: help_grid.left
							bottom: help_grid.top
							bottomMargin: help_exampleRow.y - help_exampleText.y - help_exampleText.height
						}
						text: "Possible Answer:"
					}
				}
				
			}
			ParagraphText {
				text: "As long as the correct fraction of the grid is shaded, the shading will be marked as correct. Be creative!"
				font.pointSize: 8
			}

		}
	}
	
	centerpiece: Row {
		spacing: 20
		
		Fraction { id: question; anchors.verticalCenter: parent.verticalCenter }
		Item {
			width: grid.width; height: grid.height
			Grid {
				id: grid
				
				readonly property int rectangleSize: width / gridSize
				readonly property int numCells: rows * columns
				property int gridSize: 10				//	default number of cells going across and down
				
				function clear() {
					for (var i = 0; i < repeater.count; i++)
						repeater.itemAt(i).isChecked = false;
					countSelected = 0;
				}
				
				anchors.centerIn: parent
				width: height; height: 200				//	fixed width/height of 200
				rows: gridSize; columns: gridSize
				
				Repeater {
					id: repeater
					model: grid.rows*grid.columns
					Rectangle {
						id: rectangle
						property bool isChecked
						
						width: grid.rectangleSize; height: grid.rectangleSize
						
						color: "navy"
						opacity: isChecked ? 1 : 0.4
						
						border { width: 1; color: isChecked ? "yellow" : "lightgoldenrodyellow" }
						
						Behavior on opacity { NumberAnimation { duration: 250 } }
						
						onIsCheckedChanged: {
							if (isChecked)
								countSelected++;
							else
								countSelected--;
						}
					}
		
				}
			}
			
			TextBase {
				//	displays number of selected cells
				anchors { bottom: grid.top; left: grid.left }
				text: countSelected
				visible: difficultyIndex === easy
			}
			
			TextBase {
				//	displays grid size: WxH
				anchors { bottom: grid.top; right: grid.right }
				text: grid.gridSize + '×' + grid.gridSize
				visible: difficultyIndex === easy || difficultyIndex === medium
			}
			
			MouseArea {
				property var previousChild
				property bool didPositionChange
				property string fillMode: 'none'	//	[ none | fill | erase ]
				
				anchors.fill: grid
				onClicked: {
					//	individual clicks singly (un)check cells
					var child = grid.childAt(mouseX, mouseY);
					if (child !== null && previousChild !== child)
					{
						if (fillMode == 'fill')
							child.isChecked = true;
						else if (fillMode == 'erase')
							child.isChecked = false;
					}
					
					//	reset only after click
					fillMode = 'none';
				}
				
				onPressed: {
					if (state === "listening")
						return;
					
					//	initialise
					var child = grid.childAt(mouseX, mouseY);
					if (child !== null)
						fillMode = child.isChecked ? 'erase' : 'fill';
					
					didPositionChange = false;
				}
				
				onReleased: {
					//	reset variables
					previousChild = null;
					if (didPositionChange)
						fillMode = 'none';
				}
				
				onPositionChanged: {
					didPositionChange = true;
					
					//	changes to position within the grid will fill/erase cells
					var child = grid.childAt(mouseX, mouseY)
					if (child !== null && previousChild !== child)
					{
						if (fillMode == 'fill')
							child.isChecked = true;
						else if (fillMode == 'erase')
							child.isChecked = false;
					}
					
					previousChild = child;
				}
			}
		}
	}
	
	Component.onCompleted: {
		numberPadEnabled = false;
	}
	
}

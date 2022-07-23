import QtQuick 2.11
import QtCharts 2.2
import QtQuick.Controls 2.4
//import QtQuick.Layouts 1.3

import "../backdrops"
import "../../common"
import "../../game/singles"

SceneBase {
	id: sceneBase
	
	useDefaultTopRibbon: true
	
	Component.onCompleted: {
	
	}
	
	onShownChanged: {
		if (shown)
		{
			//	ACVM : stats?
			JGameAchievements.addProgressByName("stats?", 1);
		}
	}
	
	ChartView {
		id: chartView
		anchors.fill: parent
		parent: Overlay.overlay
		anchors.topMargin: 100
		
		title: "Progress and Statistics"
		titleFont.pointSize: 24
		
		theme: ChartView.ChartThemeBlueCerulean
		legend.alignment: Qt.AlignBottom
		antialiasing: true
		 
		visible: opacity > 0
		opacity: sceneBase.opacity
		
		BarSeries {
			id: series
			
			property var keys // : Object.keys(JGameStatistics.dailyData)
			
			axisX: BarCategoryAxis { 
				categories: series.keys
				labelsFont.pointSize: 16
				labelsAngle: -Math.acos(Math.min(1, chartView.plotArea.width / series.keys.length / 100)) * (180 / Math.PI) * 1.5
			}
			axisY: ValueAxis { id: valueAxis }

			BarSet { id: attempt; label: "Questions Attempted" }
			BarSet { id: correct; label: "Questions Correct" }
			BarSet { id: fractons; label: "Fractons Earned" }
			
			Component.onCompleted: {
				update();
			}
			
			onHovered: {
				floating.visible = status;
				
				if (!status)
					return;
				
				floating.x = 0.75 * (chartView.width - chartView.plotArea.width) + (chartView.plotArea.width / keys.length) * index
				floating.y = chartView.plotArea.y + 20;
				
				floatingText.text = [
							"Attempted: " + attempt.values[index],
							"Correct: " + correct.values[index],
							"Fractons Earned: " + fractons.values[index] + 'ƒ',
						].join('\n');
				
				floating.width = floatingText.contentWidth + 10;
				floating.height = floatingText.contentHeight + 10
				
//				floating.x = mouseArea.mouseX;
//				floating.y = mouseArea.mouseY - floating.height - 10;
				
				if (floating.x + floating.width > chartView.width)
					floating.x = chartView.width - floating.width - 20;
			}
			
			Connections {
				target: JGameStatistics
				onDailyDataModified: {
					series.update();
				}
				
				onDailyDataChanged: {
					series.update();
				}
			}
			
			function update() {
				series.keys = Object.keys(JGameStatistics.dailyData);
				attempt.values = series.keys.map(function(k) { return JGameStatistics.dailyData[k].attempted; });
				correct.values = series.keys.map(function(k) { return JGameStatistics.dailyData[k].correct; });
				fractons.values = series.keys.map(function(k) { return JGameStatistics.dailyData[k].fractonsEarned; });
				
				//  deduce the new min and max
				var max = -1e8;
				for (var i = 0; i < series.count; i++) {
					max = Math.max(max, series.at(i).values.reduce(function(a,b) {
						return Math.max(a, b);
					}));
				}
			
				//  set the new min and max
				valueAxis.min = 0;
				valueAxis.max = max;
				valueAxis.applyNiceNumbers();
			}
		}
		
		Rectangle {
			id: floating
			radius: chartView.backgroundRoundness
			
			color: "yellow"
			visible: false
			opacity: 0.9
			
			TextBase {
				id: floatingText
				anchors.centerIn: parent
				text: "Hi"
			}
		}

	}
	
}

/*
{
    "2019-2-17": {
        "attempted": 6,
        "correct": 6,
        "fractonsEarned": 17
    },
    "2019-2-18": {
        "attempted": 4,
        "correct": 4,
        "fractonsEarned": 4
    },
    "2019-2-19": {
        "attempted": 6,
        "correct": 6,
        "fractonsEarned": 17
    },
    "2019-2-20": {
        "attempted": 4,
        "correct": 4,
        "fractonsEarned": 4
    },
    "2019-2-21": {
        "attempted": 6,
        "correct": 6,
        "fractonsEarned": 17
    },
    "2019-2-22": {
        "attempted": 4,
        "correct": 4,
        "fractonsEarned": 4
    },
    "2019-2-23": {
        "attempted": 6,
        "correct": 6,
        "fractonsEarned": 17
    },
    "2019-2-24": {
        "attempted": 8,
        "correct": 5,
        "fractonsEarned": 5
    },
    "2019-2-25": {
        "attempted": 6,
        "correct": 5,
        "fractonsEarned": 5
    },
    "2019-2-26": {
        "attempted": 4,
        "correct": 4,
        "fractonsEarned": 4
    },
    "2019-2-27": {
        "attempted": 2,
        "correct": 1,
        "fractonsEarned": 1
    }
}
*/

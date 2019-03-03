import QtQuick 2.0


TextBase
{
	id:  eventText
	
	property alias animation1: positionAnimation
	property alias animation2: fadeAnimation
	
	SequentialAnimation
	{
		id: seqAnimation
		NumberAnimation
		{
			id: positionAnimation
			target: eventText
			property: 'y'
			duration: 10000
		}
		NumberAnimation
		{
			id: fadeAnimation
			target: eventText
			property: 'opacity'
			from: 1
			to: 0
			duration: 4000
		}
		
		onStopped: eventText.destroy()
	}
	
	function start()
	{
		seqAnimation.start();
	}
}

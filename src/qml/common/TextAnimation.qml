import QtQuick 2.0


TextBase
{
	id:  textAnimation
	
	property alias animation1: positionAnimation
	property alias animation2: fadeAnimation
	
	SequentialAnimation
	{
		id: seqAnimation
		NumberAnimation
		{
			id: positionAnimation
			target: textAnimation
			property: 'y'
			duration: 10000
		}
		NumberAnimation
		{
			id: fadeAnimation
			target: textAnimation
			property: 'opacity'
			from: 1
			to: 0
			duration: 4000
		}
		
		onStopped: textAnimation.destroy()
	}
	
	function start()
	{
		seqAnimation.start();
	}
}

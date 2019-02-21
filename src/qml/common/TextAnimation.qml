import Felgo 3.0
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
			duration: 5000
		}
		NumberAnimation
		{
			id: fadeAnimation
			target: textAnimation
			property: 'opacity'
			from: 1
			to: 0
			duration: 2000
		}
		
		onStopped: textAnimation.destroy()
	}
	
	function start()
	{
		seqAnimation.start();
	}
}

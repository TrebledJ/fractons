import QtQuick 2.0

import "../backdrops"

ModesBase {
	id: modesBase
	
	modeName: 'Bar'
	numberPadEnabled: false
	
	Component.onCompleted: {
//		modesBase.textFieldColumn.visible = false;
	}
	
}

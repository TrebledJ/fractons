import QtQuick 2.0

import "../common"

TextBase {
	id: textBase
	width: contentWidth; height: contentHeight
	
	text: "1"
	horizontalAlignment: Text.AlignHCenter
	
	font.family: "Cambria Math"
	font.pointSize: 24
	
	//	smart parse: replace ascii symbols with math symbols
	onTextChanged: {
		var replace = {
			'-': '–',
			'*': '×',
			'/': '÷'
		};
		
		for (var symb in replace)
		{
			if (text.includes(symb))
				setText(text.replace(symb, replace[symb]));
			
		}
	}
	
	function setText(t) {
		text = t;
	}
	
//	font.family: cambriaMath.name
//	FontLoader { id: cambriaMath; source: "qrc:/assets/CambriaMath.ttf" }
}

import QtQuick 2.0

import "../common"

TextBase {
	id: textBase
	
	//	trivial, but DO NOT REMOVE
	function setText(t) {
		text = t;
	}
	
	width: contentWidth; height: contentHeight
	
	text: "1"
	horizontalAlignment: Text.AlignHCenter
	font { pointSize: 24; family: "Cambria Math" }
	
	//	font.family: cambriaMath.name
	//	FontLoader { id: cambriaMath; source: "qrc:/assets/CambriaMath.ttf" }
	
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
}

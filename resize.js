var myCols='300,*,300';

function resizeFrames(frameSetId) {
	if(myCols == '300,*,300') {
		myCols='300,*,20';
	} else {
		myCols='300,*,300';
	}
	parent.document.getElementById(frameSetId).cols=myCols;
}


import processing.serial.*;
Serial myPort;
int portNum = 5;
int points = 3;
int rectwidth = 0;
int[][] state = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
int[][] preState = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
float preCentralx = 0.0f;
float preCentraly = 0.0f;
int[] preflow = {0, 0}; //x, y

void setup() {
	size(480, 480);
	background(0);
	rectwidth = width / points;
	println(Serial.list());
	myPort = new Serial(this, Serial.list()[portNum], 9600);
}

void draw() {
	while(myPort.available() > 0){
		int pin = myPort.read();
		println("get " + pin);
		if(pin < 9){
			state[pin / points][pin % points] = 1;
			drawTouchpoint(pin, 255);
		}else {
			state[(pin - 9) / points][(pin - 9) % points] = 0;
			drawTouchpoint(pin - 9, 0);			
		}
		gestureRecognition();
	}

}

void drawTouchpoint(int position, int type){
	int row = position / points;
	int column = position % points;
	stroke(type);
	fill(type);
	rect(column * rectwidth, row * rectwidth, rectwidth, rectwidth);
}

void gestureRecognition(){
	float centralX = 0.0f;
	float centralY = 0.0f;
	int num = 0;
	for (int i = 0; i < points; ++i) {
		for (int j = 0; j < points; ++j) {
			if(state[i][j] == 1){
				centralX += (j + 1);
				centralY += (i + 1);
				num++;
			}
			// if(state[i][j] - preState[i][j] > 0){
				
			// }else if(state[i][j] - preState[i][j] < 0){
				
			// }
			// preState[i][j] = state[i][j];
		}
	}
	if(num > 0){
		centralX = centralX * 80 / num;
		centralY = centralY * 80 / num;
		background(0);
		stroke(255, 0, 0);
		//line(preCentralx, preCentraly, centralX, centralY);
		fill(255, 0, 0);
		ellipse(centralX, centralY, 10, 10);
		preCentralx = centralX;
		preCentraly = centralY;

	}else{
		println("no touch");
		// centralX = preCentralx;
		// centralY = preCentraly;
	}
	//background(0);
	
	
}
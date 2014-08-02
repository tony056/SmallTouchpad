import processing.serial.*;
Serial myPort;
int portNum = 5;
int points = 3;
int rectwidth = 0;
int[][] state = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
int[][] preState = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
float preCentralx = 0.0f;
float preCentraly = 0.0f;
PVector preVector = new PVector(preCentralx, preCentraly);
ArrayList<PVector> trend;
int count = 0;
// boolean init = false;
// PVector initPoint = new PVector(0.0, 0.0);

void setup() {
	size(640, 480);
	background(0);
	rectwidth = 480 / points;
	println(Serial.list());
	myPort = new Serial(this, Serial.list()[portNum], 9600);
	myPort.clear();
	trend = new ArrayList<PVector>();
	textSize(32);
}

void draw() {
	
	while(myPort.available() > 0){
		//int pin = myPort.read();
		for(int i = 0;i < points; i++){
			line(0, height / 3 * (i + 1), 480, height / 3 * (i + 1));
			line(160 * (i + 1), 0, 160 * (i + 1), height);
		}
		String buffer = null;
		buffer = myPort.readStringUntil('\n');
		if(buffer != null && buffer.length() == 10){
			background(0);
			println("get " + buffer);
			for(int i = 0; i < buffer.length() - 1; i++){
				char data = buffer.charAt(i);
				if(data == '1'){
					state[i / points][i % points] = 1;
					//drawTouchpoint(i)
				}
				else{
					state[i / points][i % points] = 0;
				}
			}
			// if(pin < 9){
			// 	state[pin / points][pin % points] = 1;
			//drawTouchpoint(pin, 255);
			// }else {
			// 	state[(pin - 9) / points][(pin - 9) % points] = 0;
			// 	//drawTouchpoint(pin - 9, 0);			
			// }
			// count++;
			//gestureRecognition();
			// if(count % 6 == 0)
			
		}else{
			myPort.clear();
		}
	}
	// }else{
	// 	for(int i = 0; i < points; i++){
	// 		for (int j = 0; j < points; ++j) {
	// 			state[i][j] = 0;
	// 		}
	// 	}
	// }
	//trend.clear();


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
				centralX += (j + 0.5);
				centralY += (i + 0.5);
				num++;
			}
			// if(state[i][j] - preState[i][j] > 0){
				
			// }else if(state[i][j] - preState[i][j] < 0){
				
			// }
			// preState[i][j] = state[i][j];
		}
	}
	//println("num: " + num);
	if(num > 0){
		centralX = centralX * 160 / num;
		centralY = centralY * 160 / num;
		// if(init == false){
		// 	init = true;
		// 	initPoint.set(centralX, centralY);
		// }
		//println("cX: " + centralX + " cY: " + centralY);
		stroke(255, 0, 0);
		PVector vector = new PVector(centralX, centralY);
		vector.sub(preVector);
		if(abs(vector.x) / 160 >= 0.9 || abs(vector.y) / 160 >= 0.9){
			//text(trendRecognition(), 490, 240);
			if(abs(vector.x) > abs(vector.y))
				text("swipe", 490, 240);
			else if(abs(vector.x) < abs(vector.y))
				text("scroll", 490, 240);
		}else{
			//if(trend.size() > 2)
				//text(trendRecognition(), 490, 240);
		}
		// trend.add(vector);
		fill(255, 0, 0);
		ellipse(centralX, centralY, 30, 30);
		preCentralx = centralX;
		preCentraly = centralY;
		preVector.set(preCentralx, preCentraly);

	}else {
		preCentraly = 0.0;
		preCentralx = 0.0;
		preVector.set(preCentralx, preCentraly);
	}
	
}

String trendRecognition(){
	PVector vector = new PVector(0.0, 0.0);
	String gesture = "";
	float threshold = 1.2;
	//println("size: " + trend.size());
	if(trend.size() > 2){
		for (int i = 0; i < trend.size(); ++i) {
			vector.add(trend.get(i));
		}
		//if(trend.size() > 2)	
		if(abs(vector.x) > abs(vector.y) && abs(vector.x) / abs(vector.y) >= threshold){
			if(vector.x < 0)
				gesture = "left";
			else
				gesture = "right";
			trend.clear();

		}else if(abs(vector.x) < abs(vector.y) && abs(vector.y) / abs(vector.x) >= threshold){
			if(vector.y < 0)
				gesture = "up";
			else
				gesture = "down";
			trend.clear();
		}else{
			gesture = "45 degree";
		}
		
	}else{
		gesture = "Not yet";
	}
	return gesture;
}
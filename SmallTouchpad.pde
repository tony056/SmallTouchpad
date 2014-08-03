import processing.serial.*;
Serial myPort;
int portNum = 5;
int points = 3;
int rectwidth = 0;

//int[][] preState = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
int[][] state = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
float preCentralx = 0.0f;
float preCentraly = 0.0f;
PVector preVector = new PVector(preCentralx, preCentraly);
// int[] trend = {0, 0, 0, 0};
ArrayList<PVector> trend;
int count = 0;
int windowSize = 5;
int[][][] collectState = new int[points][points][windowSize]; 

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
	initCollect();
	//frameRate(60);
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
			
			//println("get " + buffer);
			for(int i = 0; i < buffer.length() - 1; i++){
				char data = buffer.charAt(i);
				int row = i / points;
				int column = i % points;
				if(data == '1'){
					state[i / points][i % points] = 1;
					//collectState[row][column][count] = 1;
				}
				else{
					state[i / points][i % points] = 0;
					//collectState[row][column][count] = 0;
				}
			}
			PVector vector = calculateCentral();
			if(vector.x != 0.0 && vector.y != 0.0){
				trend.add(vector);
				if(trend.size() == windowSize){
					float deltaX = 0.0;
					float deltaY = 0.0;
					for(int i = 0;i < trend.size() - 1; i++){
						deltaX += (trend.get(i + 1).x - trend.get(i).x);
						deltaY += (trend.get(i + 1).y - trend.get(i).y);
					}
					if(abs(deltaX) > abs(deltaY)){
						background(0);
						if(deltaX > 0){
							text("Right", 490, 240);
						}else{
							text("Left", 490, 240);
						}
						trend.clear();
					}else if(abs(deltaX) < abs(deltaY)){
						background(0);
						if(deltaY > 0){
							text("Down", 490, 240);	
						}else{
							text("Up", 490, 240);
						}
						trend.clear();
					}
					if(trend.size() > 0)
						trend.remove(0);
				}
			}else{
				trend.clear();
			}
			//count++;
			//println("count: " + count);
			
			//gestureRecognition();
			// if(count % 6 == 0)
			
		}
	}


}

PVector calculateCentral(){
		float centralX = 0.0;
		float centralY = 0.0;
		int num = 0;
		for (int j = 0; j < points; ++j) {
			for (int k = 0; k < points; ++k) {
				if(state[j][k] == 1){
					num++;
					centralX += (k + 0.5);
					centralY += (j + 0.5);
				}
			}
		}
		if(num > 0)
			return new PVector(centralX / num, centralY / num);
		else
			return new PVector(centralX, centralY);
}

void initCollect(){
	for (int i = 0; i < windowSize; ++i) {
		for (int j = 0; j < points; ++j) {
			for (int k = 0; k < points; ++k) {
				collectState[j][k][i] = 0;
			}
		}
	}
}

void drawTouchpoint(int position, int type){
	int row = position / points;
	int column = position % points;
	stroke(type);
	fill(type);
	rect(column * rectwidth, row * rectwidth, rectwidth, rectwidth);
}

// if(count == windowSize){
// 				background(0);
// 				int minNum = 0;
// 				int maxNum = 0;
// 				int[] minPoint = {-1, -1};
// 				int[] maxPoint = {-1, -1};
// 				int[][] state = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}};
// 				for (int j = 0; j < points; ++j) {
// 					for (int k = 0; k < points; ++k) {
// 						for(int i = 0;i < windowSize - 1; i++){
// 							state[j][k] += (collectState[j][k][i + 1] - collectState[j][k][i]);
// 						}
// 						if(state[j][k] < minNum){
// 							minNum = state[j][k];
// 							minPoint[0] = j;
// 							minPoint[1] = k;
// 						}
// 						if(state[j][k] > maxNum){
// 							maxNum = state[j][k];
// 							maxPoint[0] = j;
// 							maxPoint[1] = k;
// 						}
// 					}
// 				}

// 				int deltaX = maxPoint[1] - minPoint[1];
// 				int deltaY = maxPoint[0] - minPoint[0];
// 				println("dX: " + deltaX + " dY: " + deltaY);
// 				if(abs(deltaX) > abs(deltaY)){
// 					if(deltaX > 0){
// 						text("Right", 490, 240);
// 					}else{
// 						text("Left", 490, 240);
// 					}
// 				}else if(abs(deltaX) < abs(deltaY)){
// 					if(deltaY > 0){
// 						text("Down", 490, 240);	
// 					}else{
// 						text("Up", 490, 240);
// 					}
// 				}
// 				count = 0;
// 				initCollect();
// 			}



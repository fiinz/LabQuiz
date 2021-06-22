package screens
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.media.SoundMixer;
	import flash.utils.Timer;
	
	import data.PlayerStats;
	
	import events.NavigationEvent;
	import events.TimerEvent;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;
	
	import utils.CountDown;
	import utils.ObjectPool;
	import utils.SpritePool;
	import utils.TimerBar;
	import utils.Tutorial;
	
	public class Challenge extends Sprite
	{
		
		private var flowSound:Boolean=false;
		private var challengeState:uint;
		private const END_GAME:uint=0;
		private const PLAYING_GAME:uint=1;
		private const TIME_OUT:uint=2;
		private const CHALLENGE_COMPLETE:uint=3;
		
		private var cellWidth:Number;
		private var cellHeight:Number;
		
		
		
		private const COLOR_A:uint= Color.rgb(48,148,185);	
		private const COLOR_B:uint= Color.rgb(235,30,121);		
		private const COLOR_C:uint= Color.rgb(138,197,62);		
		private const COLOR_D:uint= Color.rgb(171,103,31);		
		private const COLOR_E:uint= Color.rgb(249,174,58);		
		private const COLOR_F:uint= Color.rgb(192,1,52);		
		private const COLOR_G:uint= Color.rgb(94,194,164);	
		//alterar o valor 
		
		private const COLOR_H:uint= Color.rgb(215,223,32);		
		private const COLOR_I:uint= Color.rgb(24,82,52);		
		private const COLOR_J:uint= Color.rgb(102,55,0);
		private const COLOR_K:uint= Color.rgb(247,142,30);
		
		
		
		
		
		
		private var flowColors:Array;
		private var spotsImage:Vector.<Image>;
		
		
		
		
		//a imagem de background do challenge
		private var challengeBackground:Image;
		//o tabuleiro container do jogo
		private var tableLevelContainer:Sprite;
		//o tabuleiro container do jogo
		private var spotsContainer:Sprite;		
		//o tabuleiro container do jogo
		private var linesContainer:Sprite;
		
		//nivel atual
		private var levelID:uint;
		
		
		// o array atual com o estado atual
		private var currentObjectArray:Array;
		
		
		//arays con o inicio do jogo 
		private var startLevels:Array=new Array();
		
		//o tamanho do nivel atual (linhas e colunas)
		private var levelNumLines:uint;
		private var levelNumCols:uint;
		
		//Array que guarda as shapes com as linhas e array com as cores em valor rgb
		private var flowLines:Array;
		private var levelColorStrings:Array;
		
		
		//o index da matrix atual
		private var currentLevelIndex:int;
		
		//qual o flow a ser utilizado e o array que guarda o estado individual dos flows
		private var currentFlow:String;
		private var flows:Array;
		
		//o Objecto que esta atualmente a ser tocado
		private var currentObject:Object;
		private var lastObject:Object;
		private var head:Object;
		
		private var newTimerBar:TimerBar;
		private var waypointsTouchAnimation:Array;
		private var systemErrorImage:Image;
		private var touchIndicator:Image;

		
		public function Challenge()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
		}
		private function onAddedToStage(e:Event):void{
			
			this.levelID=1;
			flowColors=new Array();
			flowColors["a"]=COLOR_A;
			flowColors["b"]=COLOR_B;
			flowColors["c"]=COLOR_C;
			flowColors["d"]=COLOR_D;
			flowColors["e"]=COLOR_E;
			flowColors["f"]=COLOR_F;
			flowColors["g"]=COLOR_G;
			flowColors["h"]=COLOR_H;
			flowColors["j"]=COLOR_J;
			flowColors["k"]=COLOR_K;
			this.visible=false;
			drawChallengeScreen();
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
			
			
		}
		
		private var tableBackground:Image;
		private function drawChallengeScreen():void{
			
			tableBackground=new Image(Assets.getAtlas().getTexture("real_frame_background"));
			challengeBackground=new Image(Assets.getTexture("Challenge"+this.levelID+"Background"));
			challengeBackground.visible=true;
			challengeBackground.touchable=false;
			
			this.addChild(challengeBackground);
			newTimerBar=new TimerBar(this);
			newTimerBar.drawTimer(stage.stageWidth*0.8,stage.stageHeight*0.9);
			newTimerBar.hide();
			systemErrorImage=new Image(Assets.getAtlas().getTexture("sistem_error_challenge"));
			systemErrorImage.x=stage.stageWidth/2-systemErrorImage.width/2;
			systemErrorImage.y+=40;
			this.systemErrorImage.visible=false;

			addChild(systemErrorImage);
			
		}
		
		public function initialize(currentLevelID:uint):void{
			
			this.levelID=currentLevelID;
			
			
			
			levelColorStrings=new Array();
			flows=new Array();
			spotsImage=new Vector.<Image>;
			
			
			challengeState=this.PLAYING_GAME;
			
			
			this.levelID=currentLevelID;
			//tenho que alterar depois
			initLevelsArray();
			
			if(Tutorial.ative==false){
				this.currentLevelIndex=(levelID*10)+Math.ceil(Math.random()*2);
			}else{
				this.currentLevelIndex=10;
			}
			
			this.levelNumCols=this.levelNumLines=Math.sqrt(startLevels[currentLevelIndex].length);
			this.cellWidth= Math.ceil((stage.stageWidth*0.85)/this.levelNumCols);
			this.cellHeight=cellWidth;
			tableBackground.width=this.levelNumCols*this.cellWidth*1.1;
			tableBackground.height=this.levelNumCols*this.cellHeight*1.1;
			tableBackground.touchable=false;
			this.addChild(tableBackground);
			
			
			
			this.flowLines=new Array();
			this.spotsContainer=SpritePool.getSprite();
			spotsContainer.flatten();
			this.tableLevelContainer=SpritePool.getSprite();
			this.tableLevelContainer.touchable=true;			
			this.spotsContainer.touchable=false;
			
			
			this.linesContainer=SpritePool.getSprite();
			this.linesContainer.touchable=false;
			
			this.addChild(tableLevelContainer);
			
			
			drawLevelTable();	
			tableBackground.x=stage.stageWidth/2-tableBackground.width/2;
			tableBackground.y=Math.ceil(stage.stageHeight/2-tableBackground.height*0.5)
			
			this.tableLevelContainer.x=Math.ceil(stage.stageWidth/2-tableLevelContainer.width*0.5);
			this.tableLevelContainer.y=Math.ceil(stage.stageHeight/2-tableLevelContainer.height*0.5);
			this.tableLevelContainer.visible=false;
			this.spotsContainer.x=Math.ceil(tableLevelContainer.x);
			this.spotsContainer.y=Math.ceil(tableLevelContainer.y);
			this.linesContainer.x=0;
			this.linesContainer.y=0;
			this.linesContainer.visible=true;
			
			
			
			this.spotsContainer.visible=false;
			addChild(linesContainer);
			addChild(spotsContainer);
			
			
			
			
		}

		public function show():void{
			this.systemErrorImage.visible=false;
			systemErrorImage.touchable=false;
			
			
			
			
			this.visible=true;
			Sounds.currentMusic=Sounds.sndBgChallenge;

			if(!Sounds.muted && Game.isActive){
			
				
				
				SoundMixer.stopAll();
				Sounds.musicChannel=Sounds.currentMusic.play(0,999);
				Sounds.state=Sounds.MUSIC_CHALLENGE;

				
				
			}
			newTimerBar.resetTimer();
			startCoundDown();
			this.addEventListener(Event.ENTER_FRAME,refresh);
			
			
			
		}
		
		
		
		public function showTouchIndicator():void{
			
			this.waypointsTouchAnimation=new Array ();
			waypointsTouchAnimation.push(new Point(this.tableLevelContainer.x+this.currentObjectArray[0].image.x+this.cellWidth/2,this.tableLevelContainer.y+this.currentObjectArray[0].image.y+this.cellWidth/2));
			waypointsTouchAnimation.push(new Point(this.tableLevelContainer.x+this.currentObjectArray[4].image.x+this.cellWidth/2,this.tableLevelContainer.y+this.currentObjectArray[4].image.y+this.cellWidth/2));
			waypointsTouchAnimation.push(new Point(this.tableLevelContainer.x+this.currentObjectArray[5].image.x+this.cellWidth/2,this.tableLevelContainer.y+this.currentObjectArray[5].image.y+this.cellWidth/2));
			waypointsTouchAnimation.push(new Point(this.tableLevelContainer.x+this.currentObjectArray[1].image.x+this.cellWidth/2,this.tableLevelContainer.y+this.currentObjectArray[1].image.y+this.cellWidth/2));
			
			touchIndicator=new Image(Assets.getAtlas().getTexture("hand"));
			touchIndicator.touchable=false;
			addChild(touchIndicator);
			var tempPath:LinePath2D=new LinePath2D(waypointsTouchAnimation);
			tempPath.addFollower(touchIndicator,0);
			TweenMax.to(tempPath,4,{progress:1,ease:Linear.easeNone,repeat:-1});
			
			
			
		}
		
		
		public function startCoundDown():void{
			
			var newCountDown:CountDown=new CountDown(this,this.stage.stageWidth/2,this.stage.stageHeight/2);
			newCountDown.startCountDown();
			this.addEventListener(TimerEvent.COUNT_DOWN_FINISHED,onCountDownFinished);
			
			
			
			
		}
		public function onCountDownFinished(e:TimerEvent):void{
			
			this.removeEventListener(TimerEvent.COUNT_DOWN_FINISHED,onCountDownFinished);
			
			this.tableLevelContainer.visible=true;		
			this.spotsContainer.visible=true;
			this.linesContainer.visible=true;
			Starling.juggler.purge();
			
			newTimerBar.setDuration(20*Game.currentGameLevel);
			newTimerBar.startTimer();
			newTimerBar.show();
			this.addEventListener(TimerEvent.TIME_OUT,timeOut);
			
			if(Tutorial.ative==true){
				
				showTouchIndicator();
				
				
				
				
				
				
			}
			
		}
		
		private var delayedCall:DelayedCall;
		private var timeOutImage:Image;
		public function timeOut(e:TimerEvent):void{
			
			if (!Sounds.muted && Game.isActive){
				Sounds.sndFxTimeOut.play();
			}
			if(Tutorial.ative==true){
				touchIndicator.visible=false;
			}

			
			
			clearTable();
			newTimerBar.hide();
			this.challengeState=this.TIME_OUT;
			
			delayedCall=new DelayedCall(delay,3);
			delayedCall.repeatCount=1;
			Starling.juggler.purge();
			Starling.juggler.add(delayedCall);
			
			
			
			
			timeOutImage=new Image(Assets.getAtlas().getTexture("timeover_awnser"));
			timeOutImage.x=stage.stageWidth/2-timeOutImage.width/2;
			timeOutImage.y=stage.stageHeight/2-timeOutImage.height/2;
			addChild(timeOutImage);
			
			//var timeOver:Image=new Image(Assets.
			trace("terminou tempo");
			
			
			this.removeEventListener(TimerEvent.TIME_OUT,timeOut);
			
			
			
			
		}
		private function delay():void{
			
			
			removeChild(timeOutImage);
			this.newTimerBar.stopTimer();
			this.handleEndChallenge();
			
			
			
			
		}
		public function disposeTemporarily():void{
			
			this.visible=false;
		}
		
		
		
		private function initLevelsArray():void{
			
			//desenho das matrizes
			// 0 a 9 primeiro level
			
			startLevels[52]=new Array(
				
				"0","0","0","0","0","0","0","0",
				"0","b","0","0","0","0","0","0",
				"0","0","0","0","0","0","0","0",
				"0","0","0","0","0","f","0","0",
				"b","c","0","a","0","0","0","0",
				"a","0","0","d","f","0","0","0",
				"0","c","0","0","e","0","e","d",
				"0","0","0","0","0","0","0","0"
				
				
			);
			
			
			startLevels[51]=new Array(
				
				"0","d","0","0","0","0","0","h",
				"0","b","0","0","0","0","c","0",
				"0","0","0","0","f","0","e","0",
				"0","0","0","e","0","0","h","0",
				"0","0","0","d","g","0","0","0",
				"0","b","c","0","0","0","g","0",
				"0","0","0","0","f","0","0","0",
				"a","0","0","0","0","0","0","a"
				
				
			);
			
			//8x8
			
			startLevels[50]=new Array(
				
				"a","0","0","a","b","0","0","0",
				"0","0","g","f","c","0","c","0",
				"0","0","i","0","0","0","0","0",
				"0","0","h","0","d","e","0","0",
				"0","0","0","0","f","0","0","0",
				"0","0","0","g","0","0","0","0",
				"0","i","0","h","0","0","d","b",
				"0","0","0","0","0","0","0","e"
				
				
				
			);
			
			
			startLevels[42]=new Array(
				
				"0","0","0","0","0","0","0",
				"a","0","0","0","0","0","0",
				"0","0","b","0","0","0","0",
				"0","0","0","0","b","0","0",
				"0","0","e","0","d","0","0",
				"c","d","0","0","e","c","0",
				"a","0","0","0","0","0","0"
				
				
			);
			
			
			startLevels[41]=new Array(
				
				"a","0","0","0","0","0","0",
				"b","0","0","0","0","0","a",
				"c","0","c","g","h","0","b",
				"d","0","f","0","0","0","h",
				"e","0","0","0","0","g","f",
				"0","d","0","0","0","0","0",
				"0","0","0","0","0","0","e"
				
				
			);
			
			//7x7
			
			startLevels[40]=new Array(
				
				"0","a","b","0","0","0","0",
				"0","0","c","d","0","d","0",
				"0","0","e","0","0","0","0",
				"0","0","f","g","0","e","0",
				"0","0","0","0","g","f","0",
				"0","0","c","0","0","0","0",
				"0","0","a","b","0","0","0"
				
				
			);
			
			startLevels[32]=new Array(
				
				"0","0","0","0","0","0",
				"0","a","0","0","d","0",
				"0","0","0","c","0","0",
				"0","0","0","0","0","0",
				"0","0","a","b","d","0",
				"0","0","b","c","0","0"
				
				
			);
			startLevels[31]=new Array(
				
				"0","c","b","0","0","a",
				"0","0","0","0","0","0",
				"0","0","f","e","0","a",
				"0","0","0","d","0","b",
				"0","e","f","0","d","c",
				"0","0","0","0","0","0"
				
				
			);
			
			//6x6
			startLevels[30]=new Array(
				
				"a","b","c","0","d","e",
				"0","0","0","0","f","0",
				"0","0","c","0","0","0",
				"0","0","d","0","0","0",
				"a","0","f","0","0","0",
				"b","0","e","0","0","0"
				
				
				
			);
			
			
			
			
			
			startLevels[22]=new Array(
				
				"0","0","0","a","c",
				"0","b","0","0","0",
				"0","0","0","a","0",
				"0","b","0","0","0",
				"0","c","d","0","d"
				
				
				
			);
			
			
			startLevels[21]=new Array(
				
				"c","0","0","0","b",
				"0","0","d","0","0",
				"0","0","e","0","0",
				"0","0","0","0","0",
				"d","e","c","b","0"
				
				
				
			);
			
			//5x5
			
			startLevels[20]=new Array(
				
				"a","0","0","0","a",
				"b","0","0","0","0",
				"c","d","0","d","0",
				"0","0","0","0","0",
				"c","b","e","0","e"
				
				
				
			);
			startLevels[12]=new Array(
				
				"a","b","0","0",
				"0","0","a","0",
				"c","0","0","0",
				"c","0","0","b"
				
				
			);
			
			startLevels[11]=new Array(
				
				"0","0","a","c",
				"0","0","a","0",
				"b","c","0","0",
				"0","0","0","b"
				
				
				
				
				
			);
			
			startLevels[10]=new Array(
				
				"a","a","b","0",
				"0","0","c","0",
				"c","0","0","0",
				"0","0","b","0"
				
				
				
				
			);
			
			
			
			
			
			
		}
		
		
		private function removeTableListeners():void{
			
			
			for(var i:uint=0;i<currentObjectArray;i++){
				
				if(currentObjectArray[i].spot==true){
					
					currentObjectArray[i].removeEventListener(TouchEvent.TOUCH,onSpotTouch);
					
					
				}
				else{
					
					currentObjectArray[i].removeEventListener(TouchEvent.TOUCH,onFlowTouch);					
					
				}	
				
				
			}
			
			
			
			
		}
		
		private function drawLevelTable():void{
			
			
			currentObjectArray=new Array();
			
			for ( var i:uint=0;i<this.startLevels[this.currentLevelIndex].length;i++)
			{			
				drawCell(i);
				
			}
			
			
		}
		
		private function drawCell(i:uint):void{
			
			
			var obj:Object=new Object();
			//index do objecto na matriz
			obj.index=i;
			//valor inicial
			obj.initValue=this.startLevels[currentLevelIndex][i];
			//valor atual
			obj.value=obj.initValue;
			//a imagem
			
			obj.image=new Image(Assets.getAtlas().getTexture("cell_0"));	
			obj.image.width=this.cellWidth;
			obj.image.height=this.cellHeight;
			
			
			obj.selected=false;
			obj.spot=false;
			obj.width=this.cellWidth;
			obj.width=this.cellHeight;
			
			
			//variaveis auxiliares para colocar as cells faz calculo baseado no num cols
			var auxX:uint=int(obj.index%this.levelNumCols)*(obj.image.width+1);
			var auxY:uint=int(obj.index/this.levelNumCols)*(obj.image.height+1);
			
			
			//obj.image.visible=false;
			obj.image.x=auxX;
			obj.image.y=auxY;
			
			if(obj.value!="0")
			{
				
				//se o valor nao é 0 quer dizer que é um spot
				obj.spot=true;
				obj.image.addEventListener(TouchEvent.TOUCH,onSpotTouch);
				obj.image.touchable=true;
				//obj.image.alpha=0;
				//obj.image.visible=true;
				
				drawSpot(obj.image.x,obj.image.y,obj.value);
				if(flowLines[obj.value]==null){
					
					flowLines[obj.value]=new Shape();
					levelColorStrings.push(obj.value);
					this.linesContainer.addChild(flowLines[obj.value]);
					
				}
				
				
				
				
			}
			
			
			//acrescenta ao tabuleiro
			this.tableLevelContainer.addChild(obj.image);
			//fica no array
			currentObjectArray[i]=obj;		
			
			
			
		}
		
		private function drawSpot(x:uint,y:uint,flow:String):void{
			
			var image:Image=new Image(Assets.getAtlas().getTexture("cell_"+flow));
			
			
			image.width=this.cellWidth*0.8;
			image.height=this.cellHeight*0.8;
			
			image.x=Math.ceil(x)+this.cellWidth*0.5-image.width*0.5;
			image.y=Math.ceil(y)+this.cellWidth*0.5-image.height*0.5;;
			
			spotsImage.push(image);
			
			this.spotsContainer.addChild(image);
			
			
		}
		
		private function getObjectFromPosition(point:Point):Object{
			
			//obter o objeto através da imagem
			
			var aux:Object;
			var obj:Object;
			var local:Point=new Point();
			local=this.tableLevelContainer.globalToLocal(point);
			
			
			
			
			
			
			
			
			return new Object();
		}
		
		
		private function getObjectFromImage(image:Image):Object{
			
			//obter o objeto através da imagem
			
			var obj:Object;
			for(var i:uint=0;i<this.currentObjectArray.length;i++){
				
				if(this.currentObjectArray[i].image==image){
					
					obj=this.currentObjectArray[i];
				}		
				
				
			}
			return obj;
		}
		
		
		private function isCell(image:Image):Boolean
		{
			//verifica se a colisão é dentro da matriz
			
			for(var i:uint=0;i<this.currentObjectArray.length;i++){
				//trace("i"+i);
				
				if(this.currentObjectArray[i].image==image)
				{
					return true;
				}
				
			}
			
			
			
			return false;
		}
		
		
		
		
		
		
		private function resetFlow(flow:String):void
		{
			
			//faz um reset total ao flow
			
			for(var i:uint=0;i<this.currentObjectArray.length;i++){
				
				if(this.currentObjectArray[i].value==flow)
				{
					this.currentObjectArray[i].image.removeEventListener(TouchEvent.TOUCH,onFlowTouch);
					this.currentObjectArray[i].selected=false;
					this.currentObjectArray[i].value=this.currentObjectArray[i].initValue;
					
					this.currentObjectArray[i].image.texture=Assets.getAtlas().getTexture("cell_0");
					
					
					
					
				}
				
			}		
			
			
			
		}
		
		
		
		private function onFlowTouch(e:TouchEvent):void
		{
			if(challengeState==this.CHALLENGE_COMPLETE ||challengeState==this.TIME_OUT ){return;}
			
			
			var touchBegan:Touch=e.getTouch(this,TouchPhase.BEGAN);
			var touchMoved:Touch=e.getTouch(this,TouchPhase.MOVED);
			var touchEnded:Touch=e.getTouch(this,TouchPhase.ENDED);
			var auxPoint:Point=new Point(e.touches[0].globalX,e.touches[0].globalY);		
			var currentTouchImage:Image=this.hitTest(auxPoint,true) as Image;
			if(isCell(currentTouchImage))
			{
				
				
				if(challengeState==this.PLAYING_GAME){
					
					
					
					
					
					this.currentObject=getObjectFromImage(currentTouchImage);
					
					if(touchBegan){
						
						//no flow é o valor atual nao o initial
						currentFlow=currentObject.value;
						lastObject=currentObject;
						head=this.currentObject;
						updateFlow(currentFlow,false);
						updateFlowsDrawing();
						
						
						
						
					}			
					if(touchMoved){handleTouchMoved();}
					if(touchEnded){handleTouchEnded();}
					
					
				}
				
				
			}
			
			
			
			
		}
		
		private function onSpotTouch(e:TouchEvent):void
		{
			
			if(challengeState==this.CHALLENGE_COMPLETE ||challengeState==this.TIME_OUT ){return;}
			
			trace(" touch");
			
			var touchBegan:Touch=e.getTouch(this,TouchPhase.BEGAN);
			var touchMoved:Touch=e.getTouch(this,TouchPhase.MOVED);
			var touchEnded:Touch=e.getTouch(this,TouchPhase.ENDED);
			var auxPoint:Point=new Point(e.touches[0].globalX,e.touches[0].globalY);		
			var currentTouchImage:Image=this.hitTest(auxPoint,true) as Image;
			
			if(isCell(currentTouchImage))
			{
				
				
				
				if(challengeState==this.PLAYING_GAME){
					
					
					
					
					
					
					this.currentObject=getObjectFromImage(currentTouchImage);
					
					
					if(touchBegan){
						handleSpotTouchBegan();
						
						
					}
					if(touchMoved){handleTouchMoved();}
					if(touchEnded){handleTouchEnded();}
					
				}
				
				
				
				
			}
			
			
		}
		
		
		
		
		private function handleSpotTouchBegan():void
		{
			currentFlow=this.currentObject.initValue;
			resetFlow(currentFlow);
			this.currentObject.selected=true;
			flows[currentFlow]=new Array();
			flows[currentFlow].push(currentObject);
			redrawCell(currentObject);
			lastObject=currentObject;
			head=currentObject;
			if(!allFlowsAreClosed()){
				if(systemErrorImage.hasEventListener(Event.ENTER_FRAME)){
					
					systemErrorImage.removeEventListeners();
					systemErrorImage.visible=false;
					
				}
			}
			updateFlowsDrawing();
			
			
		}
		
		private function removeEventsFromUnselectedCells():void{
			
			for(var i:uint=0;i<this.currentObjectArray.length;i++)
			{
				
				if(this.currentObjectArray[i].spot==false && this.currentObjectArray[i].image.hasEventListener(TouchEvent.TOUCH)
					
					&& this.currentObjectArray[i].selected==false){
					
					
					
					
					
					this.currentObjectArray[i].image.removeEventListener(TouchEvent.TOUCH,onFlowTouch);
					
				}
				
				
				
			}
			
			
		}
		private function handleTouchEnded():void{
			
			redrawCells();
			flowSound=false;
			
			removeEventsFromUnselectedCells();
			
		
			if(allFlowsAreClosed()&&!this.challengeIsComplete()){
				trace("system error game");
				this.systemErrorImage.visible=true;
				if(!systemErrorImage.hasEventListener(Event.ENTER_FRAME)){
					
					this.systemErrorImage.addEventListener(Event.ENTER_FRAME,animateSystemWarning);
				
				}

			
			}
			
			
			
			
			
			
			
		}
		private function handleTouchMoved():void
		{
			
			
			if( moveIsValid() )
			{
				
				if(this.currentObject.selected==false)
					
				{			
					head=currentObject;
					this.currentObject.value=currentFlow;
					flows[currentFlow].push(currentObject)
					currentObject.image.addEventListener(TouchEvent.TOUCH,onFlowTouch);
					// célula nao selecionada
					
					this.currentObject.selected=true;
					//a cor do primeiro spot clicado
					
					
				}				
					
				else			
				{
					if(head.value==currentObject.value){
						
						//aqui fez moved para um que está selecionado
						head=this.currentObject;
						updateFlow(currentFlow,false);
						
						
					}
					else{
						
						updateFlow(currentObject.value,true);					
						
					}
					
					
					//AQUI PORQUE VOLTAS PARATRAS O TEU CAMINHO TEM QUE FICAR MAIS CURTO E ACOMPANHAR ASSIM É MAIS FACIL
					
					
					
					
					
				}
				
				lastObject=currentObject;
				if(flowIsClosed(currentFlow)){trace("flow closed");}
				
				updateFlowsDrawing();
				
				
				
			}
			
		}
		
		
		
		private function redrawCells():void{
			
			for(var i:uint=0;i<this.currentObjectArray.length;i++){
				
				redrawCell(currentObjectArray[i]);
			}
			
			
			
		}
		
		
		
		
		
		private function flowIsClosed(color:String):Boolean{
			var count:uint=0;
			for(var i:uint=0;i<this.currentObjectArray.length;i++){
				
				if(this.currentObjectArray[i].value==this.currentFlow)
				{
					if(this.currentObjectArray[i].spot==true && this.currentObjectArray[i].selected==true)
					{
						count++;
						
					}
					
					
				}
			}
			if(count<2){return false;}
			if (!Sounds.muted && flowSound==false){
				Sounds.sndFxChallenge.play();
				redrawCells();
				flowSound=true;
			}
			
			if(Tutorial.ative==true){
				if(this.currentObjectArray[0]==this.currentObject || this.currentObjectArray[1]==this.currentObject ){
					this.touchIndicator.visible=false;
					TweenMax.killAll();
					
				}
				
			}
			
			return true;
		}
		
		private function moveIsValid():Boolean{
			
			// se está na head nao interessa processar
			if(currentObject==head){return false;}
			//definir regras de movimentaç\ao todas aqqui
			
			var auxDif:uint=Math.abs(head.index-currentObject.index);
			
			//garantir que fecha o caminho quando as duas spots estao 			
			//	var auxLength:uint=this.flows[currentFlow].length;
			if (flowIsClosed(currentFlow)){return false;}
			
			
			//limito os movimentos e limito 
			
			//garantir que nao vai directo de um spot para outro
			if (currentObject.spot==true && lastObject.spot==true){return false;}
			
			
			
			
			//garantir que o flow atual nao vai para cima de um spot de difente cor
			if (currentObject.spot==true && currentObject.value!=lastObject.value){
				return false;
				
				
			}
			//permitir somente deslocações na vertical e para o vizinho proximo
			if((auxDif!=this.levelNumCols && auxDif!=1))
			{
				
				return false;
				
				
				
			}
			if(auxDif==1){
			
				//verificar quando muda de linha mas os indices sao continuos e mesmo spot.
				
			
			
			}
			
			
			
			
			
			return true;
		}
		
		
		private function updateFlow(flow:String,overlap:Boolean):void{
			
			//identificar a celula no corrente flowId
			var currentCellFlowId:uint;
			
			//trace("deixa ver o flow"+flows[flow].length);
			
			for( var i:uint=0;i<flows[flow].length;i++){
				
				if(flows[flow][i]==this.currentObject){
					currentCellFlowId=i;
					
				}
				
				
			}
			
			var count:uint=0;
			var auxStart:uint=currentCellFlowId;
			if(overlap==false){auxStart=currentCellFlowId+1};
			//remover as células que estão por excesso e repor valores
			for( var j:uint=(auxStart);j<flows[flow].length;j++){
				
				flows[flow][j].selected=false;
				count++;
				//flows[flow][j].image.removeEventListener(TouchEvent.TOUCH,onFlowTouch);
				
				//ele so pode remover o listener em		touch Ended
				
				// fazer evento para isto.
				
				flows[flow][j].value=flows[flow][j].initValue;				
				redrawCell(flows[flow][j]);
				
			}
			
			
			flows[flow].splice(auxStart,count);
			
			
			
			
			
		}
		
		
		private function animateSystemWarning(e:Event):void{
			
			
			var currentDate:Date = new Date();
			this.systemErrorImage.alpha	=0.6+(Math.cos(currentDate.getTime() * 0.005)) * 0.3;
			

			
			
		}
		
		
		private function allFlowsAreClosed():Boolean{
			
			var count:uint=0;
			for(var i:uint=0;i<this.currentObjectArray.length;i++){
				
				
				if(this.currentObjectArray[i].spot==true && this.currentObjectArray[i].selected==true)
				{
					count++;
					
				}
				
				
				
			}
			
			if(count==this.spotsImage.length){
				trace("todos os flows ligados");
				
				return true;
			}
			else{
				trace("nao tao todos os flows ligados");

				
				return false;
			}
			
			
		}
		private function challengeIsComplete():Boolean{
			
			// a condição é verificar se  encontra um elemento não selecionadoe
			
			
			for(var i:uint=0;i<this.currentObjectArray.length;i++)
			{
				
				
				if (this.currentObjectArray[i].selected==false){
					
					return false;
				}				
				
			}		
			
		
			challengeState=this.CHALLENGE_COMPLETE;
			trace("challenge end");
			return true;
		}
		
		
		private function redrawCell(object:Object):void{
			
			//redesenhar a celula de acordo com os novos parametros
			
			//caso nao o objetcto seja spot repoe as suas texturas
			
			if (object.selected==true){	object.image.texture=Assets.getAtlas().getTexture("cell_"+object.value+"f");	}
			else{object.image.texture=Assets.getAtlas().getTexture("cell_0");}
			
			
			
			
			
			
		}
		
		
		
		private function updateFlowsDrawing():void		
		{
			
			//apaga tudo mesmo os estilos
			var fillColor:uint = 0x08acff;
			//var fillAlpha:Number = 1;
			var strokeAlpha:Number = 1;
			var strokeThickness:uint = this.cellWidth*0.20;
			var strokeColor:int;
			var ox:uint=Math.ceil(this.tableLevelContainer.x);
			var oy:uint=Math.ceil(this.tableLevelContainer.y);
			var cx:uint;
			var cy:uint;
			var auxImage:Image;
			
			
			var auxLength:uint
			var flow:String;
			
			
			
			//trace("chega aki");
			auxLength=levelColorStrings.length;
			for(var j:uint=0;j<auxLength;j++){
				
				flow=this.levelColorStrings[j];
				flowLines[flow].graphics.clear();
				strokeColor=this.flowColors[flow];
				flowLines[flow].graphics.lineStyle(strokeThickness, strokeColor, strokeAlpha);
				
				//trace("?flow"+flow);
				
				if(flows[flow]!=undefined){
					
					for (var i:uint=0;i<flows[flow].length;i++){
						//trace("flow a");
						auxImage=flows[flow][i].image;
						cx=Math.ceil(ox+auxImage.x+auxImage.width/2);
						cy=Math.ceil(oy+auxImage.y+auxImage.height/2);
						
						if(i==0){
							//trace("moveu");
							
							flowLines[flow].graphics.moveTo(cx,cy);
						}
						else{
							
							flowLines[flow].graphics.lineTo(cx,cy);
							
							
							
						}
						
						
					}
					
				}
				
			}
			
			
			
			
			
			
			
			
		}
		
		
		private function refresh(e:Event):void
		{
		if(this.challengeState===this.PLAYING_GAME){
			
			if(this.challengeIsComplete()){
			
					this.removeEventListener(Event.ENTER_FRAME,refresh);
					
					//faz um atraso para a pessoa poder ver o quadro completo
					delayedCall=new DelayedCall(handleEndChallenge,0.6);			
					delayedCall.repeatCount=1;
					// TODO Auto Generated method stub
					Starling.juggler.add(delayedCall);
				
			}
		}
			
			
			// TODO Auto Generated method stub
			
		}
		
		private function handleEndChallenge():void
		{
			
			Starling.juggler.remove(delayedCall);
			this.removeEventListener(Event.ENTER_FRAME,refresh);
			Starling.juggler.purge();
			clearTable();
			this.newTimerBar.stopTimer();			

			
			if(Tutorial.ative==true){
				touchIndicator.visible=false;
				Tutorial.ative=false;

			
			}
			
			
			if(systemErrorImage.hasEventListener(Event.ENTER_FRAME)){				
				systemErrorImage.removeEventListeners();				

			}
			
			if(this.challengeState==this.CHALLENGE_COMPLETE){
				//coloca a pontuaçao no maximo correspondente ao spot do challenge
				PlayerStats.spotsScore[this.levelID-1][Level.currentSpotID]=3;
				
				if(Game.currentGameLevel!=Game.LAST_LEVEL_ID){
					//caso nao seja o ultimo nivel mostra a imagem de nivel seguinte
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.SHOW_LEVEL_COMPLETE},true));
				}
				else{
					//caso seja o ultimo mostra a sequencia final
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.SHOW_FINAL_CUTSCENE},true));
					
					
				}
			}
			
			if(this.challengeState==this.TIME_OUT){
				//ficou com zero pontos no challenge
				PlayerStats.spotsScore[this.levelID-1][Level.currentSpotID]=0;

				//nao desbloqueou a porta volta para onde estava
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.RESUME_LEVEL},true));
			}
			
			
			
			
			
		}
		
		private function disposeObjects():void{
			
			for(var i:uint=0;i<this.currentObjectArray.length;i++)
			{
				
				//currentObjectArray[i].image.dispose();
				tableLevelContainer.removeChild(currentObjectArray[i].image);
				
				currentObjectArray[i].index=null;
				currentObjectArray[i].value=null;
				currentObjectArray[i].image=null		
				currentObjectArray[i].selected=null;
				currentObjectArray[i].spot=null;
				currentObjectArray[i].visible=null;
				
				ObjectPool.disposeObject(currentObjectArray[i]);
				
				//currentObjectArray[i]=undefined;
				
				
				
				
				
				
			}
			
			
		}
		
		
		private function removeLines():void{
			
			var aux:String;
			
			for(var i:uint=0;i<levelColorStrings.length;i++){
				
				aux=this.levelColorStrings[i];
				flowLines[aux].graphics.clear();
				
				
				
			}
			
			
		}
		
		
		private function removeSpots():void{
			
			for(var i:uint=0;i<this.spotsImage.length;i++){
				
				this.spotsContainer.removeChild(spotsImage[i]);
				
				
			}
			
			
			
		}
		
		
		
		
		
		
		private function clearTable():void{
			
			removeTableListeners();
			removeSpots();
			removeLines();
			disposeObjects();
			
			SpritePool.disposeSprite(removeChild(tableLevelContainer) as Sprite);
			SpritePool.disposeSprite(removeChild(linesContainer) as Sprite);
			SpritePool.disposeSprite(removeChild(spotsContainer) as Sprite);
			
			
			
			
			
			
			
			
		}
		
		
		
		
		
		
	}
	
	
}

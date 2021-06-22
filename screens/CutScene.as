package screens
{
	
	
	import data.PlayerStats;
	
	import events.NavigationEvent;
	
	import org.gestouch.events.GestureEvent;
	import org.gestouch.gestures.SwipeGesture;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class CutScene extends Sprite
	{
		
		private var sequence:Image;
		private var finalCutSceneContainer:Sprite;
		private var finalBalanceContainer:Sprite;

		private var introContainer:Sprite;

		private var cutScene:Image;

		
		private var currentSequence:String;
		private var currentFrame:uint=1;
		private var numFrames:uint;

		private var swipe:SwipeGesture;

		private var currentDate:Date;
		public var	touchIndicator:Image;

		private var particle:PDParticleSystem;

		public function CutScene()
		{
			super();		
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			
			introContainer=new Sprite();
			touchIndicator=new Image(Assets.getAtlas().getTexture("hand"));
		
			introContainer.visible=false;
			this.visible=false;
	

		
			finalCutSceneContainer=new Sprite();
			finalCutSceneContainer.visible=false;
			
			finalBalanceContainer=new Sprite();
			finalBalanceContainer.visible=false;
			// TODO Auto Generated method stub
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
		

		}

		
		
		protected function onSwipeRec(event:GestureEvent):void
		{
			var swipeGesture:SwipeGesture=event.target as SwipeGesture;
			touchIndicator.visible=false;
			if (swipeGesture.offsetX>10)
			{
				if(currentFrame>1) 
				{
					currentFrame--;
					

					swipeIt();
				}
			}
			if (swipeGesture.offsetX<-10){
				
				if(currentFrame<4) {
					currentFrame++;
					swipeIt();
					
				}
				if(currentFrame==4){
					this.addEventListener(TouchEvent.TOUCH,handleTouch);
				
				}
			}
			
			
			// TODO Auto-generated method stub
			
			
		}
		
	
		private function swipeIt():void {
			var swipeTween:Tween=new Tween(introContainer,0.5);
			swipeTween.moveTo((-sequence.width*(currentFrame-1)),0);
			Starling.juggler.add(swipeTween);
		}
		
	


		private var drBright:Image;
		
		public function initialize(sequenceName:String,numFrames:uint):void{
			//fazer reset a animaçao colocando o currentFrame a 1 sempre que a cut for inicializada
			this.currentFrame=1;
			this.currentSequence=sequenceName;
			this.numFrames=numFrames;			

			if(currentSequence=="Intro"){
				
				introContainer.x=0;

				this.removeEventListener(TouchEvent.TOUCH,handleTouch);

			
				
				for(var i:uint=1;i<=4;i++){
					sequence=new Image(Assets.getTexture("Intro"+i));
					sequence.x=(i-1)*(sequence.width);
					introContainer.addChild(sequence);
					
					
					//trace("sequence");
				}
				
				
				swipe=new SwipeGesture(introContainer);
				swipe.addEventListener(GestureEvent.GESTURE_RECOGNIZED,onSwipeRec);
				
				this.addChild(introContainer);
				
				touchIndicator.touchable=false;
				touchIndicator.visible=true;
				touchIndicator.rotation=Math.PI/6;
				touchIndicator.x=stage.stageWidth*0.5;
				touchIndicator.y=stage.stageHeight*0.75;


				this.introContainer.visible=true;
				if(cutScene){cutScene.visible=false;}
				addChild(touchIndicator);

			}
			if(currentSequence!="Intro")
			{
				
			
				
				
				
				cutScene=new Image(Assets.getTexture(this.currentSequence));
				this.introContainer.visible=false;
				cutScene.visible=true;
				this.addChild(cutScene);
				this.addEventListener(TouchEvent.TOUCH,handleTouch);

				//sequence.texture=Assets.getTexture(this.currentSequence);
				
				
			}
			if(this.currentSequence=="FinalCutScene"){
				


				
				finalCutSceneContainer=new Sprite();
				drBright=new Image(Assets.getTexture("DrBright"));
				drBright.y=stage.stageHeight*0.4;
				finalCutSceneContainer.addChild(drBright);
				
				venceste=new Image(Assets.getTexture("Venceste"));
				venceste.x=stage.stageWidth*0.5-venceste.width/2;
				venceste.y=stage.stageHeight*0.1;			
				finalCutSceneContainer.addChild(venceste);				
				estasLivre=new Image(Assets.getTexture("EstasLivre"));
				
				estasLivre.x=stage.stageWidth*0.5-estasLivre.width/2;
				estasLivre.y=venceste.y+estasLivre.height+10;
				finalCutSceneContainer.addChild(estasLivre);
				
				particlesArray=new Array();
				
				particle=new PDParticleSystem(XML(new AssetsParticles.ParticleXML()),Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
				Starling.juggler.add(particle);
				
				particle.x=stage.stageWidth*0.2;
				particle.y=venceste.y+venceste.height*0.5;
				finalCutSceneContainer.addChild(particle);
				particlesArray.push(particle);
				particle.start();
				
				particle=new PDParticleSystem(XML(new AssetsParticles.ParticleXML()),Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
				Starling.juggler.add(particle);
				
				particle.x=stage.stageWidth*0.8;
				particle.y=venceste.y+venceste.height*0.5;

				
				finalCutSceneContainer.addChild(particle);
				particlesArray.push(particle);
				particle.start();
				this.addEventListener(starling.events.Event.ENTER_FRAME,updateFinalCutScene);
				finalCutSceneContainer.visible=true;
				addChild(finalCutSceneContainer);

				
			}
			
			if(this.currentSequence=="Balance"){
				
				//caso queiras por a 100%
				//PlayerStats.questPercentage=1;

				finalBalanceContainer=new Sprite();
				var balanceText:TextField=new TextField(400,150,"texto","VitesseBold",30,0xFFFFFF);
				balanceText.border=false;
				
				percText=new TextField(350,150,"100%","VitesseBold",122,0xFFFFFF);
				percText.border=false;
				percText.text=(int(Math.floor(PlayerStats.questPercentage*100)))+"%";
				trace("QUEST PERCENTAGE"+PlayerStats.questPercentage);
				percText.x=stage.stageWidth*0.38;
				percText.y=stage.stageHeight*0.27;
				finalBalanceContainer.addChild(percText);

				
				balanceText.x=stage.stageWidth*0.5-balanceText.width*0.5;
				balanceText.y=stage.stageHeight*0.5;
				
				//balanceText.vAlign=VAlign.CENTER;
				trace("PlayerStats.questPercentage"+PlayerStats.questPercentage);
				
				if(PlayerStats.questPercentage<1){
					
				balanceText.text="Conseguiste!\nMas ainda podes voltar a jogar para melhorar a tua pontuação!";
				}else{
					
					balanceText.text="Missão Cumprida!\nContinua a mostrar que és uma Mente Brilhante!";
				
				}
				
				finalBalanceContainer.addChild(balanceText);

			
			}
			
			
		}
		private function updateFinalCutScene(e:starling.events.Event):void
		{
			currentDate = new Date();
		

			
			//estasLivre.y = (stage.stageHeight*0.2) + (Math.cos(currentDate.getTime() * 0.0015)) * 10;
			estasLivre.x = (stage.stageWidth*0.5-estasLivre.width*0.5) + (Math.cos(currentDate.getTime() * 0.0015)) * 20;

			//creditsSprite.rotation=Math.cos(currentDate.getTime() * 0.002)/35;
			//containerStart.y = (stage.stageHeight*0.05) + (Math.cos(currentDate.getTime() * 0.0012)) * 10;
			
		
		
		
		}
		
		private function udpateTouchIndicator(e:starling.events.Event):void
		{
			currentDate = new Date();

			if(touchIndicator){
				touchIndicator.x = (stage.stageHeight*0.5) + (Math.cos(currentDate.getTime() * 0.0022)) * 80;
				touchIndicator.alpha=0.5-(Math.cos(currentDate.getTime() * 0.0022));
		
			
			}

			
			// TODO Auto Generated method stub
			
		}
		
		private var particlesArray:Array;
		private var drBrightTween:Tween;
		private var venceste:Image;
		private var estasLivre:Image;
		public function show():void{
			
			this.visible=true;
			LabQuest._stage.color=0x000000;
			stage.color=0x000000;
			
			if(touchIndicator && this.currentSequence=="Intro"){
			touchIndicator.addEventListener(starling.events.Event.ENTER_FRAME,udpateTouchIndicator);
			}
			
			
			//var myxml:XML=XML(new AssetsParticles.ParticleXML());
			
			if(this.currentSequence=="FinalCutScene")
			{
			
				drBrightTween= new Tween(drBright, 10, Transitions.LINEAR);
				drBrightTween.animate("y",stage.stageHeight*0.2);
				Starling.juggler.add(drBrightTween);	
				


			
			}
			if(this.currentSequence=="Balance")
			{
				finalBalanceContainer.visible=true;
				addChild(finalBalanceContainer);
				percText.text="0%";
				score=0;
				delay=0;
				this.addEventListener(starling.events.Event.ENTER_FRAME,animateScore);
			}
			


			
		}
		
		private var delay:int=0;
		private function animateScore(e:starling.events.Event):void
		{
			delay++;
			if(delay%2==0){return;}
			
			trace("animate?");
			var perc:int=(int(Math.floor(PlayerStats.questPercentage*100)));
			if(score<perc){
				score++;
				percText.text=score+"%";
			}else{
			

				removeEventListener(starling.events.Event.ENTER_FRAME,animateScore);

			}
			
			// TODO Auto Generated method stub
			
		}
		private var score:int=0;
		private var percText:TextField;
		
		public function disposeTemporarily():void{
			this.visible=false;
			if(touchIndicator){

				touchIndicator.removeEventListener(starling.events.Event.ENTER_FRAME,udpateTouchIndicator);

			}
			this.removeEventListener(TouchEvent.TOUCH,handleTouch);

			
		}
		private function handleTouch(e:TouchEvent):void{
			var touch:Touch=e.getTouch(this,TouchPhase.BEGAN);

			if(touch)
			{
				handleSequence();

			}
		
		}
		
		
		private function handleSequence() :void
		{
			//se tens toque nesta fase
				
				switch(this.currentSequence){
					
					case "Intro":
						
						
											
						
						trace("current"+this.currentFrame);
						trace("total"+this.numFrames);
						
						if(this.currentFrame==this.numFrames)
						{

							this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_LEVEL,levelID:Game.currentGameLevel,spotID:0},true));
							trace("FIIIIIIIIIIIMMMM ");
							
						}				
						
						break;
					
					
					
					case "Level1Complete":
						this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_LEVEL,levelID:Game.currentGameLevel,spotID:0},true));							
						
						break;
					
					case "Level2Complete":
						this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_LEVEL,levelID:Game.currentGameLevel,spotID:0},true));							
						
						break;
					
					
					case "Level3Complete":
						this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_LEVEL,levelID:Game.currentGameLevel,spotID:0},true));							
						
						break;
					
					case "Level4Complete":
						this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_LEVEL,levelID:Game.currentGameLevel,spotID:0},true));							
						
						break;
					
					case "BossCutScene":
						this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_CHALLENGE,levelID:Game.currentGameLevel},true));							
						
						break;
					
					
					case "FinalCutScene":
						this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.SHOW_BALANCE},true));							
						
						break;
					
					case "Balance":
						this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.GO_HOME},true));							
						
						break;
					
					
					
					
					
					
				
				
				
				
			}
		}
		
			
		
	
	}
}
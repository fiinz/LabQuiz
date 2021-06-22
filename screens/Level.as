
/**
 *
 * Nutribuddy Game
 * http://ciencia20.up.pt
 * 
 * Copyright (c) Ciencia20.
 * 
 
 *  
 */

package screens
{
	
	
	//classes de animaçao
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	
	import data.PlayerStats;
	
	import events.NavigationEvent;
	import events.TutorialEvent;
	
	import objects.BossMessage;
	import objects.FlaskMessage;
	import objects.Hero;
	import objects.HeroMessage;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.utils.VAlign;
	
	import utils.ClippedSprite;
	import utils.Tutorial;
	
	
	public class Level extends Sprite
	{
		
		
		
		private var levelID:uint;		
		private var path:LinePath2D;
		// em que spot é que cliquei
		public static var currentSpotID:uint=0;
		private var currentWayPointID:uint=0;
		private var lastSpotId:uint=2;
		private var lastSpotWayPointId:uint;
		
		
		
		
		private var tempPathPoints:Array;
		
		//private var heroIsMoving:Boolean=false;
		
		
		private var launchQuestion:Boolean=false;
		private var hero:Hero;
		
		//estados do heroi
		private var heroState:uint;	
		//parado
		private const STILL:uint=0;
		//animado
		private const MOVING:uint=1;
		
		
		
		
		//velocidade do Heroi para que seja constante
		private var heroSpeedDelay:Number;
		private const HERO_MAX_SPEED:Number=1;
		
		
		//array que guarda as imagens dos wayponts		
		private var waypointsImage:Array;
		
		// o estado de todos os spots ( em classificaçao)
		
		//a ideia é que por cada level identificamos a pontuaçao indice do spot termos uma classifi
		private var _spotState:Array;
		private var levelBackground:Image;
		private var spots:Vector.<Button>;
		
		//vai guardar os pontos do jogo
		private var levelWayPoints:Array;
		private var currentTargetWayPoint:uint;
		
		//guardar o index do ponto atual 
		private var currentIndexPoint:uint;
		private var spotProgressText:Vector.<TextField>;
		
		

		
		private var gameNumSpots:uint;
		private var gameNumQuestions:uint; 		
		private var touchIndicator:Image;
		private var newBossMessage:BossMessage;
		
		private var backBtn:Button;
		private var navMenuBtn:Button;
		private var levelMsgText:TextField;
		private var  percText:TextField;		

		public function Level()
		{
			
			super();
			this.levelID=1;
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
			
			
		}
		
		
		
		
		
		private function onAddedToStage(e:Event):void
			
		{	
			
			// TODO Auto Generated method stu
			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
			this.visible=false;
			
			
		}
		
		public function initialize(levelId:uint,spotId:uint,navigation:Boolean):void{
			
			trace("level initialize");
			this.levelID=levelId;
			setLevelWayPoints();
			trace("waypoint end");
			drawLevel();
			trace("draw level end");
			
			if(navigation==true){
				Level.currentSpotID=spotId;
				setPlayerSpotPosition(Level.currentSpotID);
			}
			else{
				trace("navigation false");
				Level.currentSpotID=-1;
				this.currentWayPointID=0;
				hero.x=this.waypointsImage[0].x;
				hero.y=this.waypointsImage[0].y;
				
			}
			
			

			if(Tutorial.ative==true ){
				trace("tutorial");
				
				this.addEventListener(TutorialEvent.TUTORIAL_PROGRESS,handleTutorial);
				touchIndicator=new Image(Assets.getAtlas().getTexture("hand"));
				touchIndicator.touchable=false;
				touchIndicator.visible=false;
				addChild(this.touchIndicator);
			}
			//this.unlockAllSpots();
			trace("level initialize end");

			
		}			
		
		private function setPlayerSpotPosition(spotId:uint):void
		{
			
			Level.currentSpotID=spotId;
			this.currentWayPointID=this.spots[currentSpotID].name;
			hero.x=this.spots[currentSpotID].x+this.spots[currentSpotID].width/2;
			hero.y=this.spots[currentSpotID].y+this.spots[currentSpotID].height/2;
			
			
		}
		
		private function unlockAllSpots():void{
			
			
			for(var i:uint=0;i<spots.length;i++){			
				
				spots[i].enabled=true;
				
			}
			
			
		}
		
		
		private function drawSpots():void{
			
			//desenha os spots
			
			var numSpots:uint=getNumOfSpots();
			var xmlAux:XML=Assets.getXMLData();
			var icon:String;
			var auxSpotButton:Button;
			//vai guardar o 
			var auxWaypointId:uint;
			
			
			spots=new Vector.<Button>();
			
			var auxText:TextField;
			
			
			for(var i:uint=0;i<numSpots;i++){
				
				
				icon=xmlAux.level.(@id==levelID).spot.(@id==i).attribute("icon");
				
				
				
				auxSpotButton=new Button(Assets.getAtlas().getTexture("icon"+icon));
				auxWaypointId=uint(icon=xmlAux.level.(@id==levelID).spot.(@id==i).attribute("waypoint"));
				auxSpotButton.x=Math.ceil(this.levelWayPoints[auxWaypointId].x-auxSpotButton.width/2);
				auxSpotButton.y=Math.ceil(this.levelWayPoints[auxWaypointId].y-auxSpotButton.height/2);
				//vai guardar o waypointId
				auxSpotButton.name=auxWaypointId.toString();
				//adiciona ao vetor de spots.
				spots.push(auxSpotButton)
				
				
				//so coloca texto nos spots de quiz
				
				if(i<(numSpots-1)){
					
					
					
					auxText=new TextField(100,30,"0","VitesseBold",24,0xFFFFFF,true);
					auxText.filter=BlurFilter.createDropShadow(2,0.785,0x1f647e,0.8,1,1);
					
					auxText.color=0xFFFFFF;
					auxText.x=auxSpotButton.x;
					auxText.y=auxSpotButton.y-22;
					this.spotProgressText.push(auxText);
					
					
				}					
				//adiciona o listener de click
				
				//aqui vai tratar do bloquei dos botoes caso nao tenha respondido ao anterior
				if(i==0){
					if(Tutorial.ative==false){
						auxSpotButton.enabled=true;
						PlayerStats.spotsState[this.levelID-1][i]=1;
					}
					
				}
					
				else{
					if(PlayerStats.spotsState[this.levelID-1][i]==1){
						
						//se nao respondeu a anterior bloqueia
						auxSpotButton.enabled=true;
					}
					else{
						auxSpotButton.enabled=false;	
						
					}
					
					
				}
				
				auxSpotButton.addEventListener(Event.TRIGGERED,onSpotClicked);

				//adiciona ao level
				this.addChild(auxSpotButton);				
				this.addChild(auxText);
				
				
				
				
				
			}
			
			
			
		}
		private function launchQuestionScreen():void{
			
			launchQuestion=true;
			
			this.clearMessages();
			
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_QUESTION,spotId:Level.currentSpotID},true));
			
		}
		
		
		
		private function getNumOfSpots():uint{
			
			//obtem o numero de spots por nivel
			
			var auxNumOfSpots:uint;
			var xmlAux:XML=Assets.getXMLData();
			
			auxNumOfSpots=xmlAux.level.(@id==levelID).spot.length();
			
			
			return auxNumOfSpots;
		}
		
		private function setLevelWayPoints():void{
			
			//obter e fazer o set das posiçoes dos Waypoints do atual level
			var xmlAux:XML=Assets.getXMLData();
			//guardar no vetor de pontos as coordenadas
			levelWayPoints=new Array();
			var auxPercX:Number;
			var auxPercY:Number;
			
			//quantos waypoints existem ?
			var numLevelWaypoints:uint=uint(xmlAux.level.(@id==levelID).waypoints.waypoint.length());
			//calcular a posiçao de cada um dos waypoints
			for(var i:uint=0;i<numLevelWaypoints;i++){
				
				//obtem as coordenadas relativas de cada waypoint
				auxPercX=Number(xmlAux.level.(@id==levelID).waypoints.waypoint[i].attribute("x"));
				auxPercY=Number(xmlAux.level.(@id==levelID).waypoints.waypoint[i].attribute("y"));
				//passa para o vetor as coordenadas de todos os waypoints
				levelWayPoints.push(new Point(Math.ceil(stage.stageWidth*auxPercX),Math.ceil(stage.stageHeight*auxPercY)));
				
			}
			
			
			
			
			
		}
		
		private function createWayPointsImage():void{
			// função que cria os circulos do caminho
			
			waypointsImage=new Array();
			for(var i:uint=0;i<(this.levelWayPoints.length*3);i++){
				
				waypointsImage.push(new Image(Assets.getAtlas().getTexture("waypoint")));
				
				waypointsImage[i].alpha=0.3;
				this.addChild(waypointsImage[i]);
			}
			
			
		}
		
		private function createLevelPathFromWaypoints():void{


			path=new LinePath2D(this.levelWayPoints,0,0);		
			trace("path created");
			createWayPointsImage();
			trace("waypoints created");
			path.distribute(waypointsImage as Array,0,1,false);
			path.removeAllFollowers();	
			
			
			
		}
		private function moveHero(wayPointId:uint):void{
			//move o heroi em direção a um waypoint ID
			
			
			
			
			//tempPath guarda o slice do caminho que o heroi faz
			var tempPath:LinePath2D;
			currentTargetWayPoint=wayPointId;
			
			//garrantir que sao diferentes , so ha animaçao se forem diferentes e quando o heroi está parado
			
			if(currentWayPointID!=wayPointId && this.heroState==STILL){
				
				// para extrair parte do vetor é necessario saber qual o sentido que o heroi vai-se movimentar e extrair a informaçao do vetor
				if(currentWayPointID<wayPointId){
					//tempPathPoints é o vetor que vai ser usado para 
					tempPathPoints=this.levelWayPoints.slice(this.currentWayPointID,wayPointId+1);
				}
				else
				{
					//faz reverse quando o heroi em vez de subir desce
					tempPathPoints=this.levelWayPoints.slice(wayPointId,this.currentWayPointID+1);
					tempPathPoints.reverse();
					
				}
				
				//calcular angulo
				
				
				
				tempPath=new LinePath2D(tempPathPoints);
				tempPath.addFollower(hero,0);
				
				onHeroPathUpdate();
				
				
				//arranjar uma variavel para que a velocidade seja sempre a mesma
				
				
				//for(var i:uint=this.currentWayPoint;i<
				
				//=new LinePath2
				
				
			}
			
			var dx:Number;
			var dy:Number;
			var distance:Number=0;
			
			dx = tempPathPoints[0].x-tempPathPoints[tempPathPoints.length-1].x;
			dy = tempPathPoints[0].y-tempPathPoints[tempPathPoints.length-1].y;
			distance+=Math.abs(Math.sqrt(dx * dx + dy * dy));
			
			
			
			
			TweenMax.to(tempPath,distance*0.01+tempPathPoints.length*0.3,{progress:1,ease:Linear.easeNone, onComplete:onHeroPathComplete, onUpdate:onHeroPathUpdate});
			heroState=MOVING;
			
		}
		private function onHeroPathUpdate():void{
			
			//trace("hero path update");
			//trace("qual o state"+hero.heroState);
			var radiusTolerance:Number=10.0;
			
			for(var i:uint=0;i<tempPathPoints.length-1;i++){
				
				
				//hipotenusa.
				
				var widthAux:Number=hero.x - this.tempPathPoints[i].x;
				var heightAux:Number=hero.y - this.tempPathPoints[i].y;
				
				
				var distance:Number=Math.sqrt(Math.pow(widthAux,2)+Math.pow(heightAux,2));
				//trace("distance"+distance);
				if ( distance <radiusTolerance){
					
					
					
					
					
					
					
					var x1:Number,x2:Number,y1:Number,y2:Number;
					var deltaX:Number,deltaY:Number;
					deltaX=tempPathPoints[i].x-tempPathPoints[i+1].x;
					deltaY=tempPathPoints[i].y-tempPathPoints[i+1].y;
					
					
					var auxAngle:Number=Math.atan2(deltaY,deltaX);
					
					
					if(Math.abs(Math.cos(auxAngle))>Math.abs(Math.sin(auxAngle))){
						if(Math.cos(auxAngle)<0)
						{
							hero.changeAnimationState(Hero.RIGHT);
						}
						else if(Math.cos(auxAngle)>0)
						{
							hero.changeAnimationState(Hero.LEFT);
						}
					}
					else{
						if(Math.sin(auxAngle)<0){
							hero.changeAnimationState(Hero.DOWN);
						}
						else if ((Math.sin(auxAngle)>0))
						{
							hero.changeAnimationState(Hero.UP);
							
						}
					}
					
					
					
					
					
					
				}
				
			}
			
			
			
		}
		
		
		
		//frasco com pontuação
		private var flaskClippedSprite:ClippedSprite;
		//private var emptyFlask:Image;
		private var emptyFlask:Button;
		private	var fullFlaskImage:Button
		//private var flaskSprite:Sprite;
		
		private var newFlaskMessage:FlaskMessage;
		private function onInterfaceClick(e:Event):void{
			
			trace("on Interface Click");
			
			
				
				
			if (!Sounds.muted && Game.isActive){
				Sounds.sndFxMenu.play();
			}
			if(heroState==MOVING){return;}
			var buttonClicked:Button=e.target as Button;
			//caso tenha sido o button startButton
			if(newFlaskMessage!=null){
			if(newFlaskMessage.status==true){

				return;}
			}
			if(((buttonClicked as Button)==this.emptyFlask || (buttonClicked as Button)==this.fullFlaskImage) ){

				newFlaskMessage=new FlaskMessage("Tens de acertar, pelo menos, a 60% das perguntas para enfrentares o Dr. Cell no desafio final!",1);
				newFlaskMessage.x=this.emptyFlask.x+stage.stageWidth*0.1;
				newFlaskMessage.y=this.emptyFlask.y-stage.stageWidth*0.3;
			//	newFlaskMessage.initialize();
				addChild(newFlaskMessage);

				newFlaskMessage.show();
				trace("flask");
				
				
			
			}
			
			
			if((buttonClicked as Button )==backBtn){
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.GO_HOME},true));
				
				//ao fazer o dispatch o game está à escuta deste evento e comunica que é necessário mudar de ecrã e vai para o ecra level
				//	this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.GO_HOME},true));
				
				
			}
			
			if((buttonClicked as Button )==navMenuBtn){
				//ao fazer o dispatch o game está à escuta deste evento e comunica que é necessário mudar de ecrã e vai para o ecra level
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.GO_NAVIGATION_MENU},true));
				
				
			}
			
		}
		
		private function onSpotClicked(e:Event):void{
			
			//so processa cliques quando a char nao esta a mover
			if(heroState==STILL){
				
				
				if (!Sounds.muted && Game.isActive){
					Sounds.sndFxMenu.play();
				}
				var auxButton:Button=e.target as Button;
				var oldSpot:int;
				
				// atraves do nome obtenho o waypoint onde ele ficou
				
				
				//quero saber o indice do spot clicado
				
				for(var i:uint=0;i<this.spots.length;i++){
					
					if(this.spots[i]==auxButton)
					{
						
						oldSpot=Level.currentSpotID;
						Level.currentSpotID=i;
						break;		
						
					}				
					
				}
				
				// clicaste no ultimo spot do ultimo nivel ?
				if(Level.currentSpotID==this.lastSpotId && this.levelID==Game.LAST_LEVEL_ID ){
					
					//tens os requisitos minimos ?
					if(PlayerStats.questPercentage>=Game.LAST_LEVEL_REQ_PERCENTAGE){
						
						//entao lança o ultimo desafio
						this.launchChallengeScreen();
						
						
						
					}else
					{
						//nao tens os requisitos
						if(newBossMessage && newBossMessage.status==true){return;}
						if(!Sounds.muted){
							//o boss ri-se
							Sounds.sndFxBossMessageNegative.play();
						}
						
						// e envia mensagem
						newBossMessage=new BossMessage(this.levelID,BossMessage.PERCENTAGE_REQ_FEEDBACK);
						addChild(newBossMessage);
						newBossMessage.show();
						
						
						
					}
					
					return;
					
				}
				
				//como em cima faz return 
				
				//carreguei no mesmo spot onde estava ?
				if(oldSpot==Level.currentSpotID)
				{
					
					//é o ultimo do challenge ?
					if(Level.currentSpotID==this.lastSpotId){this.launchChallengeScreen();}
					else{this.launchQuestionScreen();}			
					
					
					
				}
				else{
					
					//ok se for diferente tenho que deslocar a personagem e guardar o id do spot para depois saber se lanço pergunta ou challenge
					if(Level.currentSpotID==this.lastSpotId){	
						
						lastSpotWayPointId=uint(auxButton.name);					
						
					}
					
					moveHero(uint(auxButton.name));
					
					
				}
				
				
				
				
				
				
				
				
				
			}
			
			
			
			
		}
		
		
		
		
		
		private function clearMessages():void{
			
			
			if(newBossMessage){
				removeChild(newBossMessage);
				newBossMessage.hide();
			}
			
			if(newBossCustomMessage){
				
				removeChild(newBossCustomMessage);
				newBossCustomMessage.hide();
			}
			if(newHeroMessage){
				removeChild(newHeroMessage);
				newHeroMessage.hide();
				
				
			}
			
			
		}
		
		private function launchChallengeScreen():void
		{
			
			// TODO Auto Generated method stub
			
			
			clearMessages();
			
			if(Tutorial.ative==true){
				
				PlayerStats.spotsState[this.levelID-1][2]=1;
				
				
			}
			if(Game.currentGameLevel<Game.LAST_LEVEL_ID)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_CHALLENGE},true));
			}
			else{
				
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.SHOW_BOSS_CUTSCENE},true));
				
				
			}
			
			
		}
		public function onHeroPathComplete():void{
			
			//atualiza o currentWayPoint para aquele que era o Target
			this.currentWayPointID=this.currentTargetWayPoint;
			//deixa de mover o heroi
			
			heroState=STILL;
			hero.changeAnimationState(Hero.STILL);
			
			//lançar nova questao ou challenge caso o ID do spotWayPointId ser o último
			if(this.currentTargetWayPoint==this.lastSpotWayPointId){launchChallengeScreen();}
			else{launchQuestionScreen();}
		}
		
		public function show():void{
			
			trace("level show");

			this.addEventListener(Event.ENTER_FRAME,refresh);
			
			Game.started=true;			
			LabQuest._stage.color=0xa79e95;
			
			this.visible=true;
			updateSpotTextScore();
			
			hero.addAnimation();
			
			
			
			PlayerStats.updateQuestScore();
			updateFlask();
			Sounds.currentMusic=Sounds.sndBgLevel;
			levelMsgText.text="Nível: 0"+Game.currentGameLevel;
			
			if(!Sounds.muted &&Game.isActive){
				if(Sounds.state!=Sounds.MUSIC_LEVEL){
					SoundMixer.stopAll();
					
					Sounds.musicChannel=Sounds.currentMusic.play(0,999);
					Sounds.state=Sounds.MUSIC_LEVEL;
				}
				
				
				
				if(Game.previousState==Game.ST_QUESTION){
					if(Question.countCorrect==3){
						Sounds.sndFx3CorrectAwnsers.play();
					}
					
					
					
					
					
					
					
				}	
				
				updateLevelSpotsState();
				
				if(Tutorial.ative==true)
				{
					
					
					
					
					handleTutorial(null);
					//Tutorial.state=Tutorial.BOSS_SPOT2_AWNSERED;
					//updateTutorial();
					
					
					
					
					
					
				}
				//				if(this.tutorialMode==true){handleTutorial(null);}	 
				
			}
			
			updateLevelSpotsState();
			//unlockAllSpots();
			
			
			//nao deve tar aqui so para debug
			
		}
		
		private var targetAnimatedSpotID:uint;
		private var steplocked:Boolean=false;
		private var newHeroMessage:HeroMessage;		
		private var newBossCustomMessage:BossMessage;
		
		private function handleTutorial(e:Event):void{
			
			if(newBossCustomMessage){
				newBossCustomMessage.hide();
			}
			if(newHeroMessage){
				newHeroMessage.hide();
			}
			
			if(Game.previousState==Game.ST_INTRO || Game.previousState==Game.ST_NAVIGATION_MENU)
				
			{
				
				if(Tutorial.state==Tutorial.BEGIN){
					this.spots[0].enabled=false;
					this.spots[1].enabled=false;
					this.spots[2].enabled=false;
					
					
					
					Tutorial.state=Tutorial.HERO_INTRO_MESSAGE;
					updateTutorial();
					return;
				}
				
				if(Tutorial.state==Tutorial.HERO_INTRO_MESSAGE){
					Tutorial.state=Tutorial.BOSS_INTRO_MESSAGE;
					updateTutorial();
					return;
					
					
				}
				
				if(Tutorial.state==Tutorial.BOSS_INTRO_MESSAGE){
					this.spots[0].enabled=true;
					PlayerStats.spotsState[this.levelID-1][0]=1;
					
					Tutorial.state=Tutorial.HIGHLIGHT_FIRST_QUESTION;
					updateTutorial();
					return;
					
					
				}
				
				
			}
			
			
			if(Game.previousState==Game.ST_QUESTION)
				
			{
				
				
				
				if(Question.countCorrect==0){
					
					if(Tutorial.state==Tutorial.HIGHLIGHT_FIRST_QUESTION){
						
						Tutorial.state=Tutorial.BOSS_SPOT1_ALL_WRONG;
						updateTutorial();
						return;
					}
				}
				else{
					
					if(Tutorial.state==Tutorial.HIGHLIGHT_FIRST_QUESTION || Tutorial.state==Tutorial.BOSS_SPOT1_ALL_WRONG)
					{
						
						Tutorial.state=Tutorial.BOSS_SPOT1_AWNSERED;
						updateTutorial();
						trace("tutorial awnsered");
						return;
						
						
						
						
					}
					if(Tutorial.state==Tutorial.HIGHLIGHT_SECOND_QUESTION && Level.currentSpotID==1){
						this.spots[1].enabled=true;
						PlayerStats.spotsState[this.levelID-1][1]=1;
						
						Tutorial.state=Tutorial.BOSS_SPOT2_AWNSERED;
						updateTutorial();
						return;
						
						
					}
					
					
					
					
				}
			}
			if(Tutorial.state==Tutorial.BOSS_SPOT1_AWNSERED){
				
				Tutorial.state=Tutorial.HERO_SPOT1_REPLY;
				updateTutorial();
				return;
				
			}
			
			if(Tutorial.state==Tutorial.HERO_SPOT1_REPLY){
				
				Tutorial.state=Tutorial.HIGHLIGHT_SECOND_QUESTION;
				updateTutorial();
				return;
				
			}
			
			if(Tutorial.state==Tutorial.BOSS_SPOT2_AWNSERED){
				
				this.spots[2].enabled=true;
				PlayerStats.spotsState[this.levelID-1][2]=1;
				
				Tutorial.state=Tutorial.HIGHLIGHT_CHALLENGE;
				updateTutorial();
				return;
				
			}
			
			
			
			
			
			
			
			
			
			
			
		}
		private function updateTutorial():void
		{
			
			if(newBossCustomMessage){
				newBossCustomMessage.hide();
			}
			if(newHeroMessage){
				newHeroMessage.hide();
			}
			
			
			
			/*if(this.tutorialMode==true){
			
			if(Game.previousState==Game.ST_QUESTION){
			
			if(this.tutorialMode==true)
			{
			if(Question.countCorrect==0 && steplocked==false)
			{
			
			newBossCustomMessage=new BossMessage(this.levelID,BossMessage.TUTORIAL_MESSAGE);
			addChild(newBossCustomMessage);
			newBossCustomMessage.showCustomMessage("Ahahaha! Eu sabia que não eras assim tão inteligente! Não vale apena voltares a tentar!!");
			steplocked=true;
			return;
			}
			if(Question.countCorrect>=0){steplocked=false;}
			}
			}
			*/
			
			switch(Tutorial.state){
				
				
				
				case Tutorial.HERO_INTRO_MESSAGE:
					targetAnimatedSpotID=0;
					
					newHeroMessage=new HeroMessage("Hmmmm...E agora, como é que eu saio daqui?!",HeroMessage.RIGHT);
					newHeroMessage.x=hero.x;
					newHeroMessage.y=hero.y-hero.height*2.5;
					addChild(newHeroMessage);
					newHeroMessage.show();
					
					break;
				
				case Tutorial.BOSS_INTRO_MESSAGE:
					removeChild(newHeroMessage);
					if(!Sounds.muted && Game.isActive){
						Sounds.sndFxBossMessageNegative.play();
					}
					newBossCustomMessage=new BossMessage(this.levelID,BossMessage.TUTORIAL_MESSAGE);
					addChild(newBossCustomMessage);
					newBossCustomMessage.showCustomMessage("Nunca conseguirás sair daqui! Preparei perguntas e desafios muito difíceis! Uahahah!");
					trace("segundo step");
					break;
				
				
				case Tutorial.HIGHLIGHT_FIRST_QUESTION:
					this.spots[0].alpha=1;
					removeChild(newBossCustomMessage);
					touchIndicator.visible=true;
					touchIndicator.x=this.spots[targetAnimatedSpotID].x+this.spots[targetAnimatedSpotID].width/2 ;
					touchIndicator.y=this.spots[targetAnimatedSpotID].y+this.spots[targetAnimatedSpotID].height/2;
					break;
				
				case Tutorial.BOSS_SPOT1_AWNSERED:
					if(!Sounds.muted && Game.isActive){
						Sounds.sndFxBossMessageNegative.play();
					}
					targetAnimatedSpotID=1;
					
					touchIndicator.visible=false;
					newBossCustomMessage=new BossMessage(this.levelID,BossMessage.TUTORIAL_MESSAGE);
					addChild(newBossCustomMessage);
					newBossCustomMessage.showCustomMessage("Veremos o que conseguirás fazer nos próximos desafios! Uahaha!");
					
					
					break;
				
				case Tutorial.HERO_SPOT1_REPLY:
					
					
					
					removeChild(newBossCustomMessage);
					
					newHeroMessage=new HeroMessage("Já analisei o sistema! Tenho que responder corretamente pelo menos a 60% de todas perguntas!",HeroMessage.LEFT);
					newHeroMessage.x=hero.x;
					newHeroMessage.y=hero.y-hero.height*2.5;
					
					
					addChild(newHeroMessage);
					newHeroMessage.show();
					
					break;
				
				case Tutorial.BOSS_SPOT1_ALL_WRONG:
					
					if(!Sounds.muted && Game.isActive){
						Sounds.sndFxBossMessageNegative.play();
					}
					touchIndicator.visible=false;
					newBossCustomMessage=new BossMessage(this.levelID,BossMessage.TUTORIAL_MESSAGE);
					addChild(newBossCustomMessage);
					newBossCustomMessage.showCustomMessage("Uahah! Nem a uma única pergunta conseguiste responder!!! Nunca conseguirás prosseguir!");
					
					break;
				
				
				
				
				case Tutorial.HIGHLIGHT_SECOND_QUESTION:
					
					this.spots[1].alpha=1;
					this.spots[1].enabled=true;
					PlayerStats.spotsState[this.levelID-1][1]=1;
					removeChild(newHeroMessage);
					touchIndicator.visible=true;
					this.targetAnimatedSpotID=1;
					
					touchIndicator.x=this.spots[targetAnimatedSpotID].x+this.spots[1].width/2 ;
					touchIndicator.y=this.spots[targetAnimatedSpotID].y+this.spots[1].height/2;
					
					emptyFlask.alpha=1;
					emptyFlask.filter.dispose();
					emptyFlask.filter=null;
					
					
					break;
				
				case Tutorial.BOSS_SPOT2_AWNSERED:
					if(!Sounds.muted && Game.isActive){
						Sounds.sndFxBossMessageNegative.play();
					}
					touchIndicator.visible=false;
					newBossCustomMessage=new BossMessage(this.levelID,BossMessage.TUTORIAL_MESSAGE);
					addChild(newBossCustomMessage);
					newBossCustomMessage.showCustomMessage("Uhahaha! As portas das salas estão bloqueadas com um código de cores e tu não as conseguirás ligar!");
					
					break;
				
				case Tutorial.HIGHLIGHT_CHALLENGE:
					
					this.spots[2].alpha=1;
					
					this.targetAnimatedSpotID=2;
					removeChild(newBossCustomMessage);
					touchIndicator.visible=true;						
					touchIndicator.x=this.spots[targetAnimatedSpotID].x+this.spots[2].width/2 ;
					touchIndicator.y=this.spots[targetAnimatedSpotID].y+this.spots[2].height/2;
					
					
					break;
				
				
				
				
				
				
				
				
				
				
			}
			// TODO Auto Generated method stub
			
		}		
		
		private function refresh(e:Event):void{
			
			if(Tutorial.ative==true){
				updateHeroMessagePos();
				
				if(Tutorial.state==Tutorial.BOSS_INTRO_MESSAGE || Tutorial.state==Tutorial.BOSS_SPOT1_AWNSERED){
					
					animateSpot();
					
				}
				if(Tutorial.state==Tutorial.HIGHLIGHT_FIRST_QUESTION || Tutorial.state==Tutorial.HIGHLIGHT_SECOND_QUESTION ||  Tutorial.state==Tutorial.HIGHLIGHT_CHALLENGE){
					
					
					animateTouchIndicator();
				}
				if(Tutorial.state==Tutorial.HERO_SPOT1_REPLY){
					animateFlask();
				}
				
			}
			
			
			
			
			
			
			
		}
		
		private function updateHeroMessagePos():void
		{
			if(newHeroMessage)
			{
				newHeroMessage.x=hero.x;
				newHeroMessage.y=hero.y-hero.height*2.5;
				
			}
			
			// TODO Auto Generated method stub
			
		}
		private function animateTouchIndicator():void{
			
			
			var currentDate:Date = new Date();
			touchIndicator.x+=(Math.cos(currentDate.getTime() * 0.002))*0.2 ;
			touchIndicator.y+= (Math.cos(currentDate.getTime() * 0.002))*0.2;
		}
		private function animateFlask():void{
			var currentDate:Date = new Date();
			
			emptyFlask.alpha=0.6+(Math.cos(currentDate.getTime() * 0.003)) * 0.3;
			emptyFlask.filter=BlurFilter.createGlow(0xFF6600,0.7,2,1);
		}
		private function animateSpot():void{
			
			var currentDate:Date = new Date();
			this.spots[this.targetAnimatedSpotID].alpha	=0.4+(Math.cos(currentDate.getTime() * 0.003)) * 0.3;
			
		}
		
		
		
		private function updateLevelSpotsState():void{
			
			//update dos estados / icons de cada spot
			
			trace("update LEVEL SPOTS");
			var aux:Number;
			for(var i:uint=0;i<this.spots.length;i++){
				
				//se o i não for o primeiro spot
				
				
				// acertou as 3 de cada spot
				if(int(PlayerStats.spotsScore[this.levelID-1][i])==3){
					
					if(launchQuestion==true && i==Level.currentSpotID && levelID>=2){
						
						aux=Math.random();
						if(aux<((levelID-1)*0.25)){
							
							
							newBossMessage=new BossMessage(this.levelID,BossMessage.POSITIVE_FEEDBACK);
							addChild(newBossMessage);
							newBossMessage.show();
							
							
							
							
							
							
						}
						
						
						
					}
					spots[i].upState=Assets.getAtlas().getTexture("icon3");
					spots[i].downState=Assets.getAtlas().getTexture("icon3");
					
					
					
				}
				else{
					trace("else spot inferior e no nivel");
					if(launchQuestion==true && i==Level.currentSpotID && levelID>=2){
						aux=Math.random();
						if(aux<((levelID-1)*0.25)){
							
							newBossMessage=new BossMessage(this.levelID,BossMessage.NEGATIVE_FEEDBACK);
							addChild(newBossMessage);
							
							newBossMessage.show();
						}
						
						
					}
					
					
					
				}
				
				if(i==0){
					
					if(Tutorial.ative==false){
						PlayerStats.spotsState[this.levelID-1][i]=1;
						spots[i].enabled=true;
					}
					
				}
				
				if(i!=0){
					// verifica se pode desbloquear o spot seguinte mas tem de garantir que o seguinte não foi já feito e que nao seja o 
					if(int(PlayerStats.spotsScore[this.levelID-1][i-1])>0 && int(PlayerStats.spotsScore[this.levelID-1][i])==0) {
						
						if(Tutorial.ative==false){
							
							
							PlayerStats.spotsState[this.levelID-1][i]=1;
							spots[i].enabled=true;
						}
						else{
							
							
							if(PlayerStats.spotsState[this.levelID-1][i]==1){
								spots[i].enabled=true;
							}
							
							
						}
						
						
						/*if(Tutorial.ative==true){
						
						
						
						*/
						
						
						
						
						
						
						
					}
					
					
					
				}
			}
			
			launchQuestion=false;
			
		}
		private function updateSpotTextScore():void{
			
			// faz update do score
			
			
			for(var i:uint=0;i<(this.spots.length-1);i++){
				
				this.spotProgressText[i].text=String(PlayerStats.spotsScore[this.levelID-1][i]+"/3");
				//se o i não for o primeiro spot
				
				
				
			}
			
			
			
		}
		
		public function drawBackground(name:String):void{
			
			levelBackground=new Image(Assets.getTexture(name));
			this.addChild(levelBackground);
			
		}
		
		private function drawHero():void{
			
			hero=new Hero();
			hero.touchable=false;
			//o heroi fica no waypoint 0
			hero.x=Math.ceil(levelWayPoints[0].x-hero.width/2);
			hero.y=Math.ceil(levelWayPoints[0].y-hero.height/2);
			heroSpeedDelay=0.8;
			this.addChild(hero);
			
			
		}

		private function drawInterface():void{
			
			backBtn=new Button(Assets.getAtlas().getTexture("btn_back_on"));
			navMenuBtn=new Button(Assets.getAtlas().getTexture("btn_menu_on"));
			
			navMenuBtn.x=-10;
			backBtn.x=-10;
			backBtn.y=stage.stageHeight*0.1;
			navMenuBtn.y=backBtn.y+backBtn.height*0.75;
			navMenuBtn.addEventListener(Event.TRIGGERED,onInterfaceClick);
			backBtn.addEventListener(Event.TRIGGERED,onInterfaceClick);
			
			
			this.addChild(backBtn);
			this.addChild(navMenuBtn);
			
			levelMsgText=new TextField(stage.stageWidth*0.3,24,"Nível: 01","VitesseBold",24,0x0);
			levelMsgText.border=false;
			levelMsgText.color=0xFFFFFF;
			levelMsgText.vAlign=VAlign.CENTER;
			levelMsgText.x=stage.stageWidth-levelMsgText.width*1.1;
			levelMsgText.y=stage.stageHeight*0.03;
			levelMsgText.alpha=0.8;
			this.addChild(levelMsgText);
			
			
			
		}
		private function drawFlask():void{
			
			
			//emptyFlask=new Image(Assets.getAtlas().getTexture("flask_empty"));
			emptyFlask=new Button(Assets.getAtlas().getTexture("flask_empty"));
			emptyFlask.scaleWhenDown=1;
			
			//emptyFlask.filter=BlurFilter.createGlow(0x000000,0.8,10,0.8);
			emptyFlask.x=Math.ceil(stage.stageWidth*0.05);
			emptyFlask.y=Math.ceil(stage.stageHeight*0.79);
			emptyFlask.touchable=true;

			emptyFlask.addEventListener(Event.TRIGGERED,onInterfaceClick);

			
			
			flaskClippedSprite= new ClippedSprite();
			flaskClippedSprite.touchable=false;
			flaskClippedSprite.x=emptyFlask.x;
			flaskClippedSprite.y=emptyFlask.y;
			
			fullFlaskImage=new Button(Assets.getAtlas().getTexture("flask_full"));
			fullFlaskImage.touchable=true;
			fullFlaskImage.addEventListener(Event.TRIGGERED,onInterfaceClick);

			//centrar o objeto
			//atenção que o fullFlask enquanto nao tem a imagem dentro nao tem dimensoes entao uso as do fullFlaskIMage para dar as coordenadas
			flaskClippedSprite.clipRect=new Rectangle(emptyFlask.x,emptyFlask.y,emptyFlask.width,emptyFlask.height);	
			flaskClippedSprite.addChild(fullFlaskImage);
			//trace("porra do frasco");
			flaskClippedSprite.clipRect.height=emptyFlask.height*0.01;
			flaskClippedSprite.clipRect.y=(emptyFlask.y+emptyFlask.height)-flaskClippedSprite.clipRect.height;
			
			//necessário uma sprite para poder rodar tudo
			
			
			percText=new TextField(100,100,"0%","VitesseBold",Math.ceil(24));
			//percText.filter=BlurFilter.createDropShadow(2,0.785,0x0,0.8,1,1);
			percText.touchable=false;
			percText.color=0xFFFFFF;
			percText.alpha=0.5;
			percText.x=emptyFlask.x+emptyFlask.width/2-percText.width/2;
			percText.y=emptyFlask.y+emptyFlask.height*0.84;
			
			
			
			this.addChild(emptyFlask);
			this.addChild(flaskClippedSprite);
			this.addChild(percText);
			
			
		}
		private function updateFlask():void{
			
			
			//trace("porra do frasco updated");
		//	PlayerStats.questPercentage=1;
			flaskClippedSprite.clipRect.height=emptyFlask.height*0.01+(emptyFlask.height*(PlayerStats.questPercentage*0.6));
			flaskClippedSprite.clipRect.y=(emptyFlask.y+emptyFlask.height)-flaskClippedSprite.clipRect.height;
			percText.text=Math.floor(PlayerStats.questPercentage*100).toFixed(0)+"%";
			
		}
		private function drawLevel():void{
			
			//trace("o que ficou no drawlevel"+levelID);
		

			drawBackground("Level"+levelID+"Background");
			trace("back done");
			//desenhar as caixas de texto da pontuaçao
			spotProgressText=new Vector.<TextField>();
			trace("spot progress done");
			
			// fazer o set dos waypoints
			
			// colocar 
			createLevelPathFromWaypoints();
			trace("created waypoints path");
			
			drawSpots();
			trace("spots");
			drawHero();
			drawFlask();
			drawInterface();
			
			
			
			
			
		}
		
		
		
		public function disposeTemporarily():void{
			this.visible=false;
			this.removeEventListener(Event.ENTER_FRAME,refresh);
			
			
			
		}
		
		
		
	}
}
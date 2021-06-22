package screens
{
	
	import flash.media.SoundMixer;
	
	import data.PlayerStats;
	
	import events.NavigationEvent;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.ImagePool;


	public class NavigationMenu extends Sprite
	{
		
		private var background:Image;
		private var tableLevelsImg:Image;
		private var labQuestImg:Image;
		private var newGameBtn:Button;
		private var continueBtn:Button;
		private var tableContainer:Sprite;
		private var objects:Vector.<Object>;




		public function NavigationMenu()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
		}
		
		
		private function onAddedToStage(e:Event):void{
		
			this.visible=false;
			
			drawNavigationMenu();
						

		
		}
		
		
		//obter o botao associado ao objeto
		
		private function getObjectFromButton(button:Button):Object{
			
			var aux:Object;

			for( var i:uint=0;i<this.objects.length;i++){

				if(objects[i].btn==button){
					aux=objects[i];
				
				}
			
			}
		
			return aux;
		}
		
	
	 //desenhar o background
		private function drawBackground():void{
			
			tableContainer=new Sprite();


			tableLevelsImg=ImagePool.getImage();  
			tableLevelsImg.touchable=false;
			tableLevelsImg.texture=Assets.getAtlas().getTexture("table_levels");
			tableLevelsImg.readjustSize();
			

			
			labQuestImg=ImagePool.getImage();
			labQuestImg.touchable=false;
			labQuestImg.texture=Assets.getAtlas().getTexture("lab_quest");
			labQuestImg.readjustSize();			
			labQuestImg.x=Math.ceil(stage.stageWidth/2-labQuestImg.width/2);
			labQuestImg.y=Math.ceil(stage.stageHeight*0.01);

			tableContainer.y=Math.ceil(stage.stageHeight*0.22);
			tableContainer.addChild(tableLevelsImg);
			
			tableContainer.addChild(tableLevelsImg);
			tableContainer.x=Math.ceil(stage.stageWidth*0.5-tableContainer.width/2);
			this.addChild(tableContainer);
			
			this.addChild(labQuestImg);

		}
		
		private function disposeTemporarily():void{
		
		
			
			this.visible=false;
			
		
		}
		private function drawNavigationMenu():void
		{
			drawBackground();
			drawSpots();
			drawInterface();
			

			
			
		}
		
		private function drawInterface():void
		{
		
			continueBtn=new Button(Assets.getAtlas().getTexture("btn_continuar"));
			continueBtn.y=Math.ceil(stage.stageHeight*0.72);
			continueBtn.x=Math.ceil(stage.stageWidth*0.5-continueBtn.width/2);
			
			newGameBtn=new Button(Assets.getAtlas().getTexture("btn_new_game"));
			newGameBtn.y=Math.ceil(continueBtn.y+continueBtn.height*0.25);
			newGameBtn.x=stage.stageWidth*0.5-newGameBtn.width/2;
			
			newGameBtn.addEventListener(Event.TRIGGERED,onInterfaceClick);
			continueBtn.addEventListener(Event.TRIGGERED,onInterfaceClick);

			
				
			addChild(newGameBtn);
			addChild(continueBtn);

			
			
		}
		private function updateSpots():void{
		
		var auxlength:uint=this.objects.length;
		var auxlevel:uint;
		var auxspot:uint;
		
		for(var i:uint=0;i<auxlength;i++){
			auxlevel=objects[i].levelID-1;
			auxspot=objects[i].spotID;
			
			if(PlayerStats.spotsScore[auxlevel][auxspot]==3){
				objects[i].btn.upState=Assets.getAtlas().getTexture("icon3");
				objects[i].btn.downState=Assets.getAtlas().getTexture("icon3");
				
				//	PlayerStats.spotsState[auxlevel][auxspot]=1;
					objects[i].btn.enabled=true;
			
					
				

			
			}
			else{
			
				if(auxspot<2){
					objects[i].btn.upState=Assets.getAtlas().getTexture("icon1");
					objects[i].btn.downState=Assets.getAtlas().getTexture("icon1");

				
				}
				else{
					objects[i].btn.upState=Assets.getAtlas().getTexture("icon2");
					objects[i].btn.downState=Assets.getAtlas().getTexture("icon2");

				
				
				}
				if(	PlayerStats.spotsState[auxlevel][auxspot]==1){
					
					objects[i].btn.enabled=true;
					//trace("o botao ficou em true");

				
				}else{
					//trace("o botao ficou em false");
				
					objects[i].btn.enabled=false;
					//objects[i].btn.enabled=true;
				
				}

			
			
			}
			
		
		}
		
		
		}
		private function drawSpots():void{
			
			var auxButton:Button;
			
			var obj:Object;

			this.objects=new Vector.<Object>();
			trace(PlayerStats.spotsScore);
			
			for(var level:uint=0; level<Game.LAST_LEVEL_ID;level++){
				
				for(var spot:uint=0;spot<3;spot++){
					
					
					obj=new Object();
					//trace("spots"+PlayerStats);

					if(PlayerStats.spotsScore[level][spot]==3){
						auxButton=new Button(Assets.getAtlas().getTexture("icon3"));
					}
					else{
						if(spot<2){auxButton=new Button(Assets.getAtlas().getTexture("icon1"));}
						else{auxButton=new Button(Assets.getAtlas().getTexture("icon2"));}
					
					
					}
					
					auxButton.x=Math.ceil(15+(level*(auxButton.width+9.5)));
					auxButton.y=Math.ceil(100+(spot*auxButton.height));
					obj.btn=auxButton;
					obj.levelID=level+1;
					trace("que levelid"+obj.levelID);
					obj.spotID=spot;
					objects.push(obj);
					auxButton.addEventListener(Event.TRIGGERED,onSpotClick);

					tableContainer.addChild(auxButton);
					
					
					
				}		
			
			
			
			}
			
		
		
		
		
		
		
		}
		
		private function onInterfaceClick(e:Event):void
		{
			if (!Sounds.muted){
				Sounds.sndFxMenu.play();
			}
			var buttonClicked:Button=e.target as Button;
			//caso tenha sido o button startButton
			if((buttonClicked as Button )==continueBtn){
				///ha aqui problema
				
				if( Game.levelCreated==true){
				
					
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.RESUME_LEVEL},true));
					
				}else{
				
					
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.RESUME_GAME,levelID:Game.currentGameLevel,spotID:0},true));							

				
				}
				
				

			}
			
			if((buttonClicked as Button )==newGameBtn){
				
				Sounds.currentMusic=Sounds.sndBgMenu;
				
				if (!Sounds.muted && Game.isActive){
					
					if(Game.previousState!=Game.ST_HOME){
						
						SoundMixer.stopAll();	
						Sounds.musicChannel=Sounds.currentMusic.play(0,999);
						Sounds.state=Sounds.MUSIC_HOME;
						
					}
				}
				trace("new game clicked");

				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_GAME},true));
				
				
				//CASO PRETENDAS SALTAR PARA O FINAL LOGO
				//this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.SHOW_FINAL_CUTSCENE},true));
				//lançar warning
				
			}
		
		}
		
		private function onSpotClick(e:Event):void
		{
			if (!Sounds.muted){
				Sounds.sndFxMenu.play();
			}
			var objectClicked:Object=getObjectFromButton(e.target as Button);// TODO Auto Generated method stub
			trace("level"+objectClicked.levelID);
			trace("spotId"+objectClicked.spotID);
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_LEVEL,levelID:objectClicked.levelID,spotID:objectClicked.spotID},true));

			
			
		}
		
	
		
		
		public function show():void{
		
			continueBtn.enabled=false;
			
			
			if(Game.isNewGame==false){
				
				continueBtn.enabled=true;
				
				
			}
			
			if(Game.levelCreated==true){
				
				continueBtn.enabled=true;
				
				
			}
			if(Game.currentGameLevel>0){
				
				continueBtn.enabled=true;
				
			}
			
			this.visible=true;
			LabQuest._stage.color=0xa79e95;
			stage.color=0xa79e95;
			updateSpots();
			

			
		
				
			
			
		
		}
		public function disposeTemporarily():void{
		
		this.visible=false;
		
		}
	}
}
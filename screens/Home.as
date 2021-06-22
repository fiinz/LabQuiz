package screens
{
	import com.greensock.motionPaths.LinePath2D;
	
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.utils.getTimer;
	
	import events.NavigationEvent;
	
	import starling.animation.DelayedCall;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.ClippedSprite;
	

	public class Home extends Sprite
	{
		
		//imagem background
		
		private var credits:Image;
		private var creditsSprite:Sprite;

		
		//buton de comecar jogo
		private var startBtn:Button;
		private var infoBtn:Button;
		private var soundBtn:Button;

		//private var soundOn:Boolean;
		
		private var containerStart:Sprite;
		private var creditsNamesAnim:ClippedSprite;
		private var creditsNames:Image;
		private var path:LinePath2D;
		
		private var currentDate:Date;
		private var creditsRotation:Number;
		private var delayedCall:DelayedCall;

		
		
		public function Home()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
		}
		public function onAddedToStage(e:Event):void{
		

			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
			drawScreen();
			
		}
		
		public function show():void{

			

			//tornar visivel

			
			LabQuest._stage.color=0xb6e0de;
			stage.color=0xb6e0de;

			this.visible=true;
			
			Sounds.currentMusic=Sounds.sndBgMenu;

			if (!Sounds.muted && Game.isActive){
				
				if(Game.previousState!=Game.ST_INFO){
					
					SoundMixer.stopAll();	
					Sounds.musicChannel=Sounds.currentMusic.play(0,999);
					Sounds.state=Sounds.MUSIC_HOME;

				}
			}
			this.addEventListener(Event.ENTER_FRAME,update);


		}
		public function disposeTemporarily():void{
			
			// tornar invisivel
			this.visible=false;			
			this.removeEventListener(Event.ENTER_FRAME,update);


			
		}
	
		private function drawScreen():void
		{
			
			//adionar a imagem de fundo

			
			
		

			var logosParceiros:Image=new Image(Assets.getAtlas().getTexture("logos"));
			logosParceiros.touchable=false;
			logosParceiros.y=stage.stageHeight-logosParceiros.height;
			logosParceiros.x=stage.stageWidth*0.5-logosParceiros.width/2;
			
			
			addChild(logosParceiros);
			
			creditsNamesAnim=new ClippedSprite;
			
			creditsNames=new Image(Assets.getAtlas().getTexture("creditos_nomes"));
			creditsNames.y=stage.stageHeight*0.85;
			creditsNames.x=stage.stageWidth/2-creditsNames.width/2;
			creditsNames.touchable=false;
			
			creditsNamesAnim.clipRect = new Rectangle(creditsNames.x,stage.stageHeight*0.6,creditsNames.width,creditsNames.height/4);
			creditsNamesAnim.addChild(creditsNames);
			creditsNamesAnim.touchable=false;

			currentDate = new Date();
			containerStart=new Sprite();
			creditsSprite=new Sprite();
			
			credits=new Image(Assets.getAtlas().getTexture("creditos"));
			credits.x=-credits.width/2;					
			
			addChild(creditsNamesAnim);
			
			var back:Image=new Image(Assets.getAtlas().getTexture("vamos_jogar_back"));
			back.x=-back.width/2;
			back.touchable=false;
			
			startBtn=new Button(Assets.getAtlas().getTexture("startBtn"));
			startBtn.downState=Assets.getAtlas().getTexture("startBtn - Down");
			startBtn.scaleWhenDown=0.97;
			startBtn.x=-startBtn.width/2;	
			startBtn.y=back.height*0.6;
			infoBtn=new Button(Assets.getAtlas().getTexture("info"));
			soundBtn=new Button(Assets.getAtlas().getTexture("sound"));
			soundBtn.x=-soundBtn.width*0.3;
			soundBtn.y=	infoBtn.y=back.y+soundBtn.height*0.7;

			infoBtn.x=soundBtn.x+infoBtn.width*0.6;
			soundBtn.x=soundBtn.x-soundBtn.width;
			
		
			this.addEventListener(Event.TRIGGERED,onMainMenuClick);
			containerStart.addChild(back);	
			containerStart.addChild(infoBtn);
			containerStart.addChild(soundBtn);
			containerStart.addChild(startBtn);

			containerStart.x=(stage.stageWidth/2);
			containerStart.y=stage.stageHeight*0.1;
			creditsSprite.addChild(credits);
			//mascara em cima
			var mask:Image=new Image(Assets.getAtlas().getTexture("mascara"));
			mask.y=stage.stageHeight*0.55;
			mask.x=stage.stageWidth*0.5-mask.width/2;
			this.addChild(mask);
			//mascara em baixo
			mask=new Image(Assets.getAtlas().getTexture("mascara"));
			mask.x=stage.stageWidth*0.5-mask.width/2;
			mask.y=stage.stageHeight*0.75;
			this.addChild(mask);

			this.addChild(creditsSprite);
			this.addChild(containerStart);
			creditsSprite.x = stage.stageWidth/2;
			
			
			var byCiencia:Image=new Image(Assets.getAtlas().getTexture("by_ciencia"));
			byCiencia.width*=0.6;
			byCiencia.height*=0.6;
			
			byCiencia.x=stage.stageWidth/2-byCiencia.width/2;
			byCiencia.y=stage.stageHeight*0.82;
			
			byCiencia.touchable=false;
			addChild(byCiencia);

		
		}
		

		
		
		private function update(e:Event):void
		
		{
			
			
			
			creditsNames.y-=0.5;
			if(creditsNames.y<stage.stageHeight*0.5-creditsNames.height*0.86){
				creditsNames.y=stage.stageHeight*0.86;
				
			}
				
		
						
			currentDate = new Date();
			creditsSprite.y = (stage.stageHeight*0.44) + (Math.cos(currentDate.getTime() * 0.0015)) * 3;
			creditsSprite.rotation=Math.cos(currentDate.getTime() * 0.002)/35;
			containerStart.y = (stage.stageHeight*0.05) + (Math.cos(currentDate.getTime() * 0.0012)) * 10;
			
			
			// TODO Auto Generated method stub
			
		}
		
		private function onMainMenuClick(e:Event):void
		{
			// TODO Auto Generated method stub
			//buttonClicked é uma auxiliar para ver qual o botao que foi clicado
			var buttonClicked:Button=e.target as Button;
			if (!Sounds.muted && Game.isActive){
				Sounds.sndFxMenu.play();
			}
			//caso tenha sido o button startButton
			if((buttonClicked as Button )==startBtn){
				
				
				trace("clicou no botao start e o jogo é novo ?"+Game.isNewGame);
				//ao fazer o dispatch o game está à escuta deste evento e comunica que é necessário mudar de ecrã e vai para o ecra level
				
				
				if(	Game.isNewGame==false || Game.previousState==Game.ST_LEVEL){
	
					this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.GO_NAVIGATION_MENU},true));
				}else{
					this.dispatchEvent(new NavigationEvent( NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_GAME},true));

				
				}
			
				this.dispatchEvent(new NavigationEvent( NavigationEvent.CHANGE_SCREEN,{id:Game.START_NEW_GAME},true));
				
			}
			if((buttonClicked as Button )==infoBtn){
			
				//PlayerStats.clearAllData();
				this.removeEventListener(Event.ENTER_FRAME,update);
				//ao fazer o  o game está à escuta deste evento e comunica que é necessário mudar de ecrã e vai para o ecra level
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.SHOW_INFO},true));
				
				
			}
			
			if((buttonClicked as Button )==soundBtn){
				
				if (Sounds.muted)
				{
					Sounds.muted = false;
					soundBtn.upState=Assets.getAtlas().getTexture("sound");
					Sounds.currentMusic=Sounds.sndBgMenu;
					Sounds.musicChannel=Sounds.currentMusic.play(0,999);
					
			
				}
				else
				{
					Sounds.muted = true;
					soundBtn.upState=Assets.getAtlas().getTexture("sound_off");
					SoundMixer.stopAll();

		
				}
				
				//ao fazer o dispatch o game está à escuta deste evento e comunica que é necessário mudar de ecrã e vai para o ecra level
				
				
			}
			
			
		}
		
	
	}
	
}
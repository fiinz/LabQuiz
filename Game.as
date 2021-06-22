package
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.media.SoundMixer;
	
	import data.PlayerStats;
	
	import screens.Challenge;
	import screens.CutScene;
	import screens.Home;
	import screens.Info;
	import screens.Level;
	import screens.NavigationMenu;
	import screens.Question;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.ImagePool;
	import utils.ObjectPool;
	import utils.SpritePool;
	import utils.Tutorial;
	
	import events.NavigationEvent;

	public class Game extends Sprite
	{
		//controla se o jogo está ativo ou nao
		public static var isActive:Boolean=true;

		// se o jogo ja começou
		public static var started:Boolean=false;
		
		//a percentagem minima de perguntas certas para aceder ao ultimo jogo
		public static const LAST_LEVEL_REQ_PERCENTAGE:Number=0.6;
		
		//os diferentes ecras de jogo

		private var screenHome:Home;
		private var screenInfo:Info;
		private var screenLevel:Level;
		private var screenQuestion:Question;
		private var screenChallenge:Challenge;
		private var screenCutScene:CutScene;
		private var screenNavigationMenu:NavigationMenu;
		public static var isNewGame:Boolean;
		
		
		//estado de jogo
		
		public static var state:uint;
		public static var previousState:uint;
		
		public static const ST_HOME:uint=0;
		public static const ST_LEVEL:uint=1;
		public static const ST_QUESTION:uint=2;
		public static const ST_CHALLENGE:uint=3;
		public static const ST_NAVIGATION_MENU:uint=4;
		public static const ST_INFO:uint=5;
		public static const ST_STARTING:uint=6;
		public static const ST_INTRO:uint=7;
		public static const ST_LEVEL_COMPLETE:uint=8;
		public static const ST_GAME_OVER:uint=9;
		public static const ST_GAME_BALANCE:uint=10;


		
		
		
		
		
		
		//navigation flags
		
		public static const GO_HOME:String="gohome";
		public static const START_NEW_LEVEL:String="newlevel";
		public static const START_NEW_GAME:String="newgame";
		public static const SHOW_INTRO:String="showintrocutscene";
		public static const SHOW_INFO:String="info";
		
		public static const RESUME_LEVEL:String="resumelevel";
		public static const RESUME_GAME:String="resumegame";

		public static const START_NEW_QUESTION:String="newquestion";
		public static const START_NEW_CHALLENGE:String="newchallenge";
		public static const GO_NAVIGATION_MENU:String="navigationmenu";
		public static const SHOW_HELP:String="gohelpmenu";
		public static const SHOW_LEVEL_COMPLETE:String="levelComplete";
		public static const SHOW_BOSS_CUTSCENE:String="bossIntrocutscene";
		public static const SHOW_FINAL_CUTSCENE:String="bossFinalcutscene";
		
		public static const SHOW_BALANCE:String="balance";

		//numero de niveis sem contar com o ultimo
		
		public static const NUM_OF_LEVELS:uint=5;
		//numero maximo de questoes por spot
		public static const NUM_QUESTIONS_SPOT:uint=3;
		
		
		private static const MAX_SPRITES:uint=60;
		private static const MAX_OBJECTS:uint=60;
		private static const MAX_IMAGES:uint=50; 
		
		
		private const GROWTH_VALUE:uint=MAX_SPRITES>>1;
		private const MAX_NUM:uint=10;
		
		
		
		public static var currentGameLevel:uint=0;
		public static const LAST_LEVEL_ID:uint=5;
		public static var levelCreated:Boolean;
		
		
		
		//a variavel progressLevel vai permitir saber qual o progresso do jogador no jogo
		// a variavel vai buscar o estado as preferencias/ state gravado no telemovel.

		
		
		
		public function Game()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
			
			//verifica se há histórico , caso existe Game nao é novo jogo.
			
		
			
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.EXITING,onExit);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE,onActivate);
			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE,onDectivate);
		}
		
	
		
		protected static function onExit(event:flash.events.Event):void
		{
			trace("exit");

			PlayerStats.saveData();

			// TODO Auto-generated method stub
			Game.isActive=false;			

			
			
		}
		
		protected static function onDectivate(event:flash.events.Event):void
		{
			// TODO Auto-generated method stub
         	Game.isActive=false;	
			trace("deativate");
			PlayerStats.saveData();

		
			if(Sounds.currentMusic!=null){
				SoundMixer.stopAll();
			
			}
			
			
		}
		
		protected static function onActivate(event:flash.events.Event):void
		{
		//	Sounds.musicChannel.soundTransform=Sounds.musicChannel.soundTransform=Sounds.inTransform;
					
			

			if(Sounds.currentMusic!=null && Game.isActive==false){
				Game.isActive=true;			
				Sounds.musicChannel=Sounds.currentMusic.play();
				Sounds.muted=false;
			}


			
			// TODO Auto-generated method stub
			trace("ativate");
			
			
		}
		
		
		
		
		private function onAddedToStage(e:starling.events.Event):void{
			LabQuest.textLoaderPerc.visible=false;
			
			Game.state=Game.ST_STARTING;
			Game.levelCreated=false;
			PlayerStats.initialize();	
			if(PlayerStats.checkIfHistory())
			{
				Game.isNewGame=false;
				PlayerStats.loadPreviousData();
				
				
			}else{
				
				Game.isNewGame=true;
				
				
			}
			
		
			
					
			
			//trace("framework is initialized")
			SpritePool.initialize (Game.MAX_SPRITES,GROWTH_VALUE ); 
			ObjectPool.initialize (Game.MAX_OBJECTS,GROWTH_VALUE ); 
			ImagePool.initialize(Game.MAX_IMAGES,GROWTH_VALUE ); 
			
			
			createGameScreens();	
			
			
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN,onChangeScreen);

			this.removeEventListener(starling.events.Event.ADDED_TO_STAGE,onAddedToStage);
			
			
		}
		
		//ele ativa sempre que o contexto foi atualizado
		
	
		private function createGameScreens():void{
			
			
			screenCutScene=new CutScene();
			this.addChild(screenCutScene);
			
			screenInfo=new Info();
			this.addChild(screenInfo);
			
			screenNavigationMenu=new NavigationMenu();
			this.addChild(screenNavigationMenu);
			
			
			screenLevel=new Level();
			this.addChild(screenLevel);
			
			screenQuestion=new Question();
			this.addChild(screenQuestion);
			
			
			
			screenChallenge=new Challenge();
			this.addChild(screenChallenge);
			
			
			screenHome=new Home();
			this.addChild(screenHome);
			screenHome.show();
			Game.state=ST_HOME;
			
			
			
			
			
		}
		
		
		
		
		
		
		//funcao que vai processar a navegaçao do jogo
		
		private function onChangeScreen(e:NavigationEvent):void{
			
			
			screenCutScene.disposeTemporarily();
			screenChallenge.disposeTemporarily();
			screenNavigationMenu.disposeTemporarily();
			screenInfo.disposeTemporarily();
			screenHome.disposeTemporarily();
			screenLevel.disposeTemporarily();
			screenQuestion.disposeTemporarily();
			Starling.juggler.purge();
			
			//params.id guarda qual o ecrã
			switch(e.params.id){
				
				
				
				case Game.START_NEW_GAME:
					
					
					//reset Data
					
					Game.previousState=Game.state;
					Game.state=Game.ST_INTRO;
					
					//mudar isto para parametros
					PlayerStats.clearData();
					Game.currentGameLevel=1;
					screenCutScene.initialize("Intro",4);

					screenCutScene.show();
					Game.isNewGame=true;					
					Tutorial.ative=true;
					Tutorial.state=Tutorial.BEGIN;
					
					
					break;
				
				
				//level anterior
				
				
				
				case Game.GO_HOME:
					
					Game.previousState=Game.state;
					Game.state=Game.ST_HOME;
					//mudar isto para parametros
					screenHome.show();
					
					
					
					break;
				
				
				
				case Game.START_NEW_LEVEL:
					
					Game.previousState=Game.state;
					Game.state=Game.ST_LEVEL;
					
					this.removeChild(screenLevel);
					
					screenLevel=new Level();				
					this.addChild(screenLevel);
					
					trace("adding new child");
					
					//so podes fazer initalize depois do add caso contrário dá erro do Stage
				
						//se tiver nivel criado usa este
						Game.currentGameLevel=e.params.levelID as uint;
					
					if(Game.currentGameLevel>1){
						Tutorial.ative=false;					
						Tutorial.state=Tutorial.TUTORIAL_END;
						trace("level > 1");
					}
					
					
					
					if(Game.previousState!=Game.ST_NAVIGATION_MENU ){
						//caso nao tenha criado o level começa no sitio default
						screenLevel.initialize(Game.currentGameLevel,e.params.spotID as uint,false);
						trace("inialize fail ?");
						
					}
					else{
						screenLevel.initialize(Game.currentGameLevel,e.params.spotID as uint,true);
						
					}
					trace("start showing");

					screenLevel.show();
					Game.levelCreated=true;
					
					
					break;
				
				
				
				case Game.SHOW_LEVEL_COMPLETE:
					
					Game.previousState=Game.state;
					Game.state=Game.ST_LEVEL_COMPLETE;
					
					
					if(Game.currentGameLevel<Game.LAST_LEVEL_ID){
						
						//chegaste ao ultimo nivel
						
						screenCutScene.initialize("Level"+Game.currentGameLevel+"Complete",1);
						Game.currentGameLevel++;
						screenCutScene.show();
						
						if(!Sounds.muted)
						{
							SoundMixer.stopAll();
							Sounds.sndFxChallengeComplete.play();
						}
						
					}
					
					
					
					
					
					break;
				
				
				case Game.GO_NAVIGATION_MENU:
					
					Game.previousState=Game.state;
					Game.state=Game.ST_NAVIGATION_MENU;					
					screenNavigationMenu.show();
					
					
					
					break;
				
				
				case Game.RESUME_LEVEL:
					
					if(Game.levelCreated==true)
					{
						Game.previousState=Game.state;
						Game.state=Game.ST_LEVEL;
						screenLevel.show();
					}
					
						
					
					
					
					break;
				
				//quadro tipo questao
				case Game.START_NEW_QUESTION:
					
					Game.previousState=Game.state;
					Game.state=Game.ST_QUESTION;
					screenQuestion.initialize(Game.currentGameLevel,e.params.spotId as uint,Game.NUM_QUESTIONS_SPOT);
					screenQuestion.show();
					
					
					break;
				
				//quadro tipo home
				case Game.GO_HOME:
					
					Game.previousState=Game.state;
					Game.state=Game.ST_HOME;
					
					
					
					break;
				case Game.SHOW_BOSS_CUTSCENE:
					
					screenCutScene.initialize("BossCutScene",1);
					screenCutScene.show();
					
					break;
				
				
				
				
				case Game.START_NEW_CHALLENGE:
					
					
					
					Game.previousState=Game.state;
					Game.state=Game.ST_CHALLENGE;
					
					screenChallenge.initialize(currentGameLevel);
					screenChallenge.show();
					
					
					
					
					break;
				
				case Game.SHOW_INFO:
					Game.previousState=Game.state;
					Game.state=Game.ST_INFO;
					
					screenInfo.initialize();			
					screenInfo.show();
					
					break;
				
				case Game.SHOW_FINAL_CUTSCENE:
					if(!Sounds.muted)
					{
						SoundMixer.stopAll();
						Sounds.sndFxChallengeComplete.play();
					}
					
					Game.previousState=Game.state;
					Game.state=Game.ST_GAME_OVER;
					
					
					screenCutScene.initialize("FinalCutScene",1);
					screenCutScene.show();
					
					
					
					break;
				
				case Game.SHOW_BALANCE:
					
				
					
					Game.previousState=Game.state;
					Game.state=Game.ST_GAME_BALANCE;
					
					screenCutScene.initialize("Balance",1);
					screenCutScene.show();
					
					break;
				
				
				
				case Game.RESUME_GAME:
					
					
						//nivel criado do ficheiro
					Game.previousState=Game.state;
					Game.state=Game.ST_LEVEL;
					
					this.removeChild(screenLevel);
					
					screenLevel=new Level();				
					this.addChild(screenLevel);
					
					trace("resue game no nivel no level"+Game.currentGameLevel);
						
					
					if(!Sounds.muted)
					{
						SoundMixer.stopAll();
						Sounds.sndFxChallengeComplete.play();
					}
					
					screenLevel.initialize(Game.currentGameLevel,e.params.spotID as uint,false);

					screenLevel.show();
					Game.levelCreated=true;
				
					
					
					
					break;
				
				
				
				
				
				
				
			}
			
		}
		
		
	}
}
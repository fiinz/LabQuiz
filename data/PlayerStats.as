package data
{
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	
	import utils.Tutorial;
	
	public class PlayerStats
	{
		
		
		
		
	                                                                                                                                     
		
		// pontuação de todos os spots.
		//public static  var matchScore:uint;
		public static var spotsScore:Array;
		public static var spotsState:Array;
		public static var numOfQuestionsAwnsered:uint;
		public static var numOfQuestionsMissing:uint;
		public static var totalQuestions:uint=3*2*5;
		public static var questPercentage:Number=0;



		
		
		//histórico do jogador
		public static  var historyCorrectAwnsers:uint=0;
		public static  var historyIncorrectAwnsers:uint=0;
		public static  var historyTotalQuestions:uint=0;
		
	
		
		//quantos challenges fez e quantas completou com sucesso
		public static var historyNumChallengesCleared:uint=0;
		public static var historyTotalNumChallenges:uint=0;
		
		//quantos tempo gastou nos challenges
	//	public static  var historyTimeChallenge:uint=0;
		
		//quantos movimentos fez nos challenges ?
	//	public static  var playerHistoryMoveChallenge:uint=0;
		
		

	//	public static var isFirstTime:Boolean=true;

		public static function clearAllData():void{
			var so:SharedObject = SharedObject.getLocal("LabQuizSharedObject");
			so.clear();
		
		}
		public static function saveData():void
		{
			
			trace("a guardar");
			var so:SharedObject = SharedObject.getLocal("LabQuizSharedObject");
			so.data.spotsScore=spotsScore;
			so.data.spotsState=spotsState;
			so.data.history=true;
			so.data.currentGameLevel=Game.currentGameLevel;
			so.data.historyCorrectAwnsers=PlayerStats.historyCorrectAwnsers;
			so.data.historyIncorrectAwnsers=PlayerStats.historyIncorrectAwnsers;
			so.data.historyTotalQuestions=PlayerStats.historyTotalQuestions;
			
			
			
			
			//quantos challenges fez e quantas completou com sucesso
		
			
			//save the data
			so.flush();

			// TODO Auto-generated method stub
			
		}
		public static function loadPreviousData():void{
			
		
			var so:SharedObject = SharedObject.getLocal("LabQuizSharedObject");
			
			spotsScore=so.data.spotsScore;	
			spotsState=so.data.spotsState;
			Game.currentGameLevel=so.data.currentGameLevel;
			PlayerStats.historyCorrectAwnsers=so.data.historyCorrectAwnsers;
			PlayerStats.historyCorrectAwnsers=so.data.historyIncorrectAwnsers;
			PlayerStats.historyTotalQuestions=so.data.historyTotalQuestions;
			updateQuestScore();
			
			
			
		
		}
		public static function checkIfHistory():Boolean{
		
			var so:SharedObject = SharedObject.getLocal("LabQuizSharedObject");
			if(so.data.history==null){
				
				trace("nao ha histórico");
				return false;
			}
			else{
				trace("O historico esta"+so.data.history);
				trace("ha historico");				
				return true;
			
			
			}
				

			
		}
		
		public static function updateQuestScore():void{
			
			//faz atualização da pontuação toda do jogo
			
			var percentage:Number;
			var count:uint=0;
			for(var level:uint=0;level<5;level++){
				
				for(var spot:uint=0;spot<2;spot++){
					
					count+=PlayerStats.spotsScore[level][spot];
					
					
				}
				
				
				
			}
			trace("neste momento tens"+count+"respostas certas");
			PlayerStats.numOfQuestionsAwnsered=count;
			PlayerStats.numOfQuestionsMissing=PlayerStats.totalQuestions-count;
			trace("neste momento tens"+PlayerStats.numOfQuestionsMissing+"por responder");
			PlayerStats.questPercentage=PlayerStats.numOfQuestionsAwnsered/PlayerStats.totalQuestions;
			trace("neste momento tens"+PlayerStats.questPercentage+"percentagem");
			

			
			
			
			
			
		}
		
		public static function updatePlayerHistoryScore():void{
			
			//percentagem do histórico de jogo			
			var percentageHistory:int=Math.floor(PlayerStats.historyCorrectAwnsers/PlayerStats.historyTotalQuestions)*100;
			
			trace(" estaistica de jogo"+PlayerStats.historyTotalQuestions+"acertaste"+PlayerStats.historyCorrectAwnsers+"Erraste:"+PlayerStats.historyIncorrectAwnsers);
			
			
			
		}
		public static function initialize():void
		{
			
			//checkIfFirstTime();
		
			PlayerStats.spotsScore=new Array();
			PlayerStats.spotsState=new Array();

			
			for(var i:uint=0;i<Game.NUM_OF_LEVELS;i++){
				PlayerStats.spotsScore.push(new Vector.<uint>(3));
				PlayerStats.spotsState.push(new Vector.<uint>(3));

				
				
			}
			
			
			//PlayerStats.playerSpotScore=new Vector.<uint>(3);
			//PlayerStats.playerLevelStats=new Vector.<uint>(this.NUM_OF_LEVELS+1);
			
		



		
		}
		

		public static function clearData():void{
		
			trace("apagou data");
			PlayerStats.spotsScore=new Array();
			PlayerStats.spotsState=new Array();

			for(var i:uint=0;i<Game.NUM_OF_LEVELS;i++){
				PlayerStats.spotsScore.push(new Vector.<uint>(3));
				PlayerStats.spotsState.push(new Vector.<uint>(3));
				
			}
			var so:SharedObject = SharedObject.getLocal("LabQuizSharedObject");
			so.data.spotsScore=PlayerStats.spotsScore;	
			so.data.spotState=PlayerStats.spotsState;
			PlayerStats.historyCorrectAwnsers=0;
			PlayerStats.historyCorrectAwnsers=0;
			PlayerStats.historyTotalQuestions=0;
		
			so.clear();
			//save the data
			so.flush();

		
		}
		
	
	}
}
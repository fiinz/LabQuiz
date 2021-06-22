

package 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	

	public class Sounds
	{
		public static var musicChannel:SoundChannel=new SoundChannel();
		public static var sfx:SoundChannel=new SoundChannel();
		public static var outTransform:SoundTransform=new SoundTransform(0);
		public static var inTransform:SoundTransform=new SoundTransform(1);
		public static var currentMusic:Sound;
		public static var currentMusicPosition:uint;


		[Embed(source="sounds/001_menu.mp3")]
		public static const SND_BG_MENU:Class;
		
		//corrigir e colocar o bip
		[Embed(source="sounds/012_beep.mp3")]
		public static const SND_FX_MENU:Class;
		
		[Embed(source="sounds/011_blop.mp3")]
		public static const SND_FX_CHALLENGE:Class;


		[Embed(source="sounds/005a_acertou_1a.mp3")]
		public static const SND_FX_CORRECT_AWNSER_1:Class;
		
		
		[Embed(source="sounds/006_errou_resposta.mp3")]
		public static const SND_FX_WRONG_AWNSER:Class;
		
		[Embed(source="sounds/008_acertou_3_respostas.mp3")]
		public static const SND_FX_3_CORRECT_AWNSERS:Class;
		
		[Embed(source="sounds/009_termina_puzzle_abre_sala.mp3")]
		public static const SND_FX_CHALLENGE_COMPLETE:Class;
		
		
		
		[Embed(source="sounds/007_acabou_tempo.mp3")]
		public static const SND_FX_TIME_OUT:Class;
		
		
		[Embed(source="sounds/002_sala.mp3")]
		public static const SND_BG_LEVEL:Class;
		
		[Embed(source="sounds/003_perguntas.mp3")]
		public static const SND_BG_QUESTION:Class;
		
		
		[Embed(source="sounds/004_puzzle.mp3")]
		public static const SND_BG_CHALLENGE:Class;
		
		[Embed(source="sounds/013_countdown.mp3")]
		public static const SND_FX_COUNTDOWN:Class;
		
		[Embed(source="sounds/014_riso_mau.mp3")]
		public static const SND_FX_BOSS_MESSAGE_NEGATIVE:Class;

		
		public static var state:String;
		public static const MUSIC_HOME:String="music_home";
		public static const MUSIC_LEVEL:String="music_level";
		public static const MUSIC_CHALLENGE:String="music_challenge";
		public static const MUSIC_QUESTION:String="music_question";
		


		
		public static var muted:Boolean = false;
		public static var sndFxBossMessageNegative:Sound=new Sounds.SND_FX_BOSS_MESSAGE_NEGATIVE() as Sound;
		public static var sndFxChallengeComplete:Sound = new Sounds.SND_FX_CHALLENGE_COMPLETE() as Sound;
		public static var sndFxChallenge:Sound=new Sounds.SND_FX_CHALLENGE() as Sound;

		
		public static var sndFxCountDown:Sound = new Sounds.SND_FX_COUNTDOWN() as Sound;

		
		public static var sndFx3CorrectAwnsers:Sound = new Sounds.SND_FX_3_CORRECT_AWNSERS() as Sound;
		
		public static var sndFxCorrectAwnser:Sound = new Sounds.SND_FX_CORRECT_AWNSER_1() as Sound;

		public static var sndFxWrongAwnser:Sound = new Sounds.SND_FX_WRONG_AWNSER() as Sound;

		public static var sndFxTimeOut:Sound = new Sounds.SND_FX_TIME_OUT() as Sound;

		public static var sndBgChallenge:Sound = new Sounds.SND_BG_CHALLENGE() as Sound;

		public static var sndBgMenu:Sound = new Sounds.SND_BG_MENU() as Sound;
		
		public static var sndFxMenu:Sound = new Sounds.SND_FX_MENU() as Sound;

		public static var sndBgLevel:Sound = new Sounds.SND_BG_LEVEL() as Sound;
		
		public static var sndBgQuestion:Sound = new Sounds.SND_BG_QUESTION() as Sound;

		
		
		
	/*	[Embed(source="../media/sounds/bgWelcome.mp3")]
		public static const SND_BG_MAIN:Class;
		
		[Embed(source="../media/sounds/eat.mp3")]
		public static const SND_EAT:Class;
		
		[Embed(source="../media/sounds/coffee.mp3")]
		public static const SND_COFFEE:Class;
		
		[Embed(source="../media/sounds/mushroom.mp3")]
		public static const SND_MUSHROOM:Class;
		
		[Embed(source="../media/sounds/hit.mp3")]
		public static const SND_HIT:Class;
		
		[Embed(source="../media/sounds/hurt.mp3")]
		public static const SND_HURT:Class;
		
		[Embed(source="../media/sounds/lose.mp3")]
		public static const SND_LOSE:Class;*/
		
		/**
		 * Initialized Sound objects. 
		 */		
	/*	public static var sndBgMain:Sound = new Sounds.SND_BG_MAIN() as Sound;
		public static var sndBgGame:Sound = new Sounds.SND_BG_GAME() as Sound;
		public static var sndEat:Sound = new Sounds.SND_EAT() as Sound;
		public static var sndCoffee:Sound = new Sounds.SND_COFFEE() as Sound;
		public static var sndMushroom:Sound = new Sounds.SND_MUSHROOM() as Sound;
		public static var sndHit:Sound = new Sounds.SND_HIT() as Sound;
		public static var sndHurt:Sound = new Sounds.SND_HURT() as Sound;
		public static var sndLose:Sound = new Sounds.SND_LOSE() as Sound;*/
		
	
	}
}
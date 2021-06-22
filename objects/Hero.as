package objects
{
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Hero extends Sprite
	{
		
		private var heroStill:Image;
		private var heroIdle:MovieClip;
		private var heroSide:MovieClip;
		private var heroUp:MovieClip;
		private var heroDown:MovieClip;
		public var heroAnimationState:uint;
		
		

		public static const STILL:uint=0;
		public static const LEFT:uint=1;
		public static const RIGHT:uint=2;
		public static const UP:uint=3;
		public static const DOWN:uint=4;

		public static const IDLE:uint=5;


		
		public function Hero()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			// TODO Auto Generated method stub
			createHeroArt();
			
		}
		
		private function createHeroArt():void
		{
			// TODO Auto Generated method stub
			
			// ele vai buscar um novo Movie Clip /baseado na
			//o primeiro argumento do MovieClip é um vector de texturas por causa da animação
			// atraves do GameTextureAtlas ele vai buscar todas as texturas com prefixo fly_
			
			// o segundo argumetno é os fps
			
			//ceil arrendonda sempre para o maior
			
			//getTextures - obtem todas as texturas com um determinado prefixo . importante para
			//animações
		/*	heroStill=new MovieClip(Assets.getAtlas().getTextures("still"),2);
			
			*/
			
			heroStill=new Image(Assets.getAtlas().getTexture("still"));
			heroStill.x=Math.ceil(-heroStill.width/2);
			heroStill.y=Math.ceil(-heroStill.height/2);
			heroStill.visible=true;
			this.heroAnimationState=STILL;
			
			heroIdle=new MovieClip(Assets.getAtlas().getTextures("idle_"),5);
			heroIdle.x=Math.ceil(-heroIdle.width/2);
			heroIdle.y=Math.ceil(-heroIdle.height/2);
			heroIdle.visible=false;
			
			
			
			
			
			heroSide=new MovieClip(Assets.getAtlas().getTextures("side_"),5);
			heroSide.x=Math.ceil(-heroStill.width/2);
			heroSide.y=Math.ceil(-heroStill.height/2);
			heroSide.visible=false;
			
			heroUp=new MovieClip(Assets.getAtlas().getTextures("back_"),4);
			heroUp.x=Math.ceil(-heroStill.width/2);
			heroUp.y=Math.ceil(-heroStill.height/2);
			heroUp.visible=false;
			
			
			heroDown=new MovieClip(Assets.getAtlas().getTextures("front_"),4);
			heroDown.x=Math.ceil(-heroStill.width/2);
			heroDown.y=Math.ceil(-heroStill.height/2);
			heroDown.visible=false;
			
			
			//isto faz com que o heroARt seja animado , caso contrário nao é

			//juggler
			this.addChild(heroIdle);

			this.addChild(heroStill);
			this.addChild(heroDown);
			this.addChild(heroSide);
			this.addChild(heroUp);
		

			
			
			
			
		}	
	
		public function addAnimation():void{
		

			Starling.juggler.add(heroIdle);			

			Starling.juggler.add(heroSide);			
			Starling.juggler.add(heroUp);
			Starling.juggler.add(heroDown);
		
		
		}
		
		
		public function changeAnimationState(state:int):void{
			trace("change state Hero");
			this.heroAnimationState=state;
			switch (state){
			
			
			case LEFT:
				heroIdle.visible=false;
				heroStill.visible=false;
				heroUp.visible=false;
				heroDown.visible=false;
				heroSide.visible=true;
				this.scaleX=-1;
				
				break;
			
			
			case RIGHT:
					heroIdle.visible=false;
					heroStill.visible=false;
					heroUp.visible=false;
					heroDown.visible=false;
					heroSide.visible=true;
					this.scaleX=1;
				
				break;
			
			case UP:
				heroIdle.visible=false;
					heroStill.visible=false;
					heroUp.visible=true;
					heroDown.visible=false;
					heroSide.visible=false;
					this.scaleX=1;
				
				break;
			
			case DOWN:
				trace("heroDown");

					heroIdle.visible=false;

					heroStill.visible=false;
					heroUp.visible=false;
					heroDown.visible=true;
					heroSide.visible=false;
					this.scaleX=1;
				
				break;
			
			
			
			case STILL:
				trace("heroStill");
				
					heroIdle.visible=false;
					heroStill.visible=true;
					heroUp.visible=false;
					heroDown.visible=false;
					heroSide.visible=false;
					this.scaleX=1;
				
				break;
			
			
			case IDLE:
				
				heroIdle.visible=true;
				heroStill.visible=false;
				heroUp.visible=false;
				heroDown.visible=false;
				heroSide.visible=false;
				this.scaleX=1;
				
				break;
			
			
			
			}
			
			
			
		
		
		}
		
	}
}
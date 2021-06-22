package utils
{
	import flash.geom.Rectangle;
	
	import events.TimerEvent;

	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	

	public class TimerBar
	{
		
		private var context:Sprite;		
		private var delayedCall:DelayedCall;
		//barra de tempo
		private var timerBarFull:ClippedSprite; 
		private var timerBarEmpty:Image;
		private var timerContainer:Sprite;
		private var delaySeconds:uint;
		public function TimerBar(context:Sprite)
		{
			
			this.context=context;
			
		}
		
		
		
		
		public function drawTimer(ox:uint,oy:uint):void{
			timerContainer=new Sprite();
			
			timerBarFull= new ClippedSprite();
			var timerIcon:Image=new Image(Assets.getAtlas().getTexture("time"));
			
			var timeBarImageFull:Image=new Image(Assets.getAtlas().getTexture("timer_full"));
			timerBarEmpty=new Image(Assets.getAtlas().getTexture("timer_empty"));
			
			timerBarEmpty.x=Math.ceil(context.stage.stageWidth/2-timerBarFull.width/2-timerBarEmpty.width/2+timerIcon.width/2);
			timerBarEmpty.y=Math.ceil(context.stage.stageHeight*0.92);
			
			timerBarFull.x=timerBarEmpty.x;
			timerBarFull.y=timerBarEmpty.y;
			
			timerBarFull.clipRect = new Rectangle(timerBarFull.x,timerBarFull.y,timerBarEmpty.width,timerBarEmpty.height);
			
			timerBarFull.addChild(timeBarImageFull);
			timerContainer.addChild(timerBarEmpty);
			timerContainer.addChild(timerBarFull);
			timerContainer.touchable=false;
			timerContainer.addChild(timerIcon);
			timerIcon.x=timerBarFull.x-timerIcon.width;
			timerIcon.y=timerBarFull.y-timerIcon.height/2+timerBarFull.height/2;
			context.addChild(timerContainer);
			
	
		
		
		
		}
		public function show():void{
			
			timerContainer.visible=true;
		
		}
		public function hide():void{
			
			//context.removeChild(timerContainer);
			timerContainer.visible=false;
			
		
		
		}
		public function stopTimer():void{
			
			Starling.juggler.remove(delayedCall);
			
			
		}
		public function pauseTimer():void{
		
			Starling.juggler.remove(delayedCall);

		}
		
		private function resumeTimer():void{
			
			Starling.juggler.add(delayedCall);
			
		}
		public function setDuration(duration:Number):void{
			
			delayedCall=new DelayedCall(updateAwnserTimer,duration/1000);
			timerBarFull.clipRect.width=timerBarEmpty.width;
			delayedCall.repeatCount=1000;
			timerBarFull.visible=true;

			
			
		}
		public function startTimer():void{
		
			Starling.juggler.add(delayedCall);
		
		}
		
		public function resetTimer():void{
		
			timerBarFull.clipRect.width=timerBarEmpty.width;

		
		}
		private function updateAwnserTimer():void{
			
			
			timerBarFull.clipRect.width-=timerBarEmpty.width/1000;
			if(timerBarFull.width<=1){timerBarFull.width=1;}
			if(delayedCall.isComplete){
				Starling.juggler.remove(delayedCall);
				//o utilizar nao respondeu
				timeOut();
			}
			
			
		}
		private function timeOut():void{
			timerBarFull.visible=false;

			context.dispatchEvent(new TimerEvent(TimerEvent.TIME_OUT,null,true));


		
		
		
		}
		
		
	}
}
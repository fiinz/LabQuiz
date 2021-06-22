package utils
{
	import flash.geom.Rectangle;
	
	import events.TimerEvent;
	
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	public class CountDown
	{
		
		private var context:Sprite;		
		private var delayedCall:DelayedCall;
		//barra de tempo
		private var delaySeconds:uint;
		private var current:int;
		private var numberImage:Image;
		private var ox:uint;
		private var oy:uint;
		
		
		
		public function CountDown(context:Sprite,ox:uint,oy:uint)
		{
			
			this.context=context;
			this.ox=ox;
			this.oy=oy;
			this.current=3;
			
			
		}
		
		
		
		
		private function draw():void{
			
			numberImage=new Image(Assets.getAtlas().getTexture("cd_3"));

			numberImage.x=this.ox-numberImage.width/2;
			numberImage.y=this.oy-numberImage.height/2;
			numberImage.touchable=false;
			
			context.addChild(numberImage);
			
			
			
		}
		
	
		
	
		public function startCountDown():void{
			this.current=3;
			draw();
			numberImage.visible=true;
			delayedCall=new DelayedCall(updateCountDown,1);
			delayedCall.repeatCount=3;
			Starling.juggler.add(delayedCall);
			if (!Sounds.muted ){
				Sounds.sndFxCountDown.play();

			
			}

			
		}
		
		private function updateCountDown():void{
			
				this.current--;
				trace("tempo"+this.current);
				trace("tempo passou"+Starling.juggler.elapsedTime);

				if(delayedCall.isComplete){
				Starling.juggler.remove(delayedCall);
				Starling.juggler.purge();
				//o utilizar nao respondeu
				timeOut();
				}else{
				
					numberImage.texture=Assets.getAtlas().getTexture("cd_"+current);

				
				}
			
			
			
		}
		public function hide():void{
		
		 numberImage.visible=false;
		
		}
		private function timeOut():void{
			
			numberImage.visible=false;
			
			context.dispatchEvent(new TimerEvent(TimerEvent.COUNT_DOWN_FINISHED,null,true));
			
			
			
			
		}
		
		
	}
}
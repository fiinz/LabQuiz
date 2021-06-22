package objects
{
	
	

	
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import events.TutorialEvent;
	import starling.utils.VAlign;
	
	public class FlaskMessage extends Sprite
	{
		public  var status:Boolean;
		private var messageContainer:Sprite;
		
		
		
		
		private var heroMsgText:TextField;
		private var delayedCall:DelayedCall;
		private var tweenContainer:Tween;
		private var message:String;
		public static const FINISHED:String="heromessage";
		
		public static const LEFT:int=-1;
		public static const RIGHT:int=1;
		
		
		
		private var xScale:int;
		
		
		public function FlaskMessage(newMessage:String,xScale:int)
		{
			this.visible=false;
			this.message=newMessage;
			this.xScale=xScale;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void
		{
			// TODO Auto Generated method stub
			initialize();
			
		}		
		
		
		public function initialize():void
		{
			
			
			messageContainer=new Sprite();
			messageContainer.touchable=false;
			
			
			
			var messageBackground:Image=new Image(Assets.getAtlas().getTexture("heroMessage"));
			messageBackground.scaleX=xScale;
			messageBackground.alpha=1;
			messageContainer.addChild(messageBackground);
			
			var messageBoxWidth:uint=messageContainer.width*0.88;
			var messageBoxHeight:uint=messageContainer.height*0.6;	
			
			
			
			
			
			heroMsgText=new TextField(messageBoxWidth,messageBoxHeight,"Ola sou uma mensagem","VitesseBold",18,0x0);
			heroMsgText.border=false;
			heroMsgText.color=0x138c96;
			heroMsgText.vAlign=VAlign.CENTER;
			
			
			
			
			if(xScale==HeroMessage.RIGHT){
				messageContainer.x-=80;
				heroMsgText.x=messageContainer.x+100;
				heroMsgText.y=messageContainer.y+10;
			}
			else{
				trace("entrou aqui ?????");	
				messageContainer.x+=80;
				//	messageContainer.x-=10;			
				heroMsgText.x=-messageContainer.width+20;;
				heroMsgText.y=messageContainer.y+10;
			}
			
			
			heroMsgText.text=message.toUpperCase();
			
			
			messageContainer.addChild(heroMsgText);
			this.addChild(messageContainer);
			
		}
		
		
		
		public function show():void{
			this.visible=true;
			
			messageContainer.alpha=0;
			status=true;
			//messageContainer.alpha=0;
			
			
			messageContainer.visible=true;
			
			tweenContainer= new Tween(messageContainer,0.5, Transitions.LINEAR);
			tweenContainer.animate("alpha",1);
			//tween.animate("x",0);
			
			tweenContainer.onComplete=onContainerAnimationComplete;			
			Starling.juggler.add(tweenContainer);	
			
		}	
		
		public function hide():void{
			
			
			//bossMsgText.visible=false;
			//bossMsgText.alpha=0;
			
			
			Starling.juggler.remove(delayedCall);
			Starling.juggler.remove(tweenContainer);
			
			status=false;
			
			
		}
		
		private function onContainerAnimationComplete():void
		{
			
			
			delayedCall=new DelayedCall(leave,5);			
			delayedCall.repeatCount=1;
			// TODO Auto Generated method stub
			Starling.juggler.add(delayedCall);
			
			
			// TODO Auto Generated method stub
			
			
		}
		
		
		public function leave():void{
			
			Starling.juggler.remove(delayedCall);
			
			tweenContainer= new Tween(messageContainer,0.5, Transitions.LINEAR);
			tweenContainer.animate("alpha",0);
			
			
			tweenContainer.onComplete=onContainerAnimationLeave;			
			Starling.juggler.add(tweenContainer);	
			
			
			
			
			
			
			
		}
		public function onContainerAnimationLeave():void{
			
			
			dispatchEvent(new TutorialEvent(TutorialEvent.TUTORIAL_PROGRESS,{id:HeroMessage.FINISHED}));
			trace("fez dispatch?");
			this.hide();
			
			
			
			
			
		}
		
		
		
	}
}
package objects
{

	
	import flash.text.TextFieldAutoSize;
	
	import events.TutorialEvent;
	
	import screens.Level;
	
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class BossMessage extends Sprite
	{
		public  var status:Boolean;
		private var messageContainer:Sprite;
		private var levelID:uint;
		
		
		public  static const POSITIVE_FEEDBACK:String="positive";
		public  static const NEGATIVE_FEEDBACK:String="negative";
		public  static const PERCENTAGE_REQ_FEEDBACK:String="percentage";
		public  static const TUTORIAL_MESSAGE:String="tutorial";

		private var feedbackType:String;

		
		private var bossMsgText:TextField;
		private var delayedCall:DelayedCall;
		private var tweenContainer:Tween;
		
		public static const FINISHED:String="bossmessagefinished";
		
		public function BossMessage(idLevel,feedbackType:String)
		{
			this.levelID=idLevel;
			this.feedbackType=feedbackType;
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
			messageContainer.y=stage.stageHeight*0.01;
			//messageContainer.x=context.stage.stageWidth*0.065;
			messageContainer.x=LabQuest._stage.fullScreenWidth;
			var messageBackground:Image=new Image(Assets.getAtlas().getTexture("boss_feedback"));
			messageContainer.addChild(messageBackground);
			messageContainer.visible=false;
			
			var messageBoxWidth:uint=messageContainer.width*0.55;
			var messageBoxHeight:uint=messageContainer.height*0.6;	
			
			
			
			
			
			messageBoxWidth;
			messageBoxHeight;
			bossMsgText=new TextField(messageBoxWidth,messageBoxHeight,"Nunca conseguirás vencer-me!! Uahaha","VitesseBold",16,0x0);
			bossMsgText.x=messageBackground.width*0.05;
			bossMsgText.y=messageBackground.height*0.2;

			bossMsgText.border=false;
			
			//30 palavras
			bossMsgText.text="Ola eu sou uma mensagem"			
			
			messageContainer.addChild(bossMsgText);
			this.addChild(messageContainer);
			
		}
		
		
	
		public function show():void{
			
			status=true;
			//messageContainer.alpha=0;
			messageContainer.x=LabQuest._stage.fullScreenWidth;

			messageContainer.visible=true;

			tweenContainer= new Tween(messageContainer, 0.8, Transitions.EASE_OUT_BACK);
			tweenContainer.animate("x",stage.stageWidth*0.06);
			//tween.animate("x",0);
			
			tweenContainer.onComplete=onContainerAnimationComplete;			
			Starling.juggler.add(tweenContainer);	
			
			if(feedbackType==BossMessage.POSITIVE_FEEDBACK){
			
				bossMsgText.text=getPositiveMessage();
				bossMsgText.text=bossMsgText.text.toUpperCase();

			}
			if(feedbackType==BossMessage.NEGATIVE_FEEDBACK){

				
				bossMsgText.text=getNegativeMessage();
				bossMsgText.text=bossMsgText.text.toUpperCase();


			
			}
			if(feedbackType==BossMessage.PERCENTAGE_REQ_FEEDBACK){
				
				bossMsgText.text="Pensavas que seria assim tão fácil? Era o que faltava! Tens que acertar mais perguntas para me enfrentares!";
				bossMsgText.text=bossMsgText.text.toUpperCase();
				
				
			}
		}
			
			public function showCustomMessage(message:String):void{
				
				status=true;
				//messageContainer.alpha=0;
				messageContainer.x=LabQuest._stage.fullScreenWidth;
				
				messageContainer.visible=true;
				
				tweenContainer= new Tween(messageContainer, 0.8, Transitions.EASE_OUT_BACK);
				tweenContainer.animate("x",stage.stageWidth*0.06);
				//tween.animate("x",0);
				
				tweenContainer.onComplete=onContainerAnimationComplete;			
				Starling.juggler.add(tweenContainer);	
				
					
					bossMsgText.text=message;
					bossMsgText.text=bossMsgText.text.toUpperCase();
					
				
		
		
			
	
			
			
			

			

		}
		
		
	
		public function hide():void{
		
		
			//bossMsgText.visible=false;
			//bossMsgText.alpha=0;
			

			Starling.juggler.remove(delayedCall);
			Starling.juggler.remove(tweenContainer);

			this.status=false;


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
			
			tweenContainer= new Tween(messageContainer, 1, Transitions.EASE_OUT_BACK);
			tweenContainer.animate("x",stage.stageWidth);

			
			tweenContainer.onComplete=onContainerAnimationLeave;			
			Starling.juggler.add(tweenContainer);	

			
			

			

			
		}
		public function onContainerAnimationLeave():void{
		
			dispatchEvent(new TutorialEvent(TutorialEvent.TUTORIAL_PROGRESS,{id:BossMessage.FINISHED}));
			this.hide();
		

		
		
		}
		public function getPositiveMessage():String{
			
		
			
			var xmlAux:XML=Assets.getXMLData();
			var message:String;
			var aux:uint=xmlAux.level.(@id==levelID).bossmessage.positive.length() as uint;
			var random:uint=Math.random()*aux;
			trace("numero respostas"+aux);
			
			
			message=xmlAux.level.(@id==levelID).bossmessage.positive.(@id==random);
			trace("MESSAGE ?????"+message);
			
			return  message;
			
		}
		
		public function getNegativeMessage():String{
			
			
			
			var xmlAux:XML=Assets.getXMLData();
			var message:String;
			var aux:uint=xmlAux.level.(@id==levelID).bossmessage.negative.length() as uint;
			var random:uint=Math.random()*aux;
			trace("numero respostas"+aux);
			
			
			message=xmlAux.level.(@id==levelID).bossmessage.negative.(@id==random);
			trace("MESSAGE ?????"+message);
			
			return  message;
			
		}
		
		
	}
}
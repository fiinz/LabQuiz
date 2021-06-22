package screens
{
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.Button;
	import events.NavigationEvent;
	public class Info extends Sprite
	{
		private var backBtn:Button;
		public function Info()
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			// TODO Auto Generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this.visible=false;
			trace("info");
			
		}		
		public function initialize():void{
		
			var infoBackground:Image=new Image(Assets.getTexture("Info"));
			 backBtn=new Button(Assets.getAtlas().getTexture("btn_back_on"));
			backBtn.x=-10;
			backBtn.y=stage.stageHeight*0.1;
			this.addChild(infoBackground);
			this.addChild(backBtn);
			this.addEventListener(Event.TRIGGERED,onMainMenuClick);


		
		}
		public function show():void{
		
			this.visible=true;;
		
		}
		
		public function disposeTemporarily():void{
			
			this.visible=false;
		}
		private function onMainMenuClick(e:Event):void
		{
			if (!Sounds.muted){
				Sounds.sndFxMenu.play();
			}
			// TODO Auto Generated method stub
			//buttonClicked é uma auxiliar para ver qual o botao que foi clicado
			var buttonClicked:Button=e.target as Button;
			//caso tenha sido o button startButton
			if((buttonClicked as Button )==backBtn){
				trace("clicou no botao back");
				//ao fazer o dispatch o game está à escuta deste evento e comunica que é necessário mudar de ecrã e vai para o ecra level
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.GO_HOME},true));
				
				
			}
		}
		
	}
}
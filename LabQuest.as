package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	
	import org.gestouch.core.Gestouch;
	import org.gestouch.extensions.native.NativeTouchHitTester;
	import org.gestouch.extensions.starling.StarlingDisplayListAdapter;
	import org.gestouch.extensions.starling.StarlingTouchHitTester;
	import org.gestouch.input.NativeInputAdapter;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import org.gestouch.extensions.native.NativeDisplayListAdapter;

	

	//cuidado com as aspas e pelicas deve ser aspas e TEM DE SER ANTES da CLASSE
	[SWF(width="640",height="960",backgroundColor="#b6e0de",frameRate="60")]
	
	public class LabQuest extends MovieClip
		
		
	{
		
		
		private var stats:Stats;
		private var _starling:Object;
		
		private var myStarling:Starling;
		public static var textLoaderPerc:TextField;
		public static var  _stage:Stage;
		
		public static var viewPort:Rectangle;

		private static const PROGRESS_BAR_HEIGHT:Number = 20;
	
		
		public function LabQuest():void{
			super();

			this.stop();
			
			textLoaderPerc=new TextField();
			//textLoaderPerc.border=true;
			textLoaderPerc.text="A CARREGAR O JOGO...";
			textLoaderPerc.autoSize="center";
			textLoaderPerc.x=stage.stageWidth/2-textLoaderPerc.width*0.5;
			textLoaderPerc.y=stage.fullScreenHeight/4;	
			
			var textForm:TextFormat=new TextFormat();
			
			textForm.size = (20);		
			textForm.align=TextFormatAlign.CENTER
			textForm.blockIndent=0;
			textForm.color=0x288798;
			
			textForm.font ="VitesseBook"; 
			textLoaderPerc.setTextFormat(textForm);
	
			
			addChild(textLoaderPerc);
			
			//the two most important events for preloading
			//this.loaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, loaderProgress);
			this.loaderInfo.addEventListener(flash.events.Event.COMPLETE, loaderComplete);
		
		
		}

		public function loaderProgress(event:ProgressEvent):void{
		
		this.graphics.clear();
		this.graphics.beginFill(0x000000);
		this.graphics.drawRect(0, (this.stage.stageHeight - PROGRESS_BAR_HEIGHT) / 2,
		this.stage.stageWidth * event.bytesLoaded / event.bytesTotal, PROGRESS_BAR_HEIGHT);
		
		trace(this.stage.stageWidth * event.bytesLoaded / event.bytesTotal);
		this.graphics.endFill();
		
		}
		
	
		
	
		public function loaderComplete(e:Event):void{
		
			
			//removeChild(textLoaderPerc);
			this.gotoAndStop(2);

			var screenWidth:int=stage.fullScreenWidth;
			var screenHeight:int=stage.fullScreenHeight;

			this.graphics.clear();
			
			//only in ANDROID
			Starling.handleLostContext=true;
			const StarlingType:Class = getDefinitionByName("starling.core.Starling") as Class;
			const MainType:Class = getDefinitionByName("Game") as Class;
			
		
			
			LabQuest.viewPort= RectangleUtil.fit(new Rectangle(0,0,640,960),new Rectangle(0,0,stage.fullScreenWidth,stage.fullScreenHeight),ScaleMode.SHOW_ALL);

			stats= new Stats();
			//this.addChild(stats);

			myStarling= new StarlingType(Game, stage,viewPort);
			myStarling.stage.stageWidth=640;
			myStarling.stage.stageHeight=960;
			//myStarling.showStats=true;
			myStarling.antiAliasing=1;
			
			
			
			
			//Gestouch.inputAdapter ||= new NativeInputAdapter(stage);
		
				
			myStarling.start();
			LabQuest._stage=this.stage;
			
			Gestouch.inputAdapter=new NativeInputAdapter(stage);			
			Gestouch.addDisplayListAdapter(starling.display.DisplayObject, new StarlingDisplayListAdapter());
			Gestouch.addDisplayListAdapter(flash.display.DisplayObject, new NativeDisplayListAdapter());
			Gestouch.addTouchHitTester(new NativeTouchHitTester(stage));
			Gestouch.addTouchHitTester(new StarlingTouchHitTester(myStarling), -1);


			
				
	
		
		}
		
		
		
	}
}
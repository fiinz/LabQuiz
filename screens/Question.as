package screens
{
	import flash.media.SoundMixer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import data.PlayerStats;
	
	import events.NavigationEvent;
	import events.TimerEvent;
	
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import utils.CountDown;
	import utils.TimerBar;
	
	
	public class Question extends Sprite
	{
		
		
		//vai fazer track das questoes atuais para nao repetir dentro do mesmo spot
		public var trackQuestionsID:Vector.<uint>;
		private var newCountDown:CountDown;
		
		public var spotNumQuestions:uint;
		
		private var newTimerBar:TimerBar
		
		private var bgQuestion:Image;
		private var trueButton:Button;
		private var falseButton:Button;
		private var closeQuestionButton:Button;
		private var nextQuestionButton:Button;
		
		
		//imagens que aparecem ao processar resposta.
		private var wrongAwnserImage:Image;
		private var rightAwnserImage:Image;
		private var timeOverAwnserImage:Image;
		
		
		
		
		
		
		private var questionText:flash.text.TextField;
		private var feedbackText:flash.text.TextField;
		
		
		//estaticia do jogo
		public static var countCorrect:uint;
		public static var countInCorrect:uint;
		private var currentQuestionCorrectAwnser:Boolean;
		
		//identificaçao do level, spot e da questao atuais
		private var levelID:uint;
		private var spotID:uint;
		private var questionID:uint;
		
		//numero de questoes ja feitas e o numero maximo de questoes
		private var questionNumber:uint=0;
		
		//estado da questao
		private var questionState:uint;
		private const LAUNCHING_NEW_QUESTION:uint=0;
		private const AWNSER_FEEDBACK:uint=1;
		private const LAUNCHING_NEW_CHALLENGE:uint=2;
		
		
		
		private var questionBoxWidth:uint;
		private	var questionBoxHeight:uint;
		private	var questionOx:Number;
		private	var questionOy:Number;
		private	var feedbackOx:Number;
		private	var feedbackOy:Number;
		
		private var delayedCall:DelayedCall;
		
		private var referenceForWidthSize:Number=0;
		private var referenceWidth:Number;
		private var referenceHeight:Number;
		
		
		public function Question(){
			
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void
		{
			// TODO Auto Generated method stub
			this.visible=false;
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			drawQuestionScreen();
			
			
			
			
		}
		
		public function initialize(currentLevelId:uint,spotID:uint,numQuestions:uint):void{
			
			lcd.y=-lcd.height;
			
			//	newTimerBar
			
			
			//iniciar variaveis
			this.levelID=currentLevelId;
			this.spotID=spotID;
			this.spotNumQuestions=numQuestions;
			falseButton.enabled=false;
			trueButton.enabled=false;
			//incializa sempre o vetor para esquecer as perguntas que foram feitas no spot
			
			trackQuestionsID=new Vector.<uint>();
			Question.countCorrect=0;
			Question.countInCorrect=0;
			
			//verificar o dt
			
			
			//repor a caixa de feedback invisivel
			feedbackText.text="";
			
			
			//o question number deve ficar antes de lançar a nova questao pq a funcao launchNew question incrementa a variavel
			questionNumber=0;
			
			show();
			wrongAwnserImage.visible=false;
			rightAwnserImage.visible=false;
			timeOverAwnserImage.visible=false;
			feedbackText.text=""
			
			
			
			tweenLcd = new Tween(lcd, 1.7, Transitions.EASE_OUT);
			tweenLcd.animate("y", -140);
			tweenLcd.onComplete=onLcdEndAnimation;
			
			Starling.juggler.add(tweenLcd);
			
			
			
			
			
			
			
			
		}
		private var tweenLcd:Tween;
		public function onLcdEndAnimation():void{
			
			Starling.juggler.remove(tweenLcd);
			newCountDown.startCountDown();
			
			this.addEventListener(TimerEvent.COUNT_DOWN_FINISHED,onCountDownFinished);
		}
		
		
		public function show():void{
			
			
			LabQuest._stage.color=0xb6e0de;
			stage.color=0xb6e0de;
			
			this.visible=true;
			
			//adicionar as caixas de texto		
			
			
			Starling.current.nativeStage.addChild(feedbackText);
			Starling.current.nativeStage.addChild(questionText);
			Sounds.currentMusic=Sounds.sndBgQuestion;

			if(!Sounds.muted && Game.isActive){
				SoundMixer.stopAll();
				Sounds.musicChannel=Sounds.currentMusic.play(0,999);				
				Sounds.state=Sounds.MUSIC_QUESTION;
			}
			
			
			
			
			
		}
		
		
		
		private function drawTextFieldsListDisplay():void{
			
			referenceWidth=LabQuest._stage.fullScreenWidth; 
			referenceHeight=LabQuest._stage.fullScreenHeight;
			var auxWidth:Number;
			
			if(stage.stageWidth<=LabQuest._stage.fullScreenWidth){
				

				trace("MENOR OU IGUAL?????????????????????????????");

				
				referenceForWidthSize=stage.stageWidth;
				trace("largura que ele assume  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"+referenceWidth);
				auxWidth=0.86;
				
			}
			else{
				
				trace("MAIOR ?????????????????????????????");
				referenceForWidthSize=LabQuest._stage.fullScreenWidth;
				auxWidth=LabQuest._stage.fullScreenWidth/stage.stageWidth*0.83;
				
			}
			
		/*if(stage.width<=LabQuest._stage.fullScreenWidth){
			
			
			referenceForWidthSize=stage.width
			auxWidth=0.86;
			
			}
			else{
				referenceForWidthSize=LabQuest._stage.fullScreenWidth;
				auxWidth=LabQuest._stage.fullScreenWidth/stage.width*0.83;
			
			}
		*/
			
			trace("refrence"+referenceWidth);
			
			trace("lcd width"+this.lcd.width);
			if(referenceWidth>1000){
				
				auxWidth=1536/640;
				trace("o auxwidth ficou em "+auxWidth);
				auxWidth*=0.8;
			}
			
			
			
			questionBoxWidth=this.lcd.width*auxWidth;

			trace("box width"+questionBoxWidth);
			trace("question box width");
			questionBoxHeight=referenceHeight*0.23;
			questionText=new flash.text.TextField();
			
			questionOx=(referenceWidth*0.5)-questionBoxWidth/2;
			questionOy=referenceHeight*0.2;
			
			//30 palavras
			questionText.text=""
			questionText.width=questionBoxWidth;
			questionText.height=questionBoxHeight;
			questionText.selectable=false;
			questionText.multiline=true;
			questionText.wordWrap=true;
			questionText.border=false;
			//questionText.border=true;
			
			
			//colocar ao meio
			questionText.x=Math.ceil(questionOx);
			questionText.y=Math.ceil(questionOy);
			
			
			feedbackOx=referenceWidth*0.5-questionBoxWidth/2
			feedbackOy=referenceHeight*0.4;
			
			
			feedbackText=new flash.text.TextField();
			
			feedbackText.text=""
			feedbackText.antiAliasType="advanced";
			
			feedbackText.width=questionBoxWidth;
			
			
			feedbackText.height=questionBoxHeight*0.8;
			
			feedbackText.x=Math.ceil(feedbackOx);
			feedbackText.y=Math.ceil(feedbackOy);
			feedbackText.selectable=false;
			feedbackText.wordWrap=true;
			
			feedbackText.border=false;
			feedbackText.multiline=true;
			
			
			
			
			
			
			
		}
		
		
		
		
		
		private var lcd:Image;
		private function drawQuestionScreen():void{
			
			
			//background da questao
			//bgQuestion=new Image(Assets.getTexture("QuestionBackground"));
			
			//o stage do webview é o nativo e nao o do sprite
			//questionWebView.stage = Starling.current.nativeStage;
			
			
			//textfield da pontuaçao
			newTimerBar=new TimerBar(this);
			newTimerBar.drawTimer(stage.stageWidth*0.8,stage.stageHeight*0.9);
			newTimerBar.hide();
			lcd= new Image(Assets.getAtlas().getTexture("lcd"));
			addChild(lcd);
			lcd.x=stage.stageWidth/2-lcd.width/2;
			lcd.y=-lcd.height;
			
			
			
			
			
			trueButton=new Button(Assets.getAtlas().getTexture("true_button"));
			trueButton.x=Math.ceil(stage.stageWidth*0.5-trueButton.width*0.9);
			
			falseButton=new Button(Assets.getAtlas().getTexture("false_button"));
			falseButton.x=Math.ceil(stage.stageWidth*0.5-falseButton.width*0.1);
			
			trueButton.y=falseButton.y=Math.ceil(stage.stageHeight*0.75-trueButton.height/2);
			
			
			/*			closeQuestionButton=new Button(Assets.getTexture("CloseQuestionButton"));
			*/		/*	nextQuestionButton= new Button(Assets.getTexture("NextQuestionButton"));
			nextQuestionButton.visible=false;*/
			
			/*			closeQuestionButton.x=stage.stageWidth*0.9;
			closeQuestionButton.y=stage.stageHeight*0.1;*/
			
			//primeiro deve adicionar o background
			//this.addChild(bgQuestion)
			
			drawTextFieldsListDisplay();
			
			this.addChild(trueButton);
			this.addChild(falseButton);
			//this.addChild(closeQuestionButton);
			
			this.addEventListener(Event.TRIGGERED,onQuestionScreenClicked);
			
			
			
			// the sprite works like you're used to
			//sprite.addChild(anotherObject);
			
			// set the mask rectangle in stage coordinates
			
			
			
			
			//feedback das respostas
			wrongAwnserImage=new Image(Assets.getAtlas().getTexture("wrong_awnser"));
			rightAwnserImage=new Image(Assets.getAtlas().getTexture("right_awnser"));
			timeOverAwnserImage=new Image(Assets.getAtlas().getTexture("timeover_awnser"));
			wrongAwnserImage.visible=false;
			rightAwnserImage.visible=false;
			timeOverAwnserImage.visible=false;
			
			wrongAwnserImage.x=rightAwnserImage.x=timeOverAwnserImage.x=Math.ceil(stage.stageWidth/2-timeOverAwnserImage.width/2);
			wrongAwnserImage.y=rightAwnserImage.y=timeOverAwnserImage.y=Math.ceil(stage.stageHeight*0.27-timeOverAwnserImage.height/2);
			
			
			
			
			
			this.addChild(wrongAwnserImage);
			this.addChild(rightAwnserImage);
			this.addChild(timeOverAwnserImage);
			
			newCountDown= new CountDown(this,stage.stageWidth*0.5,this.stage.stageHeight*0.35);
			
			
			
			
			
		}
		
		private function onQuestionScreenClicked(e:Event):void
		{
			var auxButton:Button=e.target as Button;
			
			if(this.questionState!=this.AWNSER_FEEDBACK){
				
				
				
				
				if(auxButton==trueButton){
					
					
					processPlayerInput(true);
					falseButton.enabled=false;
					trueButton.enabled=false;
					
					
					
					
				}
				if(auxButton==falseButton){
					
					processPlayerInput(false);
					falseButton.enabled=false;
					trueButton.enabled=false;
					
					
					
					
					
				}
				
				
				
				
			}else{
				
				
				launchNewQuestion();
				
				
			}
			
			// TODO Auto Generated method stub
			
		}
		
		
		
		private function delay():void{
			
			
			Starling.juggler.remove(delayedCall);
			Starling.juggler.purge();
			
			
			
			//ainda ha novas questoes ?
			if(this.questionNumber<spotNumQuestions)
			{
				launchNewQuestion();
				
				
				
			}
			else
			{
				// já respondeu todas as questões
				// esconder tudo 
				//remover as caixas de texto da display list
				
				Starling.current.nativeStage.removeChild(feedbackText);
				Starling.current.nativeStage.removeChild(questionText);
				this.newTimerBar.hide();
				
				
				//verificar as pontuaçoes
				if(PlayerStats.spotsScore[this.levelID-1][this.spotID]<Question.countCorrect){
					
					PlayerStats.spotsScore[this.levelID-1][this.spotID]=Question.countCorrect;
					trace("melhorou pontuacao"+PlayerStats.spotsScore[this.levelID-1][this.spotID]);
					
				}
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN,{id:Game.RESUME_LEVEL},true));
				
				
				
				
			}
			
			
			
		}
		
		private function onAwnserTimeOut(e:TimerEvent):void
		{
			this.removeEventListener(TimerEvent.TIME_OUT,onAwnserTimeOut);
			
			if (!Sounds.muted && Game.isActive){
				Sounds.sndFxTimeOut.play();
			}
			
			
			newTimerBar.stopTimer();
			falseButton.enabled=false;
			trueButton.enabled=false;
			
			questionText.text="";
			feedbackText.htmlText=getIncorrectAwnserFeedback(this.levelID,this.spotID,this.questionID);
			PlayerStats.historyIncorrectAwnsers++;
			Question.countInCorrect++;
			
			//timeOut
			
			timeOverAwnserImage.visible=true;
			
			//so posso formatar depois de ter texto na caixa
			var tfFeedback:TextFormat = new TextFormat();			
			tfFeedback.size = (referenceWidth/28);		
			tfFeedback.align=TextFormatAlign.CENTER
			tfFeedback.blockIndent=0;
			tfFeedback.color=0x524d49;
			
			tfFeedback.font ="VitesseBold"; 
			//tfFeedback.font ="VitesseBook"; 
			feedbackText.setTextFormat(tfFeedback);
			feedbackText.embedFonts=true;
			
			//delay para a pergunta e a resposta desaparecerem e lançar proxima fase 
			trace("acertaste"+countCorrect);
			trace("erraste"+countInCorrect);
			
			trace("feedbackText.length"+feedbackText.length);
			delayedCall=new DelayedCall(delay,3+(feedbackText.length*0.018));
			delayedCall.repeatCount=0;
			Starling.juggler.add(delayedCall);
			
			
			
		}
		
		private function processPlayerInput(playerInput:Boolean):void
		{
			
			//player Input
			// pode ser igual true , false ou null ( quando o jogador nao responde).
			trace(" E O IMPUT FOI :"+playerInput);
			questionState=this.AWNSER_FEEDBACK;
			
			newTimerBar.stopTimer();
			this.removeEventListener(TimerEvent.TIME_OUT,onAwnserTimeOut);
			
			questionText.text="";
			
			// TODO Auto Generated method stub
			if(playerInput==currentQuestionCorrectAwnser)
			{
				
				questionText.text="";
				
				feedbackText.htmlText=getCorrectAwnserFeedback(this.levelID,this.spotID,this.questionID);
				
				
				
				Question.countCorrect++;
				PlayerStats.historyCorrectAwnsers++;
				
				if (!Sounds.muted){
					Sounds.sndFxCorrectAwnser.play();
				}
				rightAwnserImage.visible=true;

				
				
			}
			else{
				questionText.text="";
				feedbackText.htmlText=getIncorrectAwnserFeedback(this.levelID,this.spotID,this.questionID);
				

				PlayerStats.historyIncorrectAwnsers++;
				countInCorrect++;
				
				if (!Sounds.muted){
					Sounds.sndFxWrongAwnser.play();
				}
				
				
				wrongAwnserImage.visible=true;
				
				
				
				
			}
			
			
			//so posso formatar depois de ter texto na caixa
			var tfFeedback:TextFormat = new TextFormat();	
			//feedbackText.htmlText="A criptografia é a forma de passar uma mensagem de uma forma original para uma codificada, apenas compreensível para quem tiver uma “chave” decifradora";
			tfFeedback.size = (referenceWidth/28);		
			tfFeedback.align=TextFormatAlign.CENTER;
			tfFeedback.blockIndent=0;
			tfFeedback.color=0x524d49;
			tfFeedback.font ="VitesseBold"; 
			feedbackText.embedFonts=true;
			feedbackText.setTextFormat(tfFeedback);
			
			
			//delay para a pergunta e a resposta desaparecerem e lançar proxima fase 
			trace("acertaste"+countCorrect);
			trace("erraste"+countInCorrect);
			
			trace("feedbackText.length"+feedbackText.length);
			delayedCall=new DelayedCall(delay,3+(feedbackText.length*0.018));
			delayedCall.repeatCount=0;
			Starling.juggler.add(delayedCall);			
			
		}
		
		
		private function onCountDownFinished (e:TimerEvent):void{
			trace("remover count down");
			
			this.removeEventListener(TimerEvent.COUNT_DOWN_FINISHED,onCountDownFinished);
			launchNewQuestion();
			
			
		}
		
		private function launchNewQuestion():void
		{
			
			wrongAwnserImage.visible=false;
			rightAwnserImage.visible=false;
			timeOverAwnserImage.visible=false;
			feedbackText.text=""
			
			
			
			// TODO Auto Generated method stub
			// faz pedido para obter nova questão
			this.questionID=getNewQuestionID(levelID,spotID);
			//guarda no vetor a pergunta que saiu
			this.trackQuestionsID.push(questionID);
			
			//faz o pedido ao xml e guarda o retorno na caixa de texto
			this.questionText.htmlText=getQuestionText(levelID,spotID,questionID);
			this.questionText.htmlText=this.questionText.htmlText.toUpperCase();
			
		//	this.questionText.htmlText="A criptografia é a forma de passar uma mensagem de uma forma original para uma codificada, apenas compreensível para quem tiver uma “chave” decifradora";
			var tfQuestion:TextFormat = new TextFormat();
			tfQuestion.font="VitesseBold";
			tfQuestion.color=0x2b2825
			tfQuestion.size = int(LabQuest._stage.fullScreenWidth/26);		
			tfQuestion.align=TextFormatAlign.CENTER;
			
			tfQuestion.blockIndent=0;
			
			//so pode formatar depois de ter o texto
			questionText.setTextFormat(tfQuestion);
			questionText.embedFonts=true;
			questionText.antiAliasType="advanced";
			
			questionText.y=questionOy+Math.round((questionText.height-questionText.textHeight)/2);
			
			
			
			this.currentQuestionCorrectAwnser=getQuestionCorrectAwnser(levelID,spotID,questionID);
			//trace("aqui no main ficou a "+currentQuestionCorrectAwnser);
			
			questionState=this.LAUNCHING_NEW_QUESTION;
			
			falseButton.enabled=true;
			trueButton.enabled=true;
			questionNumber++;
			PlayerStats.historyTotalQuestions++;
			//trace("n questao"+questionNumber);
			
			newTimerBar.resetTimer();
			newTimerBar.setDuration(10+(this.questionText.length)*0.05);
			newTimerBar.startTimer();
			newTimerBar.show();
			this.addEventListener(TimerEvent.TIME_OUT,onAwnserTimeOut);
			
			
			
		}
		
		
		
		
		public function disposeTemporarily():void{
			this.visible=false;
			
			
			
			
			
		}
		
		
		//a ideia será criar um método que primeiro sorteie um id válido de acordo com o level e com o spot
		public function getNewQuestionID(idLevel:uint,idSpot:uint):uint{
			
			
			var xmlAux:XML=Assets.getXMLData();
			var spotTotalNumQuestions:uint;
			
			var validQuestionID:Boolean=false;
			//trackQuestionsID
			
			spotTotalNumQuestions=xmlAux.level.(@id==idLevel).spot.(@id==idSpot).question.length();
			//trace("quantas questoes tem o spot ?" +spotTotalNumQuestions);
			
			
			//alterar isto porque está a sortear entre dois é preciso sortear dentro do grupo
			while(validQuestionID==false)
			{
				var newQuestionID:int=Math.random()*spotTotalNumQuestions;
				var count:uint=0;
				for(var i:uint=0;i<trackQuestionsID.length;i++)
				{
					if(newQuestionID==trackQuestionsID[i])
					{
						count++;
						
					}
					
				}
				if(count==0){validQuestionID=true;}
				
				
			}
			
			//trace("questao sorteada , deve corrigir e verificar quais é que ja foram lançadas");
			
			
			//trace("track das questoes"+trackQuestionsID);
			return newQuestionID;
			
		}
		
		
		//verificar o que está a ser passado !!!! a funcao foi mudada
		
		//depois de ter o id obter a questao
		public function getQuestionText(idLevel:uint,idSpot:uint,newQuestionID):String{
			
			var xmlAux:XML=Assets.getXMLData();
			var auxQuestion:String;
			
			
			auxQuestion=xmlAux.level.(@id==idLevel).spot.(@id==idSpot).question.(@id==newQuestionID).text;
			
			
			return  auxQuestion;
			
		}
		
		public function getQuestionCorrectAwnser(idLevel:uint,idSpot:uint,newQuestionID):Boolean{
			
			var xmlAux:XML=Assets.getXMLData();
			var aux:String;
			var auxCorrectAwnser:Boolean;
			
			aux=XML(xmlAux.level.(@id==idLevel).spot.(@id==idSpot).question.(@id==newQuestionID).attribute("awnser"));
			auxCorrectAwnser= (aux == "true") ? true : false;
			
			
			return  auxCorrectAwnser;
			
		}
		
		
		
		
		
		//feedback de ter acertado
		public function getCorrectAwnserFeedback(idLevel:uint,idSpot:uint,idQuestion:uint):String{
			
			var xmlAux:XML=Assets.getXMLData();
			
			var auxFeedback:String;
			
			auxFeedback=xmlAux.level.(@id==idLevel).spot.(@id==idSpot).question.(@id==idQuestion).correct;
			
			
			
			return auxFeedback;
		}
		
		
		//feedback de ter errado
		public  function getIncorrectAwnserFeedback(idLevel:uint,idSpot:uint,idQuestion:uint):String
		{
			var xmlAux:XML=Assets.getXMLData();
			
			var auxFeedback:String;
			
			auxFeedback=xmlAux.level.(@id==idLevel).spot.(@id==idSpot).question.(@id==idQuestion).incorrect;
			return auxFeedback;
			
		}
		
		
		
		
		
		
		
	}
}
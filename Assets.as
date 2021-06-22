package
{
	import flash.display.Bitmap;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import flash.display.BitmapData;
	
	
	public class Assets
	{
		
		//dados do jogo, perguntas, e waypoints
		
		[Embed(source="data/game_data.xml",mimeType="application/octet-stream"))]
		public static const QuizXML:Class;
		
		
		//imagens da introdução, sequencia
		
		[Embed(source="graphics/cutscenes/intro/intro_1.png")]
		public static const Intro1:Class;
		
		[Embed(source="graphics/cutscenes/intro/intro_2.png")]
		public static const Intro2:Class;
		
		[Embed(source="graphics/cutscenes/intro/intro_3.png")]
		public static const Intro3:Class;
		
		[Embed(source="graphics/cutscenes/intro/intro_4.png")]
		public static const Intro4:Class;

		
	/*	[Embed(source="graphics/hero.png")]
		public static const Hero:Class;*/
		
		//quadros do nível de jogo
		[Embed(source="graphics/cutscenes/levelcomplete/level_01.png")]
		public static const Level1Complete:Class;
		
		
		[Embed(source="graphics/cutscenes/levelcomplete/level_02.png")]
		public static const Level2Complete:Class;
		
		[Embed(source="graphics/cutscenes/levelcomplete/level_03.png")]
		public static const Level3Complete:Class;
		
		[Embed(source="graphics/cutscenes/levelcomplete/level_04.png")]
		public static const Level4Complete:Class;
		
		[Embed(source="graphics/cutscenes/bosscutscene/bosscutscene.png")]
		public static const BossCutScene:Class;
		
		[Embed(source="graphics/cutscenes/gamecomplete/final.jpg")]
		public static const FinalCutScene:Class;
		
		
		[Embed(source="graphics/cutscenes/gamecomplete/drbright.png")]
		public static const DrBright:Class;
		
		[Embed(source="graphics/cutscenes/gamecomplete/estaslivre.png")]
		public static const EstasLivre:Class;
		
		[Embed(source="graphics/cutscenes/gamecomplete/venceste.png")]
		public static const Venceste:Class;
		
		[Embed(source="graphics/cutscenes/gamecomplete/balance.jpg")]
		public static const Balance:Class;
		
		
		[Embed(source="graphics/panels/info.jpg")]
		public static const Info:Class;
		
	
		
		
		
	

		
		
		[Embed(source="graphics/levels/level_01.jpg")]
		public static const Level1Background:Class;
		
		[Embed(source="graphics/levels/level_02.jpg")]
		public static const Level2Background:Class;
		
		[Embed(source="graphics/levels/level_03.jpg")]
		public static const Level3Background:Class;
		
		[Embed(source="graphics/levels/level_04.jpg")]
		public static const Level4Background:Class;
		
		[Embed(source="graphics/levels/level_05.jpg")]
		public static const Level5Background:Class;
		
		
		
		
		//quadros do nível de jogo
		[Embed(source="graphics/backgrounds/background_challenge_01.jpg")]
		public static const Challenge1Background:Class;
		
		[Embed(source="graphics/backgrounds/background_challenge_02.jpg")]
		public static const Challenge2Background:Class;
		
		[Embed(source="graphics/backgrounds/background_challenge_03.jpg")]
		public static const Challenge3Background:Class;
		
		[Embed(source="graphics/backgrounds/background_challenge_04.jpg")]
		public static const Challenge4Background:Class;
		
		[Embed(source="graphics/backgrounds/background_challenge_05.jpg")]
		public static const Challenge5Background:Class;
		
	
		
		//fontes 
		[Embed(source="fonts/Vitesse-Bold.otf",fontFamily="VitesseBold",embedAsCFF="false",mimeType="application/x-font-truetype")]
		public static const VitesseBoldFont:Class;
		[Embed(source="fonts/Vitesse-BoldItalic.otf",fontStyle="italic",fontFamily="VitesseBold",embedAsCFF="false",mimeType="application/x-font-truetype")]
		public static const VitesseBoldItalicFont:Class;
		
		[Embed(source="fonts/Vitesse-Book.otf",fontFamily="VitesseBook",embedAsCFF="false",mimeType="application/x-font-truetype")]
		public static const VitesseLightFont:Class;
		[Embed(source="fonts/Vitesse-BookItalic.otf",fontStyle="italic",fontFamily="VitesseBook",embedAsCFF="false",mimeType="application/x-font-truetype")]
		public static const VitesseLightItalicFont:Class;
		
		//criar atlas para as bitmap fonts
/*		[Embed(source="fonts/myGlyphs.png")]
		public static const FontTexture:Class;*/
		

		
	
		
		
		
		[Embed(source="graphics/spriteSheet.png")]
		public static const AtlasTextureGame:Class;
		
		[Embed(source="graphics/spriteSheet.xml",mimeType="application/octet-stream"))]
		public static const AtlasXmlGame:Class;
		
		
		// Dictionary é tipo um array de chaves.
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
		
		
		/*public static function getFont():BitmapFont{
			
			
			// ele cria a textura atraves do ficheiro que criamos neste momento está especifico para a FontTexture que criamos 
			var fontTexture:Texture=Texture.fromBitmap(new FontTexture());
			// vai buscar o FontXML a classe que criamos e obtem o xml
			var fontXML:XML=XML(new FontXML());
			// cria uma bitmap font baseada na textura e no xml
			var font:BitmapFont=new BitmapFont(fontTexture,fontXML);
			
			//registar a font
			TextField.registerBitmapFont(font);
			
			return font;
			
		}*/
		public static function getTexture(name:String):Texture{
			
			//se nao existe a textura cria uma nova instancia de Bitmap a partir do nome
			
			if(gameTextures[name]==undefined){
				
				//cria um bitmap através do nome disponivel em assets e instancia
				var bitmap:Bitmap=new Assets[name]();
				
				//obtem a textura a partir do bitmap e guarda dentro do array Dicionary 
				//fiz disable dos mipmaps
				gameTextures[name]=Texture.fromBitmap(bitmap,false);//utiliza o dicionário para obter a imagem atraves do seu nome
				gameTextures[name].root.restoreOnLostContext(bitmap);
				
					
					}
			//retorna uma textura que já exista no dicionary
			return gameTextures[name];
		}
		public static function getXMLData():XML{
			
			var xml:XML=XML(new QuizXML());
			
			return xml;
		}
		
		public static function getAtlas():TextureAtlas{
			
				if(gameTextureAtlas==null){
				
				//obtem a textura atraves do método de cima
				//ok mas e se quisesse mais imagens ?ah ele combina o Dictionary 
				var texture:Texture=getTexture("AtlasTextureGame");//utiliza a função de cima para obter a textura que é o spritesheet.png
				//converte a classe associada ao AtlasXMlGame para XML e cria o objeto xml
				var xml:XML=XML(new AtlasXmlGame());
				// para alimentar o gameTextureAtlas que terá funcionalidades especificas
				// ele necessida do ficheiro ( texture ) e do xml
				gameTextureAtlas=new TextureAtlas(texture,xml);
				
				
			}
			
			return gameTextureAtlas;
		}
		
		
		
		
		
		
	}
}
package utils
{
	import starling.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class JustifiedTextField extends starling.text.TextField
	{
		public function JustifiedTextField(width:int, height:int, text:String, fontName:String="Verdana", fontSize:Number=12, color:uint=0x0, bold:Boolean=false)
		{
				super(width, height, text, fontName, fontSize, color, bold);
			}
			
			/*protected override function formatText (textField:flash.text.TextField,textFormat:TextFormat):void
			{
				
				textFormat.align = TextFormatAlign.JUSTIFY;
				textField.setTextFormat(textFormat);
				
			}*/
	}
}
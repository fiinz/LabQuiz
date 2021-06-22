package utils
{ 
	import starling.display.Image;
	
	public final class ImagePool 
	{ 
		private static var MAX_VALUE:uint; 
		private static var GROWTH_VALUE:uint; 
		private static var counter:uint; 
		private static var pool:Vector.<Image>; 
		private static var currentImage:Image; 
		
		public static function initialize( maxPoolSize:uint, growthValue:uint ):void 
		{ 
			MAX_VALUE = maxPoolSize; 
			GROWTH_VALUE = growthValue; 
			counter = maxPoolSize; 
			
			var i:uint = maxPoolSize; 
			
			pool = new Vector.<Image>(MAX_VALUE); 
			while( --i > -1 ) 
				pool[i] = new Image(Assets.getAtlas().getTexture("default_image")); 
		} 
		
		public static function getImage():Image 
		{ 
			if ( counter > 0 ) 
				return currentImage = pool[--counter]; 
			
			var i:uint = GROWTH_VALUE; 
			while( --i > -1 ) 
				pool.unshift ( new Image(Assets.getAtlas().getTexture("default_image"))); 
			counter = GROWTH_VALUE; 
			return getImage(); 
			
		} 
		
		public static function disposeImage(disposedImage:Image):void 
		{ 
			pool[counter++] = disposedImage; 
		} 
	} 
}
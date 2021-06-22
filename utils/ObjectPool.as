package utils
{ 
	
	public final class ObjectPool 
	{ 
		private static var MAX_VALUE:uint; 
		private static var GROWTH_VALUE:uint; 
		private static var counter:uint; 
		private static var pool:Vector.<Object>; 
		private static var currentObject:Object; 
		
		public static function initialize( maxPoolSize:uint, growthValue:uint ):void 
		{ 
			MAX_VALUE = maxPoolSize; 
			GROWTH_VALUE = growthValue; 
			counter = maxPoolSize; 
			
			var i:uint = maxPoolSize; 
			
			pool = new Vector.<Object>(MAX_VALUE); 
			while( --i > -1 ) 
				pool[i] = new Object(); 
		} 
		
		public static function getObject():Object 
		{ 
			if ( counter > 0 ) 
				return currentObject = pool[--counter]; 
			
			var i:uint = GROWTH_VALUE; 
			while( --i > -1 ) 
				pool.unshift ( new Object() ); 
			counter = GROWTH_VALUE; 
			return getObject(); 
			
		} 
		
		public static function disposeObject(disposedObject:Object):void 
		{ 
			pool[counter++] = disposedObject; 
		} 
	} 
}
package events
{
	import starling.events.Event;
	
	public class NavigationEvent extends Event
	{
		public static const CHANGE_SCREEN:String="changeScreen";
		public var params:Object;
		public function NavigationEvent(type:String, _params:Object=null,bubbles:Boolean=false)
		{
			
			//evento customizado para trocar de ecrã
			super(type, bubbles, data);
			//this.params é um objeto e passamos um id.
			this.params=_params;
			
			
		}
	}
}
package events
{
	import starling.events.Event;
	
	public class TutorialEvent extends Event
	{

		public static const TUTORIAL_PROGRESS:String="progress";

		public var params:Object;
		public function TutorialEvent(type:String, _params:Object=null,bubbles:Boolean=true)
		{
			
			//evento customizado para trocar de ecrã
			super(type, bubbles, data);
			//this.params é um objeto e passamos um id.
			this.params=_params;
			
			
		}
	}
}
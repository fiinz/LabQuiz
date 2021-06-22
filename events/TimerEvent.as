package events
{
	import starling.events.Event;
	
	public class TimerEvent extends Event
	{
		public static const TIME_OUT:String="time_out";
		public static const COUNT_DOWN_FINISHED:String="count_down_finished";

		public var params:Object;
		public function TimerEvent (type:String, _params:Object=null,bubbles:Boolean=false)
		{
			
			//evento customizado para trocar de ecrã
			super(type, bubbles, data);
			//this.params é um objeto e passamos um id.
			this.params=_params;
			
			
		}
	}
}
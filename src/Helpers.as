package
{
	public class Helpers
	{
		
		private static var randArray:Array = new Array();
		private static var randChar:String;
		private static var randNum:Number;
		private static var color:uint;
		private static var finalProduct:String;
		private static var twoHexVals:String;
		
		public function Helpers()
		{
		}
		
		
		public static function getRandomColor(red:String = null, green:String = null, blue:String = null):uint
		{
			trace("Red: " + red + ", Green: " + green + ", Blue: " + blue);
			
			if(red == null)
				red = getRandomDigit();
			if(green == null)
				green = getRandomDigit();
			if(blue == null)
				blue = getRandomDigit();
			
			finalProduct = "0xFF" + red + green + blue;
			
			trace("Random Color: " + finalProduct);
			
			color = uint(finalProduct);
			
			return color;
		}
		
		public static function getRandomDigit():String
		{
			twoHexVals = new String();
			
			for(var j:int = 0; j < 2; j++)
			{
				randNum = Math.round(Math.random() * 15);
				
				if (randNum <= 5)
					twoHexVals += String("C");
				else if (randNum <= 10)
					twoHexVals += String("D");
				else 
					twoHexVals += String("E");
//				
//				
//				if(randNum < 10)
//				{
//					if (randNum < 5) randNum += 4;
//					twoHexVals += String(randNum);
//				}
//				else
//				{
//					switch(randNum)
//					{
//						case 10:
//							randChar = 'A';
//							break;
//						case 11:
//							randChar = 'B';
//							break;
//						case 12:
//							randChar = 'C';
//							break;
//						case 13:
//							randChar = 'D';
//							break;
//						case 14:
//							randChar = 'E';
//							break;
//						case 15:
//							randChar = 'F';
//							break;
//					}
//					twoHexVals += String(randChar);
//				}
			}
			
			return twoHexVals;
		}
	}
}
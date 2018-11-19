package testfiles.duplicates;

public class ClassWithOneDuplicateBlockOfSevenLines {
	int numberGlobal = 3;
	 
	 public int returnNumber(int count) {
		switch(count) {
			case 1:
				return 1;
			case 2:
				return 2;
			case 3: 
				return 3;
			case 4: 
				return 4;
		default: return 4;
		}
	 }
// comment
	public int getNumber(int number) {
	switch(number) {
	case 1:
		return 1;
	case 2:
		return 2;
	case 3: 
		return 3;
	case 4:
		return 7;
		default: return number;}
	} /* comment*/

	public void setNumber(int number) {
		this.numberGlobal = number;
	}
	 
	/*
	 * comment
	 */

}

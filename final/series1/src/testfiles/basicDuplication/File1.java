package testfiles.basicDuplication;

/*
 *	Within this file there are 2 duplicate lines, 
 *	so the duplicate check should return 0.
 */

public class File1 {
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

	public int getNumber(int number) {
		switch(number) {
			case 1:
				return 1;
			default: return number;
		}
	}

	public void setNumber(int number) {
		this.numberGlobal = number;
	}
}

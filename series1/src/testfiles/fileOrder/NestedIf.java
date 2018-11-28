package testfiles.fileOrder;

public class NestedIf {
	public int nestedifMethod(int number) {
		if(number < 10) {
			if(number < 6) {
				return 7;
			}
			return 10;
		}
		return 8;
	}
}

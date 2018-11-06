module rascalTest
import List;
import IO;
import String;

// first Exercise
// a
// a

list[str] text = ["abc", "def", "ghi"];

int countElements(list[&T] inputList) {
 return size(inputList);
}

list[str] text2 = ["andra", "moi", "ennepe", "Mousa", "polutropon"];
public int count(list[str] text) { 
   n = 0; 
   for(s <- text) 
      if(contains(s,"a")) 
      //or if (/a/ :=s)
        n+=1; 
   
   return n; 
}

public list[str] find(list[str] text){ 
    return for(s <- text) if(/o/ := s) append s; 
}

list[str] text3 = ["the", "jaws", "that", "bite", "the", "claws", "that", "catch"]; 

public list[str] duplicates(list[str] text){ 
    m = {}; 
    return for(s <- text)
    if (s in m) 
    append s; 
    else m += s; 
} 

public bool isPalindrome(list[str] words){
    return words == reverse(words); 
} 




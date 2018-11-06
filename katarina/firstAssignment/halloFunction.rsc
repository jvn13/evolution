module halloFunction

import IO;

void hello() {
   println("Hello world, this is my first Rascal program");
}
// comment
void whileLoop(){
for (i <- [1..8]){
 int counter = 3;
 int newNumber = counter + i;
 println("Zahl: <newNumber>");
}
}
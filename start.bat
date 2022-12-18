javac -cp ./lib/CLIPSJNI.jar -d ./bin ./src/*.java
java -Djava.library.path=.\lib -classpath .\bin;.\lib\CLIPSJNI.jar DressOrPants
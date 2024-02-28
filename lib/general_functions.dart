class GeneralFunctions{
  String getWords({required String data, required int start, int end=-1}){
    if (end == -1) end = data.length;
    if (start > end) return "";
    int spaceCount = 0;
    bool recordLetters = false;
    String content = "";
    for (int i=0; i<data.length; i++){
      // Getting ahead up to deisred spaces
      if (data[i] == " "){
        spaceCount++;
        if (spaceCount == start){
          recordLetters = true;
          continue;
        }else if (spaceCount == end+1){
          return content;
        }
      }
      //

      // Recording the data
      if(recordLetters) content += data[i];
    }
    return content;
  }

}
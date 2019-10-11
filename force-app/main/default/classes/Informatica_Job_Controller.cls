public class Informatica_Job_Controller {
    private object replaceAttributes(String oJson, Map<string,string> xmlReplaceMap)  {
        Map<String,Object> jsonObj = (Map<String,Object>)JSON.deserializeUntyped(oJson);
        Map<String,Object> newObj = new Map<String,Object>();
        
        for(String key : jsonObj.keySet()) {
            if(xmlReplaceMap.containsKey(key)) {
                jsonObj.put(xmlReplaceMap.get(key),jsonObj.get(key));
            } else {
                if(jsonObj.get(key) instanceof Map<String,Object>) {
                    replaceAttributes(json.serialize((Map<String,Object>)jsonObj.get(key)),xmlReplaceMap);
                }
                else if(jsonObj.get(key) instanceof List<Object>) {
                    for(Object listItem : (List<Object>)jsonObj.get(key)) {
                        if(listItem instanceof Map<String,Object>)  {
                            replaceAttributes(json.serialize((Map<String,Object>)listItem),xmlReplaceMap);
                        }
                    }
                }
                else{
                    newObj.put(key, jsonObj.get(key));
                }
            }
        }           
        return newObj;
    }
}
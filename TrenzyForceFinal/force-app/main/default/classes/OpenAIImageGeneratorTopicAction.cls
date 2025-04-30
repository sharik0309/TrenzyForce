public with sharing class OpenAIImageGeneratorTopicAction {
    
    public class RequestBody {
        public String prompt;
        public Integer n = 1;
        public String size = '512x512';
    }

    public class ImageResponse {
        public List<DataItem> data;
    }

    public class DataItem {
        public String url;
    }
    
    public class Request{
        @InvocableVariable
        public String imageDescription;
    }
    
    public class Response{
        @InvocableVariable
        public Blob image;
        
         @InvocableVariable
        public String  image2;
    }
      
    @invocableMethod
    public static List<Response> generateImage(List<Request> requests) { 
        String imageRequest = requests[0].imageDescription;
        list <Response> reponses = new list <Response>();
        Http http = new Http();
        
       /* String ppmt = 'A high-energy Nike advertisement featuring a diverse group of young athletes running through an urban landscape at sunrise, wearing futuristic Nike gear with glowing accents. Bold typography with the slogan \'Own the Morning\' in the background, powerful dynamic motion, and a gritty yet inspirational atmosphere';
        ppmt = 'A close-up of a stylish Nike running shoe on a clean white background, with the Nike logo clearly visible above the shoe. The shoe has a modern, sporty design with sleek lines and soft lighting';
        ppmt='Cristiano Ronaldo running in Nike shoes, captured mid-stride with dynamic energy and the Nike logo in the background. Include the word - JUST DO IT!. Image should be ultra-realistic with high detail photo of Cristiano Ronaldo.focus on his shoes. zoomed-in view on running shoes. Nike logo clearly visible on shoes';
        ppmt='Athelete running in Adidas shoes, captured mid-stride with dynamic energy and the Adidas logo in the background. Image should be ultra-realistic with high detail photo';
       */
         HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.openai.com/v1/images/generations');
       // request.setEndpoint('callout:OpenAI/v1/images/generations');
        request.setMethod('POST');
        request.setTimeout(120000); // 🔧 Increase timeout to 120 seconds
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer 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'); // Use Named Credential instead in production

        RequestBody body = new RequestBody();
        body.prompt = imageRequest;
        request.setBody(JSON.serialize(body));
        
        Response imgRes = new  Response();

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
             System.debug('getStatusCode : ' +response.getStatusCode());                      
             String contentType = response.getHeader('Content-Type');
             if (!contentType.startsWith('image')) {
                  System.debug('Not an image. Body: ' + response.getBody());
                  ImageResponse res = (ImageResponse) JSON.deserialize(response.getBody(), ImageResponse.class);

                Blob imageBlob = uploadImage (res.data[0].url,'GeneratedImagev3','a03dL00000VV3oNQAT');
                imgRes.image = imageBlob;
                reponses.add(imgRes);
              //   return List<List<Response>> {reponses};
             } 
            
         //   return res.data != null && !res.data.isEmpty() ? res.data[0].url : null;
            return reponses;
        } else {
            System.debug('Error: ' + response.getBody());
            return null;
        }
    }
    
    public static Blob uploadImage(String imageUrl, String fileName, Id linkedEntityId) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(imageUrl);
        req.setMethod('GET');
        req.setTimeout(60000); // 60 seconds

        HttpResponse res;
        try {
            res = http.send(req);
        } catch (Exception e) {
            System.debug('Callout failed: ' + e.getMessage());
            return null;
        }

        String contentType = res.getHeader('Content-Type');
        System.debug('Response Content-Type: ' + contentType);
        
        if (res.getStatusCode() == 200 && contentType != null && contentType.startsWith('image')) {
            Blob imageBlob = res.getBodyAsBlob();
           System.debug('Image Content-Type: ' + contentType);

            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName + '.png'; // Ensure extension
            cv.VersionData = imageBlob;
            insert cv;

            ContentVersion insertedCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            Id contentDocId = insertedCV.ContentDocumentId;
            
            // Optionally link the file to a record
            if (linkedEntityId != null) {
                ContentDocumentLink link = new ContentDocumentLink();
                link.ContentDocumentId = contentDocId;
                link.LinkedEntityId = linkedEntityId;
                link.ShareType = 'V'; // Viewer
                insert link;
            }

            System.debug('✅ Uploaded ContentDocumentId: ' + contentDocId);
           /// return contentDocId;
           return imageBlob;
        } else {
            System.debug('❌ Invalid image or expired link. Body: ' + res.getBody());
            return null;
        }
    }
    
  
}
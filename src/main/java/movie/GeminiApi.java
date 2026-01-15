package movie;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class GeminiApi {

    // 1. 변수 선언 (값은 아직 없음)
    private static final String API_KEY;

    // 2. 스태틱 초기화 블록: 서버 켜질 때 딱 한 번 실행되어 파일을 읽어옴
    static {
        String key = "";
        try {
            // secret.properties 파일을 찾아서 엽니다.
            InputStream input = GeminiApi.class.getClassLoader().getResourceAsStream("secret.properties");

            if (input == null) {
                System.out.println("💥 오류: secret.properties 파일을 찾을 수 없습니다!");
            } else {
                Properties prop = new Properties();
                prop.load(input); // 파일 내용을 읽음

                // 파일 안에 적은 "GEMINI_KEY"라는 이름의 값을 꺼냄
                key = prop.getProperty("GEMINI_KEY");
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }

        // 다 읽은 키를 상수에 저장 (이제부터 이 키를 씀)
        API_KEY = key;

        // (확인용) 키가 잘 들어갔는지 콘솔에 살짝 찍어보기 (앞 5자리만)
        if (API_KEY != null && API_KEY.length() > 5) {
            System.out.println("✅ API Key 로드 성공: " + API_KEY.substring(0, 5) + "...");
        }
    }
    // 모델 - 'gemini-2.0-flash'로 지정 (1.5ver 도 가능)
    private static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key="
            + API_KEY;

    public List<String> getRecommendMovieTitles(String userQuery) {
        List<String> titleList = new ArrayList<>();

        try {
            URL url = new URL(API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // 타임아웃 설정 (AI가 생각할 시간 확보)
            conn.setConnectTimeout(5000); // 5초
            conn.setReadTimeout(30000); // 30초

            // --- [프롬프트 설정] ---
            String prompt = "Recommend 5 movies for this request: '" + userQuery + "'. "
                    + "Only return a JSON array of strings containing the Korean movie titles. "
                    + "No other text. Example: [\"Movie A\", \"Movie B\"]";

            // --- [JSON 생성] ---
            JSONObject textPart = new JSONObject();
            textPart.put("text", prompt);

            JSONArray parts = new JSONArray();
            parts.add(textPart);

            JSONObject content = new JSONObject();
            content.put("parts", parts);

            JSONArray contents = new JSONArray();
            contents.add(content);

            JSONObject requestBody = new JSONObject();
            requestBody.put("contents", contents);

            // --- [전송] ---
            OutputStream os = conn.getOutputStream();
            os.write(requestBody.toString().getBytes("UTF-8"));
            os.flush();
            os.close();

            // --- [응답 코드 확인] ---
            int responseCode = conn.getResponseCode();
            BufferedReader br;

            if (responseCode >= 200 && responseCode < 300) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            } else {
                // 에러 발생 시 내용을 읽어서 출력
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
            }

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
            br.close();

            // 에러 체크
            if (responseCode >= 400) {
                System.out.println("API 호출 에러 (코드: " + responseCode + ")");
                System.out.println("메시지: " + sb.toString());
                return titleList;
            }

            // --- [파싱] ---
            JSONParser parser = new JSONParser();
            JSONObject responseObj = (JSONObject) parser.parse(new StringReader(sb.toString()));
            JSONArray candidates = (JSONArray) responseObj.get("candidates");
            JSONObject candidate = (JSONObject) candidates.get(0);
            JSONObject contentObj = (JSONObject) candidate.get("content");
            JSONArray partsArr = (JSONArray) contentObj.get("parts");
            JSONObject part = (JSONObject) partsArr.get(0);

            String aiText = (String) part.get("text");

            // 마크다운 제거 (```json [ ] ``` 형태일 경우 대비)
            aiText = aiText.replace("```json", "").replace("```", "").trim();

            // [ ] 부분만 추출 (가장 안전한 방법)
            int start = aiText.indexOf("[");
            int end = aiText.lastIndexOf("]");
            if (start != -1 && end != -1) {
                aiText = aiText.substring(start, end + 1);

                JSONArray titles = (JSONArray) parser.parse(new StringReader(aiText));
                for (Object t : titles) {
                    titleList.add((String) t);
                }
            } else {
                System.out.println("⚠AI 응답이 JSON 형식이 아닙니다: " + aiText);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return titleList;
    }
}
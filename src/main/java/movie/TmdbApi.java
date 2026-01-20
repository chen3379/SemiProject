package movie;

import java.io.BufferedReader;
import java.io.IOException; // 추가
import java.io.InputStream; // 추가
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties; // 추가

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class TmdbApi {

    // 1. 값을 여기서 바로 넣지 않고 비워둡니다. (static 블록에서 채울 예정)
    private static final String API_KEY;

    // 2. 스태틱 초기화 블록: 클래스가 로딩될 때 딱 1번 실행됨
    static {
        String key = "";
        try {
            // secret.properties 파일 읽기
            InputStream input = TmdbApi.class.getClassLoader().getResourceAsStream("secret2.properties");

            if (input != null) {
                Properties prop = new Properties();
                prop.load(input);

                // 파일에 저장한 이름("TMDB_KEY")으로 값을 가져옴
                key = prop.getProperty("TMDB_KEY");
            } else {
                System.out.println("❌ 오류: secret.properties 파일을 찾을 수 없습니다.");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // 가져온 키를 변수에 저장
        API_KEY = key;
    }

    // 1. 영화 검색 (ID 찾기용)
    public List<MovieDto> searchMovie(String query) {
        List<MovieDto> list = new ArrayList<>();
        try {
            String encodedQuery = URLEncoder.encode(query, "UTF-8");
            // ★ 위에서 로딩된 API_KEY가 자동으로 들어갑니다.
            String apiURL = "https://api.themoviedb.org/3/search/movie?api_key=" + API_KEY + "&query=" + encodedQuery
                    + "&language=ko-KR&page=1";

            URL url = new URL(apiURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
            br.close();

            JSONParser parser = new JSONParser();
            JSONObject jsonObj = (JSONObject) parser.parse(new StringReader(sb.toString()));
            JSONArray results = (JSONArray) jsonObj.get("results");

            for (int i = 0; i < results.size(); i++) {
                JSONObject movie = (JSONObject) results.get(i);
                MovieDto dto = new MovieDto();
                dto.setTitle((String) movie.get("title"));
                String releaseDate = (String) movie.get("release_date");
                dto.setReleaseDay(releaseDate != null ? releaseDate : "");
                String posterPath = (String) movie.get("poster_path");
                if (posterPath != null)
                    dto.setPosterPath("https://image.tmdb.org/t/p/w500" + posterPath);
                else
                    dto.setPosterPath("");

                Long id = (Long) movie.get("id");
                dto.setMovieId(String.valueOf(id));

                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. 영화 상세 정보 조회
    public MovieDto getMovieDetail(String movieId) {
        MovieDto dto = new MovieDto();

        try {
            // ★ API_KEY 사용
            String apiURL = "https://api.themoviedb.org/3/movie/" + movieId + "?api_key=" + API_KEY
                    + "&language=ko-KR&append_to_response=credits,videos";

            URL url = new URL(apiURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
            br.close();

            JSONParser parser = new JSONParser();
            JSONObject movie = (JSONObject) parser.parse(new StringReader(sb.toString()));

            // --- 기본 정보 ---
            dto.setMovieId(String.valueOf(movie.get("id")));
            dto.setTitle((String) movie.get("title"));
            dto.setSummary((String) movie.get("overview"));
            dto.setReleaseDay((String) movie.get("release_date"));

            String posterPath = (String) movie.get("poster_path");
            if (posterPath != null)
                dto.setPosterPath("https://image.tmdb.org/t/p/w500" + posterPath);
            else
                dto.setPosterPath("no_image.jpg");

            // --- 1. 장르 ---
            JSONArray genres = (JSONArray) movie.get("genres");
            if (genres != null && genres.size() > 0) {
                JSONObject firstGenre = (JSONObject) genres.get(0);
                dto.setGenre((String) firstGenre.get("name"));
            } else {
                dto.setGenre("기타");
            }

            // --- 2. 국가 ---
            JSONArray countries = (JSONArray) movie.get("production_countries");
            if (countries != null && countries.size() > 0) {
                JSONObject firstCountry = (JSONObject) countries.get(0);
                dto.setCountry((String) firstCountry.get("name"));
            } else {
                dto.setCountry("");
            }

            // --- 3. 출연진/감독 ---
            JSONObject credits = (JSONObject) movie.get("credits");

            JSONArray crew = (JSONArray) credits.get("crew");
            for (int i = 0; i < crew.size(); i++) {
                JSONObject person = (JSONObject) crew.get(i);
                if ("Director".equals(person.get("job"))) {
                    dto.setDirector((String) person.get("name"));
                    break;
                }
            }

            JSONArray cast = (JSONArray) credits.get("cast");
            String castList = "";
            int limit = 5;
            if (cast.size() < 5)
                limit = cast.size();

            for (int i = 0; i < limit; i++) {
                JSONObject person = (JSONObject) cast.get(i);
                castList += person.get("name");
                if (i < limit - 1)
                    castList += ", ";
            }
            dto.setCast(castList);

            // --- 4. 트레일러 ---
            JSONObject videos = (JSONObject) movie.get("videos");
            JSONArray results = (JSONArray) videos.get("results");
            String trailerUrl = "";

            for (int i = 0; i < results.size(); i++) {
                JSONObject video = (JSONObject) results.get(i);
                String site = (String) video.get("site");
                String type = (String) video.get("type");

                if ("YouTube".equals(site) && "Trailer".equals(type)) {
                    String key = (String) video.get("key");
                    trailerUrl = "https://www.youtube.com/watch?v=" + key;
                    break;
                }
            }
            dto.setTrailerUrl(trailerUrl);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }

    // 3. 인기 영화 목록 가져오기
    public List<MovieDto> getPopularMovies(int page) {
        List<MovieDto> list = new ArrayList<>();

        try {
            // ★ API_KEY 사용
            String apiURL = "https://api.themoviedb.org/3/movie/popular?api_key=" + API_KEY + "&language=ko-KR&page="
                    + page;

            URL url = new URL(apiURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
            br.close();

            JSONParser parser = new JSONParser();
            JSONObject jsonObj = (JSONObject) parser.parse(new StringReader(sb.toString()));
            JSONArray results = (JSONArray) jsonObj.get("results");

            for (int i = 0; i < results.size(); i++) {
                JSONObject movie = (JSONObject) results.get(i);
                Long id = (Long) movie.get("id");

                MovieDto detailDto = getMovieDetail(String.valueOf(id));
                list.add(detailDto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
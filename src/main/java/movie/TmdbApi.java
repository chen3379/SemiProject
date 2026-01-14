package movie;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader; // ★필수
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class TmdbApi {

    private static final String API_KEY = "ad1da2a3deb0224907e6338100b5177d";

    // 1. 영화 검색 (ID 찾기용 - 기존 유지)
    public List<MovieDto> searchMovie(String query) {
        List<MovieDto> list = new ArrayList<>();
        try {
            String encodedQuery = URLEncoder.encode(query, "UTF-8");
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
                dto.setMovieId(String.valueOf(id)); // 이 ID가 중요함

                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. ★ 영화 상세 정보 조회 (여기가 핵심입니다!) ★
    // ID를 받아서 모든 정보를 긁어옵니다.
    public MovieDto getMovieDetail(String movieId) {
        MovieDto dto = new MovieDto();

        try {
            // URL 생성: credits(출연진), videos(트레일러)를 한번에 요청 (append_to_response)
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
                dto.setPosterPath("no_image.jpg"); // 대체 이미지 처리

            // --- 1. 장르 (대표 장르 1개만) ---
            JSONArray genres = (JSONArray) movie.get("genres");
            if (genres != null && genres.size() > 0) {
                JSONObject firstGenre = (JSONObject) genres.get(0);
                dto.setGenre((String) firstGenre.get("name"));
            } else {
                dto.setGenre("기타");
            }

            // --- 2. 국가 (제작 국가 1개만) ---
            JSONArray countries = (JSONArray) movie.get("production_countries");
            if (countries != null && countries.size() > 0) {
                JSONObject firstCountry = (JSONObject) countries.get(0);
                dto.setCountry((String) firstCountry.get("name")); // 한국어 이름 (예: 대한민국)
            } else {
                dto.setCountry("");
            }

            // --- 3. 출연진/감독 (credits) ---
            JSONObject credits = (JSONObject) movie.get("credits");

            // 3-1. 감독 찾기 (crew 배열에서 job이 Director인 사람)
            JSONArray crew = (JSONArray) credits.get("crew");
            for (int i = 0; i < crew.size(); i++) {
                JSONObject person = (JSONObject) crew.get(i);
                if ("Director".equals(person.get("job"))) {
                    dto.setDirector((String) person.get("name"));
                    break; // 감독 한 명만 찾으면 탈출
                }
            }

            // 3-2. 출연진 찾기 (cast 배열에서 상위 5명만 뽑아서 콤마로 연결)
            JSONArray cast = (JSONArray) credits.get("cast");
            String castList = "";
            int limit = 5; // 최대 5명
            if (cast.size() < 5)
                limit = cast.size();

            for (int i = 0; i < limit; i++) {
                JSONObject person = (JSONObject) cast.get(i);
                castList += person.get("name");
                if (i < limit - 1)
                    castList += ", ";
            }
            dto.setCast(castList);

            // --- 4. 트레일러 (videos) ---
            JSONObject videos = (JSONObject) movie.get("videos");
            JSONArray results = (JSONArray) videos.get("results");
            String trailerUrl = "";

            // YouTube이면서 Trailer인 영상 찾기
            for (int i = 0; i < results.size(); i++) {
                JSONObject video = (JSONObject) results.get(i);
                String site = (String) video.get("site");
                String type = (String) video.get("type");

                if ("YouTube".equals(site) && "Trailer".equals(type)) {
                    String key = (String) video.get("key"); // 유튜브 영상 ID
                    trailerUrl = "https://www.youtube.com/watch?v=" + key;
                    break; // 하나 찾으면 탈출
                }
            }
            dto.setTrailerUrl(trailerUrl);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }

    // 3. 인기 영화 목록 가져오기 (대량 등록용)
    public List<MovieDto> getPopularMovies(int page) {
        List<MovieDto> list = new ArrayList<>();

        try {
            // 인기 영화 목록 요청 URL (page 파라미터로 1페이지(1~20위), 2페이지(21~40위) 조절 가능)
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

            // 목록에서 ID만 뽑아서 상세 조회(getMovieDetail)를 다시 실행 (그래야 감독, 트레일러 등이 완벽하게 들어옴)
            for (int i = 0; i < results.size(); i++) {
                JSONObject movie = (JSONObject) results.get(i);
                Long id = (Long) movie.get("id");

                // ★ 위에서 만든 상세 조회 메서드 재활용! (감독, 배우, 트레일러 다 가져옴)
                MovieDto detailDto = getMovieDetail(String.valueOf(id));
                list.add(detailDto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}